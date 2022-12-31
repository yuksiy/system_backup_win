@echo off

rem ==============================================================================
rem   �@�\
rem     log_check_system_backup_win.sh�̃��b�p�[�X�N���v�g
rem   �\��
rem     system_backup_log_check.bat
rem
rem   Copyright (c) 2004-2023 Yukio Shiiya
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
set DOS2UNIX=dos2unix.exe
set UNIX2DOS=unix2dos.exe

rem �v���O���������ϐ�
for /f "tokens=1" %%i in ('cygpath -u "%SCRIPT_ROOT%\log_check_system_backup_win.sh"') do set LOG_CHECK_SYSTEM_BACKUP_WIN=%%i

rem **********************************************************************
rem * ���C�����[�`��
rem **********************************************************************

(bash --login -i "%LOG_CHECK_SYSTEM_BACKUP_WIN%") 2>&1 | %UNIX2DOS% > "%SCRIPT_TMP_DIR%\%CHECK_LOG%"

