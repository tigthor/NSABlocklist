@ECHO off
::
REM Please st the homedir_utorrent to the location of your current "%homedir_utorrent%\ipfilter.dat"
::
set homedir_utorrent=%appdata%\uTorrent
set filter_list=http://www.deluge-torrent.org/blocklist/nipfilter.dat.gz

::
REM BEGIN MAGIC
::
set sizenew=0
set sizeold=0
cd "%homedir_utorrent%"
wget.exe -r --tries=3 %filter_list% -O "%homedir_utorrent%\nipfilter.dat.gz"
7za.exe -y -onewfilter e nipfilter.dat.gz
IF EXIST  "%homedir_utorrent%\newfilter\ipfilter.dat" GOTO getsize_new
IF NOT EXIST  "%homedir_utorrent%\newfilter\ipfilter.dat" GOTO download_failed
:return_new
IF NOT EXIST "%homedir_utorrent%\ipfilter.dat" GOTO KeepNew_only
IF EXIST  "%homedir_utorrent%\ipfilter.dat" GOTO getsize_old
:return_old
ECHO New file size = %sizenew%
ECHO Old file size = %sizeold%
IF %sizeold% GTR %sizenew% GOTO keep_old_less
IF %sizeold% LSS %sizenew% GOTO keep_new
IF %sizeold% EQU %sizenew% GOTO keep_current

::
REM Find file sizes
::
:getsize_new
dir /-c "%homedir_utorrent%\newfilter\ipfilter.dat" | find "ipfilter" > %homedir_utorrent%\temp.txt
for /f "tokens=1,2,3,4,5 delims= " %%i in ('type %homedir_utorrent%\temp.txt') do (
set sizenew=%%l
)
GOTO return_new

:getsize_old
dir /-c "%homedir_utorrent%\ipfilter.dat" | find "ipfilter" > %homedir_utorrent%\temp.txt
for /f "tokens=1,2,3,4,5 delims= " %%i in ('type %homedir_utorrent%\temp.txt') do (
set sizeold=%%l
)
GOTO return_old

::
REM Exit with errror level and file clean-up.
::
:keep_new
move "%homedir_utorrent%\ipfilter.dat" "%homedir_utorrent%\ipfilter.bak"
:KeepNew_only
IF NOT EXIST  "%homedir_utorrent%\ipfilter.bak" ECHO Backups were missing but are now created.
ECHO KEEPING NEW FILE.
IF NOT EXIST "%homedir_utorrent%\ipfilter.bak" copy "%homedir_utorrent%\newfilter\ipfilter.dat" "%homedir_utorrent%\ipfilter.bak"
move "%homedir_utorrent%\newfilter\ipfilter.dat" "%homedir_utorrent%\ipfilter.dat" 
IF EXIST %homedir_utorrent%\temp.txt del %homedir_utorrent%\temp.txt
EXIT /b 0

:keep_old_less
IF NOT EXIST "%homedir_utorrent%\ipfilter.bak" ECHO Backups were missing but are now created.
IF NOT EXIST "%homedir_utorrent%\ipfilter.bak" copy "%homedir_utorrent%\ipfilter.dat" "%homedir_utorrent%\ipfilter.bak"
ECHO Keeping old ipfilter.dat *NEW FILE IS SMALLER*.
del "%homedir_utorrent%\nipfilter.dat"
IF EXIST %homedir_utorrent%\temp.txt del %homedir_utorrent%\temp.txt
EXIT /b 3

:keep_current
ECHO Files are same size keeping current.
IF NOT EXIST  "%homedir_utorrent%\ipfilter.bak" ECHO Backups were missing but are now created.
IF NOT EXIST  "%homedir_utorrent%\ipfilter.bak" COPY "%homedir_utorrent%\ipfilter.dat" "%homedir_utorrent%\ipfilter.bak"
IF NOT EXIST  "%homedir_utorrent%\ipfilter.dat" IF EXIST  "%homedir_utorrent%\ipfilter.bak" ECHO Awesome found your backup!
IF EXIST  "%homedir_utorrent%\nipfilter.dat" del "%homedir_utorrent%\nipfilter.dat"
IF EXIST %homedir_utorrent%\temp.txt del %homedir_utorrent%\temp.txt
EXIT /b 0

:download_failed
ECHO Download failed keeping current file.
IF NOT EXIST  "%homedir_utorrent%\ipfilter.bak" IF EXIST "%homedir_utorrent%\ipfilter.dat" ECHO Backups were missing but are now created.
IF NOT EXIST  "%homedir_utorrent%\ipfilter.bak" copy "%homedir_utorrent%\ipfilter.dat" "%homedir_utorrent%\ipfilter.bak"
IF NOT EXIST  "%homedir_utorrent%\ipfilter.dat" ECHO Can't find your current file either!
IF NOT EXIST  "%homedir_utorrent%\ipfilter.dat" IF EXIST  "%homedir_utorrent%\ipfilter.bak" ECHO Awesome found your backup!
IF NOT EXIST  "%homedir_utorrent%\ipfilter.dat" copy "%homedir_utorrent%\ipfilter.bak" "%homedir_utorrent%\ipfilter.dat"
IF EXIST %homedir_utorrent%\temp.txt del %homedir_utorrent%\temp.txt
EXIT /b 255
