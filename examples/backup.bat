@echo off

rem **********************************************************************
rem * ��{�ݒ�
rem **********************************************************************
rem ���ϐ��̃��[�J���C�Y�J�n
setlocal

rem �x�����ϐ��W�J�̗L����
verify other 2>nul
setlocal enabledelayedexpansion
if errorlevel 1 (
	echo -E Unable to enable delayedexpansion 1>&2
	exit /b 1
)

rem �E�B���h�E�^�C�g���̐ݒ�
title %~nx0 %*

for /f "tokens=1" %%i in ('echo %~f0') do set SCRIPT_FULL_NAME=%%i
for /f "tokens=1" %%i in ('echo %~dp0') do set SCRIPT_ROOT=%%i
for /f "tokens=1" %%i in ('echo %~nx0') do set SCRIPT_NAME=%%i

rem **********************************************************************
rem * �ϐ���`
rem **********************************************************************
rem ���[�U�ϐ�
set DEST_ROOT=\DAT

set ROBOCOPY_SRC_LIST=%ALLUSERSPROFILE%\system_backup\src_list.txt
set ROBOCOPY_DEST_DIR=%BKUP_MNT_1%:%DEST_ROOT%\%COMPUTERNAME%
set ROBOCOPY_CUT_DIRS_NUM=1
set ROBOCOPY_DIR_OPTIONS=/np /njh /njs /mir
set ROBOCOPY_FILE_OPTIONS=/np /njh /njs

rem �V�X�e���� �ˑ��ϐ�

rem �v���O���������ϐ�
set ROBOCOPY_BACKUP=robocopy_backup.sh

rem **********************************************************************
rem * ���C�����[�`��
rem **********************************************************************

start /min /wait cmd.exe /c "bash --login -i '%ROBOCOPY_BACKUP%' -C %ROBOCOPY_CUT_DIRS_NUM% --robocopy-dir-options='%ROBOCOPY_DIR_OPTIONS%' --robocopy-file-options='%ROBOCOPY_FILE_OPTIONS%' '%ROBOCOPY_SRC_LIST%' '%ROBOCOPY_DEST_DIR%' 2>&1 | tee '%SCRIPT_TMP_DIR%\%ROBOCOPY_LOG%'"

