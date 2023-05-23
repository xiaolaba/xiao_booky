
SET mypath=%~dp0
echo %mypath:~0,-1%

set file=myPDF


copy %file%.pdf c:\booky\temp.pdf /y
copy %file%_booky.txt c:\booky\booky.txt /y
copy logsheet.pdf c:\booky\logsheet.pdf /y
copy booky.sh c:\booky\booky.sh /y

::pause 

c:
cd booky
dir
bash booky.sh temp.pdf booky.txt

::copy temp_binder.pdf "%mypath%%file%_binder.pdf" /y
copy temp_booky.pdf "%mypath%%file%_booky.pdf" /y


e:
cd mypath
:::: build BDF for server upload
:: copy_to_BDFserver_dwg_folder_no_sub_folder.bat
pause

