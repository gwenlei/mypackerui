:: create the cygwin directory
mkdir %SystemDrive%\cygwin

:: Fetch cygwin
set URL=http://192.168.0.82:9090/static/cygwin/7z1512.exe
bitsadmin /transfer Zip_setup /download /priority normal %URL% %SystemDrive%\cygwin\7z1512.exe

set URL=http://192.168.0.82:9090/static/cygwin/cygwinlocal.zip
bitsadmin /transfer cygwin-zip /download /priority normal %URL% %SystemDrive%\cygwin\cygwinlocal.zip

start /wait %SystemDrive%\cygwin\7z1512.exe /S /v/qn
"%ProgramFiles(x86)%\7-zip\7z.exe" x %SystemDrive%\cygwin\cygwinlocal.zip -o%SystemDrive%\windows\temp

set URL=http://192.168.0.82:9090/static/cygwin/setup-x86_64.exe
bitsadmin /transfer cygwin-setup /download /priority normal %URL% %SystemDrive%\cygwin\cygwin-setup-x86_64.exe

:: goto a temp directory and install
cd /D %SystemDrive%\windows\temp

:: packages -- comma separated
set PACKAGES=cygrunsrv,makepasswd,nano,openssh,rsync

%SystemDrive%\cygwin\cygwin-setup-x86_64.exe -a x86_64 -X -d -q -R %SystemDrive%\cygwin -P %PACKAGES% -L

:: Resolve the path with %~dp0 - for easy execution in both test and prod.
set _PATH=%~dp0install-cygwin-sshd.sh

:: Windows path -> linux path, i.d., replace \ with /
set _LINUX_PATH=%_PATH:\=/%

:: Execute the bash part
%SystemDrive%\cygwin\bin\bash -l -c %_LINUX_PATH%

:: Firewall Rules
netsh advfirewall firewall add rule name="sshd" dir=in action=allow program="%SystemDrive%\cygwin\usr\sbin\sshd.exe" enable=yes
netsh advfirewall firewall add rule name="ssh" dir=in action=allow protocol=TCP localport=22

:: Start at last -- server is powered off by packer when ssh is avail. 
net start sshd
