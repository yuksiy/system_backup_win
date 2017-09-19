@echo off

rem ユーザ変数
set MENU_DEFAULT=1
set MENU_TIMEOUT=10

set MOUNT_TYPE=local
set MOUNT_AUTO=TRUE
set CHECK_AUTO=FALSE

set BKUP_DEV_1=WINNTBKUP
set BKUP_DEV_FS_1=ntfs
set BKUP_MNT_1=X
set BKUP_MNT_OPT_1=
set BKUP_UMNT_OPT_1=
set BKUP_CHK_OPT_1=/f
set BKUP_MOUNT_LOG_1=%LOCALAPPDATA%\Temp\mount-1.log
set BKUP_UMOUNT_LOG_1=%LOCALAPPDATA%\Temp\umount-1.log
set BKUP_CHECK_LOG_1=%LOCALAPPDATA%\Temp\chkdsk-1.log

set BKUP_DEV_2=
set BKUP_DEV_FS_2=
set BKUP_MNT_2=
set BKUP_MNT_OPT_2=
set BKUP_UMNT_OPT_2=
set BKUP_CHK_OPT_2=
set BKUP_MOUNT_LOG_2=
set BKUP_UMOUNT_LOG_2=
set BKUP_CHECK_LOG_2=

set LOG_ROOT=\LOG
set LOG_DIR=%BKUP_MNT_1%:%LOG_ROOT%\%COMPUTERNAME%

set DEST_ROOT=\DAT
set DEST_DIR=%BKUP_MNT_1%:%DEST_ROOT%\%COMPUTERNAME%

set MAIN_LOG=@main.log
set CHECK_LOG=@check.log
set DEV_CHECK_LOG=%LOCALAPPDATA%\Temp\chkdsk-check.log

set ROBOCOPY_LOG=robocopy.log

set SVC_START=%ALLUSERSPROFILE%\system_backup\svc_start.bat
set SVC_STOP=%ALLUSERSPROFILE%\system_backup\svc_stop.bat

set GET_FILE_LIST_DIR_ARG_SUFFIX="C:\,C_ROOT"

rem システム環境 依存変数
if "%PROCESSOR_ARCHITECTURE%"=="AMD64" (
	set CYGWINROOT=%SystemDrive%\cygwin64
) else (
	set CYGWINROOT=%SystemDrive%\cygwin
)
set PATH=%CYGWINROOT%\usr\sbin;%CYGWINROOT%\bin;%PATH%

