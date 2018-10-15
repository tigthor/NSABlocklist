cd \Util\Wget
wget http://upd.emule-security.org/ipfilter.zip
cd upd.emule-security.org
c:\util\unzip.exe ipfilter.zip
ren guarding.p2p ipfilter.dat
xcopy /d /y ipfilter.dat %appdata%\uTorrent\ipfilter.dat
del ipfilter.dat