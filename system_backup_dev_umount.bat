@echo off

rem ==============================================================================
rem   �@�\
rem     fs_umount.bat�̃��b�p�[�X�N���v�g
rem   �\��
rem     system_backup_dev_umount.bat
rem
rem   Copyright (c) 2005-2017 Yukio Shiiya
rem
rem   This software is released under the MIT License.
rem   https://opensource.org/licenses/MIT
rem ==============================================================================

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
call "%ALLUSERSPROFILE%\system_backup\env.bat"
if errorlevel 1 exit /b 1

rem �V�X�e���� �ˑ��ϐ�

rem �v���O���������ϐ�
set FS_UMOUNT=%SCRIPT_ROOT%\fs_umount.bat

rem **********************************************************************
rem * ���C�����[�`��
rem **********************************************************************

rem �O��̃��O�t�@�C���̑S�폜
if not "%BKUP_UMOUNT_LOG_1%"=="" if exist "%BKUP_UMOUNT_LOG_1%" del /f /q "%BKUP_UMOUNT_LOG_1%"
if not "%BKUP_UMOUNT_LOG_2%"=="" if exist "%BKUP_UMOUNT_LOG_2%" del /f /q "%BKUP_UMOUNT_LOG_2%"

if not "%BKUP_DEV_1%"=="" (
	call %FS_UMOUNT% %MOUNT_TYPE% "%BKUP_DEV_1%" "%BKUP_MNT_1%" %BKUP_UMNT_OPT_1%
	if errorlevel 1 exit /b 1
)
if not "%BKUP_DEV_2%"=="" (
	call %FS_UMOUNT% %MOUNT_TYPE% "%BKUP_DEV_2%" "%BKUP_MNT_2%" %BKUP_UMNT_OPT_2%
	if errorlevel 1 exit /b 1
)

