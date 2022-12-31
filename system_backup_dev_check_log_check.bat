@echo off

rem ==============================================================================
rem   �@�\
rem     log_check_system_backup_dev_check_win.sh�̃��b�p�[�X�N���v�g
rem   �\��
rem     system_backup_dev_check_log_check.bat
rem
rem   Copyright (c) 2007-2023 Yukio Shiiya
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

set LANG=ja_JP.SJIS

rem **********************************************************************
rem * �ϐ���`
rem **********************************************************************
rem ���[�U�ϐ�
call "%ALLUSERSPROFILE%\system_backup\env.bat"
if errorlevel 1 exit /b 1

rem �V�X�e���� �ˑ��ϐ�
set DOS2UNIX=dos2unix.exe
set UNIX2DOS=unix2dos.exe

rem �v���O���������ϐ�
for /f "tokens=1" %%i in ('cygpath -u "%SCRIPT_ROOT%\log_check_system_backup_dev_check_win.sh"') do set LOG_CHECK_SYSTEM_BACKUP_DEV_CHECK_WIN=%%i

rem **********************************************************************
rem * ���C�����[�`��
rem **********************************************************************

rem �O��̃��O�t�@�C���̑S�폜
if not "%DEV_CHECK_LOG%"=="" if exist "%DEV_CHECK_LOG%" del /f /q "%DEV_CHECK_LOG%"

(%CYGWINROOT%\bin\bash.exe --login -i "%LOG_CHECK_SYSTEM_BACKUP_DEV_CHECK_WIN%") 2>&1 | %UNIX2DOS% | tee "%DEV_CHECK_LOG%"

