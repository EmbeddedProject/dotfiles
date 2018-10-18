#!/usr/bin/env python3

from datetime import datetime, timedelta
import argparse
import logging
import time

import MySQLdb


LOG = logging.getLogger(__name__)


#------------------------------------------------------------------------------
class BugzillaDB:

    def __init__(self, host, port, user, passwd, db, days=1):
        self.cache = {}
        self.queries = 0
        self.cached = 0
        self.start_date = (datetime.now() - timedelta(days=days)).strftime('%Y-%m-%d')
        self.db = MySQLdb.connect(host=host, port=port,
                                  db=db, user=user, passwd=passwd,
                                  charset='utf8', use_unicode=True)

    def req(self, sql, *args, one=False):
        key = sql % args
        LOG.debug('query: %s', key)
        if key in self.cache:
            self.cached += 1
            LOG.debug('response(cached): %s', self.cache[key])
            return self.cache[key]

        cur = self.db.cursor()
        try:
            cur.execute(sql, args)
            self.queries += 1
            if one:
                res = cur.fetchone()
            else:
                res = cur.fetchall()
            LOG.debug('response: %s', res)
            self.cache[key] = res
            return res
        finally:
            cur.close()

    def get_user_tags(self, userid):
        return self.req('SELECT id, name FROM tag WHERE user_id = %s', userid)

    def get_field_activity(self, name, bug):
        sql = '''SELECT added FROM bugs_activity
                 WHERE bug_id = %s AND DATE(bug_when) >= %s AND fieldid IN (
                     SELECT id FROM fielddefs WHERE name = %s)'''
        return [added for added, in
                self.req(sql, bug, self.start_date, name)]

    def userid_to_realname(self, userid):
        return self.req('SELECT realname FROM profiles WHERE userid = %s',
                        userid, one=True)[0]

    def username_to_userid(self, username):
        sql = '''SELECT userid FROM profiles
                 WHERE disabledtext = '' AND login_name LIKE %s'''
        return self.req(sql, '%' + username + '%', one=True)[0]

    def get_comments(self, bug, not_userid):
        sql = '''SELECT l.thetext, p.realname, l.type, l.extra_data
                 FROM longdescs as l JOIN profiles AS p ON l.who = p.userid
                 WHERE l.bug_id = %s AND DATE(l.bug_when) >= %s
                 AND l.who != %s AND l.thetext NOT LIKE "%%/cgit.cgi/%%"'''
        res =  self.req(sql, bug, self.start_date, not_userid)
        for text, user, comment_type, x in res:
            if comment_type == 0: # real comment
                yield text, user
            elif comment_type == 1:
                yield '%s has been marked as a duplicate of this bug.' % x, user
            elif comment_type == 2:
                yield 'This bug has been marked as a duplicate of %s.' % x, user

    def get_bugs_containing(self, key):
        sql = '''SELECT bug_id FROM longdescs
                 WHERE DATE(bug_when) >= %s AND thetext LIKE %s'''
        for bug_id, in self.req(sql, self.start_date, '%' + key + '%'):
            yield bug_id

    def bugid_to_desc(self, bug_id):
        return self.req('SELECT short_desc FROM bugs WHERE bug_id = %s',
                        bug_id, one=True)[0]

    def get_bugs_activity(self):
        sql = 'SELECT bug_id FROM bugs WHERE DATE(lastdiffed) >= %s'
        for bug_id, in self.req(sql, self.start_date):
            yield bug_id

    def get_bugs_tags(self, tag_id):
        sql = '''SELECT bug_id FROM bug_tag
                 WHERE tag_id = %s ORDER BY bug_id ASC'''
        for bug_id, in self.req(sql, tag_id):
            yield bug_id

    def get_bugs_keyword(self, keyword):
        sql = '''SELECT DISTINCT k.bug_id
                 FROM keywords AS k
                     JOIN keyworddefs AS d ON k.keywordid = d.id
                     JOIN bugs as b ON b.bug_id = k.bug_id
                 WHERE d.name = %s AND DATE(b.lastdiffed) >= %s'''
        for bug_id, in self.req(sql, keyword, self.start_date):
            yield bug_id

    def get_bugs_cc(self, userid):
        sql = '''SELECT b.bug_id
                 FROM cc as c JOIN bugs AS b ON c.bug_id = b.bug_id
                 WHERE c.who = %s AND DATE(b.lastdiffed) >= %s'''
        return [b for b, in self.req(sql, userid, self.start_date)]

    def get_bugs_assigned(self, userid):
        sql = '''SELECT bug_id FROM bugs
                 WHERE assigned_to = %s AND DATE(lastdiffed) >= %s'''
        return [b for b, in self.req(sql, userid, self.start_date)]


#------------------------------------------------------------------------------
def get_pr_info(db, bug, userid):
    # retrieve PR info: if anything has changed here, it will be displayed
    info = []
    status = db.get_field_activity('bug_status', bug)
    if status:
        info.append('  status changed = %s' % ' -> '.join(status))
    assign = db.get_field_activity('assigned_to', bug)
    if assign:
        info.append('  assignation changed = %s' %' -> '.join(assign))
    priority = db.get_field_activity("priority", bug)
    if priority:
        info.append('  priority changed = %s' % ' -> '.join(priority))
    severity = db.get_field_activity("bug_severity", bug)
    if severity:
        info.append('  severity changed = %s' % ' -> '.join(severity))

    if info:
        # if we display info, also display tags
        tags = []
        for tag_id, tagname in db.get_user_tags(userid):
            if bug in set(db.get_bugs_tags(tag_id)):
                tags.append(tagname)
        if tags:
            info.append('  tags = %s' % ' '.join(tags))

    comments = []
    for comment, author in db.get_comments(bug, userid):
        comments.append('')
        comments.append('  ------- new comment from %s --------' % author)
        comments.append('')
        for line in comment.strip().splitlines():
            comments.append('  ' + line)

    return info, comments


