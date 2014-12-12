-- statusbar_workspace.lua
--
-- Show current workspace name or number in the statusbar.
--
-- Put any of these in cfg_statusbar.lua's template-line:
--  %workspace_pager
--  %workspace_name_pager
--
-- This is an internal statusbar monitor and does NOT require
-- a dopath statement (effective after a 2006-02-12 build).
--
-- version 1
-- author: Rico Schiekel <fire at paranetic dot de>
--
-- version 2
-- added 2006-02-14 by Canaan Hadley-Voth:
--  * %workspace_pager shows a list of workspace numbers
--    with the current one indicated:
--
--    1i  2i  [3f]  4p  5c
--
--    i=WIonWS, f=WFloatWS, p=WPaneWS, c=WClientWin/other
--
--  * %workspace_frame - name of the active frame.
--
--  * Added statusbar_ to the filename (since it *is*
--    an internal statusbar monitor) so that it works without
--    a "dopath" call.
--
--  * Removed timer.  Only needs to run on hook.
--    Much faster this way.
--
-- version 3
-- update for ion-3rc-20070506 on 2007-05-09
-- by Kevin Granade <kevin dot granade at gmail dot com>
--
-- Updated to use new wx_ api
-- Replaced region_activated_hook with region_notify_hook
-- Added %workspace_name_pager, which works similarly to %workspace_pager,
--   but instead displays the name of each workspace
-- Added display for WGroupWS to %workspace_pager, displayed as 'g'
--

local function update_workspace()
	local scr = ioncore.find_screen_id(0)
	local curws = scr:mx_current()

	local pager = { }
	local name_pager = { }
	local name_pager_plus = { }
	local curindex = scr:get_index(curws)+1

	for i = 1, scr:mx_count(1) do
		tmpws = scr:mx_nth(i-1)
		if i == curindex then
			table.insert(pager, '['..(i)..']')
			table.insert(name_pager, '['..(i)..':'..tmpws:name()..']')
		else
			table.insert(pager, ' '..(i)..' ')
			table.insert(name_pager, ' '..(i)..':'..tmpws:name()..' ')
		end
	end

	ioncore.defer( function()
		mod_statusbar.inform('workspace_pager', table.concat(pager, ' '))
		mod_statusbar.inform('workspace_name_pager', table.concat(name_pager, ' '))
		mod_statusbar.update()
	end)
end

local function update_workspace_wrap(reg, how)
	if how ~= 'name' then
		return
	end

	update_workspace()
end

ioncore.get_hook('region_notify_hook'):add(update_workspace_wrap)
ioncore.get_hook('screen_managed_changed_hook'):add(update_workspace)
