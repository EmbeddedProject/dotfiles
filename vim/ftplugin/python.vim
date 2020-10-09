setlocal shiftwidth=4
setlocal tabstop=4
setlocal expandtab
setlocal softtabstop=4
setlocal formatoptions=vcq
setlocal nosmartindent
setlocal cindent
setlocal completeopt-=preview

py3 << EOF
import os
import subprocess

venv = os.path.abspath('.venv')

if os.path.isdir(venv):
    os.environ['VIRTUAL_ENV'] = venv
try:
    dirs = []
    for f in subprocess.check_output(
             ['git', 'ls-files', '**setup.py'],
             stderr=subprocess.DEVNULL, encoding='utf-8').split():
        dirs.append(os.path.dirname(f) or '.')
    os.environ['PYTHONPATH'] = ':'.join(dirs)
except subprocess.CalledProcessError:
    pass
EOF
