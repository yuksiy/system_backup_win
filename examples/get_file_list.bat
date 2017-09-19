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
call "%ALLUSERSPROFILE%\system_backup\env.bat"
if errorlevel 1 exit /b 1

rem �V�X�e���� �ˑ��ϐ�

rem �v���O���������ϐ�
set ECHO_LOG=system_backup_echo_log.bat

rem **********************************************************************
rem * ���C�����[�`��
rem **********************************************************************

if "%SYSTEM_BACKUP_RUN%"=="" exit /b 0
if not exist "%SCRIPT_TMP_DIR%" exit /b 0

rem ���[�U�f�[�^�t�@�C�����X�g�̎擾
call :GET_FILE_LIST_SUB %GET_FILE_LIST_DIR_ARG_SUFFIX%
goto :EOF

:GET_FILE_LIST_SUB
	if "%~1"=="" goto :EOF
	for /f "tokens=1" %%i in ('echo %~1') do set arg=%%i
	for /f "tokens=2" %%i in ('echo %~1') do set suffix=%%i
	call "%ECHO_LOG%" "%SCRIPT_TMP_DIR%\%MAIN_LOG%" "���[�U�f�[�^�t�@�C�����X�g(%arg%)�̎擾��..."
	dir /a /s /on "%arg%" > "%SCRIPT_TMP_DIR%\FILE_LIST-%suffix%.LOG" 2>&1
	shift
	goto GET_FILE_LIST_SUB
goto :EOF