#------------------------------------------------------------------------------
def dump_prs(db, title, bug_list, userid):
    infos = {}
    for bid in bug_list:
        info, comments = get_pr_info(db, bid, userid)
        if info or comments:
            infos[bid] = info, comments

    if not infos:
        return

    print()
    print(title)
    print('=' * len(title))
    print()
    print('http://core/bug6illa/buglist.cgi?quicksearch=' +
          '%2C'.join(map(str, bug_list)))

    for bid, (infos, comments) in sorted(infos.items(), key=lambda i: i[0]):
        print()
        print('- %s: %s' % (bid, db.bugid_to_desc(bid)))
        print('  http://core/bug6illa/show_bug.cgi?id=%d' % bid)
        for info in infos:
            print(info)
        for comment in comments:
            print(comment)


#------------------------------------------------------------------------------
def parse_args():
    p = argparse.ArgumentParser(
        description='''
        Display bugs with activity during the last days assigned to
        or with user as CC, or owning the specified keyword.
        ''')

    p.add_argument('username',
                   metavar='USERNAME',
                   help='''
                   The user for which to generate the activity.
                   ''')
    p.add_argument('-k', '--keyword',
                   help='''
                   Restrict to PRs that have this keyword set.
                   ''')
    p.add_argument('-d', '--days',
                   type=int,
                   default=1,
                   help='''
                   Number of days worth of activity to report (default: 1)
                   ''')
    p.add_argument('-v', '--verbose',
                   action='store_true',
                   help='''
                   Display debug information.
                   ''')

    g = p.add_argument_group('Bugzilla DB options')
    g.add_argument('-H', '--dbhost',
                   default='core',
                   help='''
                   The database host name/address (default: core).
                   ''')
    g.add_argument('-P', '--dbport',
                   default=3306,
                   type=int,
                   help='''
                   The database listening port (default: 3306).
                   ''')
    g.add_argument('-u', '--dbuser',
                   default='bugsviewer',
                   help='''
                   The database user (default: bugsviewer).
                   ''')
    g.add_argument('-p', '--dbpassword',
                   default='6bugsviewer',
                   help='''
                   The database user password (default: 6bugsviewer).
                   ''')
    g.add_argument('-b', '--dbname',
                   default='bugs',
                   help='''
                   The database name (default: bugs).
                   ''')

    return p.parse_args()


#------------------------------------------------------------------------------
def main():
    args = parse_args()

    logging.basicConfig(
        format='%(levelname)s: %(message)s',
        level=logging.DEBUG if args.verbose else logging.INFO)

    start = time.time()

    db = BugzillaDB(host=args.dbhost, port=args.dbport,
                    db=args.dbname, user=args.dbuser, passwd=args.dbpassword,
                    days=args.days)

    userid = db.username_to_userid(args.username)
    user_tags = db.get_user_tags(userid)

    # get all bugs that changed
    cc_bugs = set(db.get_bugs_activity())
    follow_bugs = set()

    # if keyword matches, move to follow_bugs
    if args.keyword:
        follow_bugs |= set(db.get_bugs_keyword(args.keyword)) & cc_bugs
        cc_bugs ^= cc_bugs & follow_bugs

    # if a tag matches, move to follow_bugs
    for tag_id, _ in user_tags:
        follow_bugs |= set(db.get_bugs_tags(tag_id)) & cc_bugs
        cc_bugs ^= (cc_bugs & follow_bugs)

    # add bugs containing robin to follow bugs
    follow_bugs |= set(db.get_bugs_containing('robin')) & cc_bugs
    follow_bugs |= set(db.get_bugs_containing('Robin')) & cc_bugs
    cc_bugs ^= (cc_bugs & follow_bugs)

    # if assigned matches, move to follow_bugs
    follow_bugs |= set(db.get_bugs_assigned(userid)) & cc_bugs
    cc_bugs ^= (cc_bugs & follow_bugs)

    # if cc does not match, remove from cc_bugs
    cc_bugs &= set(db.get_bugs_cc(userid))

    # remove maintenance/backport from cc_bugs
    bp_bugs = set()
    for bug in cc_bugs:
        title = db.bugid_to_desc(bug).lower()
        if 'maintenance' in title or 'backport' in title:
            bp_bugs |= set([bug])
    cc_bugs ^= bp_bugs

    LOG.debug('FOLLOW: %s', follow_bugs)
    LOG.debug('CC: %s', cc_bugs)
    LOG.debug('BP: %s', bp_bugs)

    print('Activity since: %s' % db.start_date)

    dump_prs(db, 'PR to follow', follow_bugs, userid)
    dump_prs(db, 'CC-ed PR list', cc_bugs, userid)
    dump_prs(db, 'Backport CC-ed PR list', bp_bugs, userid)

    print()
    print('done in %d SQL requests (+%s cached), took %s seconds'
          % (db.queries, db.cached, time.time() - start))


if __name__ == '__main__':
    main()
