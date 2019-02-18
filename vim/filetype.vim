
" .INI file for MSDOS
au BufNewFile,BufRead *.conf			setf dosini

au BufNewFile,BufRead *.yang			setf yang
au BufNewFile,BufRead *.lark			setf lark

" Kconfig file
au BufNewFile,BufRead *Mconfig			setf kconfig

" 6WIND doc.files
au BufNewFile,BufRead doc.files			setf docfiles

au BufNewFile,BufRead components		setf make
au BufNewFile,BufRead *.inc			setf rst

au BufRead,BufNewFile /etc/nginx/*		setf nginx

au BufRead,BufNewFile *.NEWS			setf debchangelog
