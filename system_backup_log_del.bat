@echo off

rem ==============================================================================
rem   �@�\
rem     �O��̃��O�t�@�C����S�폜����
rem   �\��
rem     system_backup_log_del.bat
rem
rem   Copyright (c) 2006-2023 Yukio Shiiya
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
set CHOICE=choice.exe
set SYSTEM_BACKUP_DEV_MOUNT=%SCRIPT_ROOT%\system_backup_dev_mount.bat
set SYSTEM_BACKUP_DEV_UMOUNT=%SCRIPT_ROOT%\system_backup_dev_umount.bat

rem **********************************************************************
rem * �T�u���[�`����`
rem **********************************************************************
:def_subroutine
goto end_def_subroutine

:PRE_PROCESS
	rem �o�b�N�A�b�v��f�o�C�X�̃}�E���g
	if "%MOUNT_AUTO%"=="TRUE" (
		call :DEV_MOUNT
	) else if "%MOUNT_AUTO%"=="FALSE" (
		rem ���s���Ȃ�
	)

	%BKUP_MNT_1%:
goto :EOF

:POST_PROCESS
	%SystemDrive%

	rem �o�b�N�A�b�v��f�o�C�X�̃}�E���g����
	if "%MOUNT_AUTO%"=="TRUE" (
		call :DEV_UMOUNT
	) else if "%MOUNT_AUTO%"=="FALSE" (
		rem ���s���Ȃ�
	)
goto :EOF

rem �o�b�N�A�b�v��f�o�C�X�̃}�E���g
:DEV_MOUNT
	call "%SYSTEM_BACKUP_DEV_MOUNT%"
	if errorlevel 1 goto DEV_MOUNT
	rem if "%DEBUG%"=="TRUE" goto :EOF
goto :EOF

rem �o�b�N�A�b�v��f�o�C�X�̃}�E���g����
:DEV_UMOUNT
	call "%SYSTEM_BACKUP_DEV_UMOUNT%"
	if errorlevel 1 goto DEV_UMOUNT
	rem if "%DEBUG%"=="TRUE" goto :EOF
goto :EOF

:end_def_subroutine

rem **********************************************************************
rem * ���C�����[�`��
rem **********************************************************************

rem ��ƊJ�n�O����
call :PRE_PROCESS

for /f "tokens=1" %%i in ('dir /b /ad /on "%LOG_ROOT%\"') do (
	rem �폜�Ώۃt�@�C���̊m�F
	echo + dir /a /on "%LOG_ROOT%\%%i"
	       dir /a /on "%LOG_ROOT%\%%i"

	rem �폜�m�F
	echo -Q Remove? 1>&2
	%CHOICE% /c YN
	rem YES �̏ꍇ
	if !errorlevel! equ 1 (
		for /f "tokens=1" %%j in ('dir /ad /b "%LOG_ROOT%\%%i"') do (
			echo + rmdir /s /q "%LOG_ROOT%\%%i\%%j"
			       rmdir /s /q "%LOG_ROOT%\%%i\%%j"
		)
		echo + del /f /q "%LOG_ROOT%\%%i\*.*"
		       del /f /q "%LOG_ROOT%\%%i\*.*"
		rem �폜�Ώۃt�@�C���̊m�F
		echo + dir /a /on "%LOG_ROOT%\%%i"
		       dir /a /on "%LOG_ROOT%\%%i"
	rem NO �̏ꍇ
	) else (
		echo -W Skipping... 1>&2
	)
	pause
)

rem ��ƏI���㏈��
call :POST_PROCESS & exit /b 0

