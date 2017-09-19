@echo off

rem ==============================================================================
rem   �@�\
rem     �V�X�e�����o�b�N�A�b�v����
rem   �\��
rem     USAGE �Q��
rem
rem   Copyright (c) 2004-2017 Yukio Shiiya
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
	pause & exit /b 1
)

rem �E�B���h�E�^�C�g���̐ݒ�
title %~nx0 %*

for /f "tokens=1" %%i in ('echo %~f0') do set SCRIPT_FULL_NAME=%%i
for /f "tokens=1" %%i in ('echo %~dp0') do set SCRIPT_ROOT=%%i
for /f "tokens=1" %%i in ('echo %~nx0') do set SCRIPT_NAME=%%i
set RAND=%RANDOM%

set CYGWIN=nodosfilewarning
set LANG=ja_JP.SJIS

rem **********************************************************************
rem * �ϐ���`
rem **********************************************************************
rem ���[�U�ϐ�
call "%ALLUSERSPROFILE%\system_backup\env.bat"
if errorlevel 1 exit /b 1

rem �V�X�e���� �ˑ��ϐ�

rem �v���O���������ϐ�
set SYSTEM_BACKUP_RUN=set
set CHOICE=choice.exe
set SYSTEM_BACKUP_DEV_CHECK=%SCRIPT_ROOT%\system_backup_dev_check.bat
set SYSTEM_BACKUP_DEV_CHECK_LOG_CHECK=%SCRIPT_ROOT%\system_backup_dev_check_log_check.bat
set SYSTEM_BACKUP_DEV_MOUNT=%SCRIPT_ROOT%\system_backup_dev_mount.bat
set SYSTEM_BACKUP_DEV_UMOUNT=%SCRIPT_ROOT%\system_backup_dev_umount.bat
set ECHO_LOG=%SCRIPT_ROOT%\system_backup_echo_log.bat
set GET_CONFIG_LIST=%SCRIPT_ROOT%\get_config_list.bat
set SYSTEM_BACKUP_GET_FILE_LIST=%ALLUSERSPROFILE%\system_backup\get_file_list.bat
set SYSTEM_BACKUP_LOG_CHECK=%SCRIPT_ROOT%\system_backup_log_check.bat
set SYSTEM_BACKUP_BACKUP=%ALLUSERSPROFILE%\system_backup\backup.bat

rem set DEBUG=TRUE
set TMP_DIR=%LOCALAPPDATA%\Temp
set SCRIPT_TMP_DIR=%TMP_DIR%\%SCRIPT_NAME%
set SCRIPT_LOCK_FILE=%TMP_DIR%\%SCRIPT_NAME%.lock
set SVC_LOG_TMP=%SCRIPT_TMP_DIR%\svc_log.tmp

rem **********************************************************************
rem * �T�u���[�`����` (�P�Ǝ��s��)
rem **********************************************************************
:def_subroutine_1
goto end_def_subroutine_1

rem ��ƊJ�n�O����
:PRE_PROCESS
	rem ���b�N�t�@�C���̍쐬
	if exist "%SCRIPT_LOCK_FILE%" (
		echo -E lock file already exists -- %SCRIPT_LOCK_FILE% 1>&2
		exit /b 1
	) else (
		copy /y nul "%SCRIPT_LOCK_FILE%" > nul 2>&1
	)
	rem �O��̈ꎞ�f�B���N�g���̍폜
	if exist "%SCRIPT_TMP_DIR%" (
		rem �f�B���N�g������łȂ�(=�z��O��)�ꍇ���폜�����
		rmdir /s /q "%SCRIPT_TMP_DIR%"
	)
	rem �ꎞ�f�B���N�g���̍쐬
	mkdir "%SCRIPT_TMP_DIR%"
goto :EOF

rem ��ƏI���㏈��
:POST_PROCESS
	rem �ꎞ�f�B���N�g���̍폜
	if not "%DEBUG%"=="TRUE" (
		if exist "%SCRIPT_TMP_DIR%" (
			rem �f�B���N�g������łȂ�(=�z��O��)�ꍇ���폜�����
			rem rmdir /s /q "%SCRIPT_TMP_DIR%"
			rem �f�B���N�g������łȂ�(=�z��O��)�ꍇ�͍폜����Ȃ�
			rmdir "%SCRIPT_TMP_DIR%"
		)
	)
	rem ���b�N�t�@�C���̍폜
	del /f /q "%SCRIPT_LOCK_FILE%"
goto :EOF

rem �O��̃��O�t�@�C���̑S�폜
:DEL_LOG_PREV
	for %%i in (%LOG_DIR%) do if exist %%~si\nul (
		for /f "tokens=1" %%j in ('dir /ad /b "%LOG_DIR%"') do (
			rmdir /s /q "%LOG_DIR%\%%j"
		)
		del /f /q "%LOG_DIR%\*.*"
	)
	rem if not "%BKUP_MOUNT_LOG_1%"==""  if exist "%BKUP_MOUNT_LOG_1%"  del /f /q "%BKUP_MOUNT_LOG_1%"
	rem if not "%BKUP_MOUNT_LOG_2%"==""  if exist "%BKUP_MOUNT_LOG_2%"  del /f /q "%BKUP_MOUNT_LOG_2%"
	rem if not "%BKUP_UMOUNT_LOG_1%"=="" if exist "%BKUP_UMOUNT_LOG_1%" del /f /q "%BKUP_UMOUNT_LOG_1%"
	rem if not "%BKUP_UMOUNT_LOG_2%"=="" if exist "%BKUP_UMOUNT_LOG_2%" del /f /q "%BKUP_UMOUNT_LOG_2%"
	if not "%BKUP_CHECK_LOG_1%"==""  if exist "%BKUP_CHECK_LOG_1%"  del /f /q "%BKUP_CHECK_LOG_1%"
	if not "%BKUP_CHECK_LOG_2%"==""  if exist "%BKUP_CHECK_LOG_2%"  del /f /q "%BKUP_CHECK_LOG_2%"
	if not "%DEV_CHECK_LOG%"==""     if exist "%DEV_CHECK_LOG%"     del /f /q "%DEV_CHECK_LOG%"
goto :EOF

rem ����̃��O�t�@�C���̑S�ړ�
:MOVE_LOG_NOW
	if not "%LOG_DIR%"=="" (
		for /f "tokens=1" %%i in ('dir /ad /b "%SCRIPT_TMP_DIR%"') do (
			xcopy /s /e /i /h /y "%SCRIPT_TMP_DIR%\%%i\*.*" "%LOG_DIR%\%%i" > nul 2>&1
			rmdir /s /q "%SCRIPT_TMP_DIR%\%%i"
		)
		move /y "%SCRIPT_TMP_DIR%\*.*" "%LOG_DIR%\" > nul 2>&1
	)
goto :EOF

rem MAIN_LOG �̏�����
:INIT_MAIN_LOG
	call :OUTPUT_FILE_HEADER > "%SCRIPT_TMP_DIR%\%MAIN_LOG%" 2>&1
goto :EOF

rem �W���u�J�n���b�Z�[�W�̕\��
:SHOW_MSG_JOB_START
	call "%ECHO_LOG%" "%SCRIPT_TMP_DIR%\%MAIN_LOG%" "System backup job has started."
goto :EOF

rem �W���u�I�����b�Z�[�W�̕\��
:SHOW_MSG_JOB_END
	call "%ECHO_LOG%" "%SCRIPT_TMP_DIR%\%MAIN_LOG%" "System backup job has ended."
	rem ��ʂ�MAIN_LOG �ɉ��s��ǉ��o��
	echo. | tee -a "%SCRIPT_TMP_DIR%\%MAIN_LOG%"
goto :EOF

rem �T�[�r�X�̋N��
:START_SVC
	call :START_SVC_SUB
goto :EOF

rem �T�[�r�X�̒�~
:STOP_SVC
	call :STOP_SVC_SUB
goto :EOF

rem �V�X�e���\�����̎擾
:GET_CONFIG_LIST
	call "%ECHO_LOG%" "%SCRIPT_TMP_DIR%\%MAIN_LOG%" "�V�X�e���\�����̎擾��..."
	call "%GET_CONFIG_LIST%" "%SCRIPT_TMP_DIR%"
goto :EOF

rem ���[�U�f�[�^�t�@�C�����X�g�̎擾
:GET_FILE_LIST
	call "%SYSTEM_BACKUP_GET_FILE_LIST%"
goto :EOF

rem �o�b�N�A�b�v����
:SYSTEM_BACKUP_BACKUP
	if not "%ROBOCOPY_LOG%"=="" (
		call "%ECHO_LOG%" "%SCRIPT_TMP_DIR%\%MAIN_LOG%" "�o�b�N�A�b�v�����̎��s��..."
		if exist "%SYSTEM_BACKUP_BACKUP%" (
			call "%SYSTEM_BACKUP_BACKUP%"
		)
	)
goto :EOF

rem �o�b�N�A�b�v��f�o�C�X�̃`�F�b�N
:DEV_CHECK
	if "%CHECK_AUTO%"=="TRUE" (
		if "%MOUNT_TYPE%"=="local" (
			rem �o�b�N�A�b�v��f�o�C�X�̃}�E���g����
			call :DEV_UMOUNT_SUB 2>&1 | tee -a "%SCRIPT_TMP_DIR%\%MAIN_LOG%"
			rem �o�b�N�A�b�v��f�o�C�X�̃`�F�b�N
			call :DEV_CHECK_SUB
			rem �o�b�N�A�b�v��f�o�C�X�̃}�E���g
			call :DEV_MOUNT_SUB 2>&1 | tee -a "%SCRIPT_TMP_DIR%\%MAIN_LOG%"
		) else if "%MOUNT_TYPE%"=="remote" (
			rem ���s���Ȃ�
		)
	) else if "%CHECK_AUTO%"=="FALSE" (
		rem ���s���Ȃ�
	)
goto :EOF

rem �o�b�N�A�b�v��f�o�C�X�̃}�E���g
:DEV_MOUNT
	if "%MOUNT_AUTO%"=="TRUE" (
		call :DEV_MOUNT_SUB
	) else if "%MOUNT_AUTO%"=="FALSE" (
		rem ���s���Ȃ�
	)
goto :EOF

rem �o�b�N�A�b�v��f�o�C�X�̃}�E���g����
:DEV_UMOUNT
	if "%MOUNT_AUTO%"=="TRUE" (
		call :DEV_UMOUNT_SUB
	) else if "%MOUNT_AUTO%"=="FALSE" (
		rem ���s���Ȃ�
	)
goto :EOF

rem CHECK_LOG �̐���
:OUTPUT_CHECK_LOG
	call "%SYSTEM_BACKUP_LOG_CHECK%"
goto :EOF

rem CHECK_LOG �̕\��
:SHOW_CHECK_LOG
	echo -I CHECK_LOG �̕\�����J�n���܂�
	type "%SCRIPT_TMP_DIR%\%CHECK_LOG%"
	if not errorlevel 0 (
		echo -E CHECK_LOG �̕\�����ُ�I�����܂��� 1>&2
		rem �㑱�������l�����A�����ł�exit���Ȃ� rem call :POST_PROCESS & exit /b 1
	) else (
		echo -I CHECK_LOG �̕\��������I�����܂���
		rem �㑱�������l�����A�����ł�exit���Ȃ� rem exit /b 0
	)
	echo.
goto :EOF

rem DEV_CHECK_LOG �̐���
:OUTPUT_DEV_CHECK_LOG
	if "%CHECK_AUTO%"=="TRUE" (
		if "%MOUNT_TYPE%"=="local" (
			rem DEV_CHECK_LOG �̐���
			call "%SYSTEM_BACKUP_DEV_CHECK_LOG_CHECK%" > nul 2>&1
			rem DEV_CHECK_LOG �̕\��
			call :SHOW_DEV_CHECK_LOG
		) else if "%MOUNT_TYPE%"=="remote" (
			rem ���s���Ȃ�
		)
	) else if "%CHECK_AUTO%"=="FALSE" (
		rem ���s���Ȃ�
	)
goto :EOF

:FUNC_FULL
	call :PRE_PROCESS
	if not "%errorlevel%"=="0" exit /b %errorlevel%
	call :SHOW_MENU
	if not "%errorlevel%"=="0" exit /b %errorlevel%
	call :DEV_MOUNT
	if not "%errorlevel%"=="0" exit /b %errorlevel%
	call :DEL_LOG_PREV
	if not "%errorlevel%"=="0" exit /b %errorlevel%
	call :INIT_MAIN_LOG
	if not "%errorlevel%"=="0" exit /b %errorlevel%
	call :SHOW_MSG_JOB_START
	if not "%errorlevel%"=="0" exit /b %errorlevel%
	call :GET_CONFIG_LIST
	if not "%errorlevel%"=="0" exit /b %errorlevel%
	call :STOP_SVC
	if not "%errorlevel%"=="0" exit /b %errorlevel%
	call :GET_FILE_LIST
	if not "%errorlevel%"=="0" exit /b %errorlevel%
	call :SYSTEM_BACKUP_BACKUP
	if not "%errorlevel%"=="0" exit /b %errorlevel%
	call :DEV_CHECK
	if not "%errorlevel%"=="0" exit /b %errorlevel%
	call :START_SVC
	if not "%errorlevel%"=="0" exit /b %errorlevel%
	call :SHOW_MSG_JOB_END
	if not "%errorlevel%"=="0" exit /b %errorlevel%
	call :OUTPUT_CHECK_LOG
	if not "%errorlevel%"=="0" exit /b %errorlevel%
	call :SHOW_CHECK_LOG
	if not "%errorlevel%"=="0" exit /b %errorlevel%
	call :OUTPUT_DEV_CHECK_LOG
	if not "%errorlevel%"=="0" exit /b %errorlevel%
	call :MOVE_LOG_NOW
	if not "%errorlevel%"=="0" exit /b %errorlevel%
	call :DEV_UMOUNT
	if not "%errorlevel%"=="0" exit /b %errorlevel%
	call :POST_PROCESS
	if not "%errorlevel%"=="0" exit /b %errorlevel%
goto :EOF

:end_def_subroutine_1

rem **********************************************************************
rem * �T�u���[�`����` (�P�Ǝ��s�s��)
rem **********************************************************************
:def_subroutine_2
goto end_def_subroutine_2

:USAGE
	echo Usage:                1>&2
	echo     system_backup.bat 1>&2
goto :EOF

rem ���j���[�̕\��
:SHOW_MENU
	echo.
	echo --------------------------------------
	echo Operation Mode Selector system_backup
	echo --------------------------------------
	echo.
	echo    1. Continue
	echo    2. Cancel
	echo.
	echo Select operation mode. (Default: %MENU_DEFAULT%)
	%CHOICE% /c 12 /t %MENU_TIMEOUT% /d %MENU_DEFAULT%
	rem Cancel
	if errorlevel 2 call :POST_PROCESS & exit /b 1
	if errorlevel 1 exit /b 0
goto :EOF

rem �o�̓t�@�C�����ʃw�b�_�[�̐���
:OUTPUT_FILE_HEADER
	echo ==============================================================================
	echo   This file is automatically created by system backup job.
	echo ==============================================================================
	echo.
goto :EOF

rem �T�[�r�X�̋N�� (SUB)
:START_SVC_SUB
	if not "%SVC_START%"=="" (
		call "%ECHO_LOG%" "%SCRIPT_TMP_DIR%\%MAIN_LOG%" "�T�[�r�X�̋N����..."
		call "%SVC_START%" > "%SVC_LOG_TMP%" 2>&1
		set SVC_RC=%ERRORLEVEL%
		type "%SVC_LOG_TMP%" | tee -a "%SCRIPT_TMP_DIR%\%MAIN_LOG%"
		del "%SVC_LOG_TMP%"
		if !SVC_RC! neq 0 (
			call "%ECHO_LOG%" "%SCRIPT_TMP_DIR%\%MAIN_LOG%" "�T�[�r�X�̋N�����ُ�I�����܂���"
			call :POST_PROCESS & exit /b 1
		)
	)
goto :EOF

rem �T�[�r�X�̒�~ (SUB)
:STOP_SVC_SUB
	if not "%SVC_STOP%"=="" (
		call "%ECHO_LOG%" "%SCRIPT_TMP_DIR%\%MAIN_LOG%" "�T�[�r�X�̒�~��..."
		call "%SVC_STOP%" > "%SVC_LOG_TMP%" 2>&1
		set SVC_RC=%ERRORLEVEL%
		type "%SVC_LOG_TMP%" | tee -a "%SCRIPT_TMP_DIR%\%MAIN_LOG%"
		del "%SVC_LOG_TMP%"
		if !SVC_RC! neq 0 (
			call "%ECHO_LOG%" "%SCRIPT_TMP_DIR%\%MAIN_LOG%" "�T�[�r�X�̒�~���ُ�I�����܂���"
			call :POST_PROCESS & exit /b 1
		)
	)
goto :EOF

rem �o�b�N�A�b�v��f�o�C�X�̃`�F�b�N (SUB)
:DEV_CHECK_SUB
	call "%ECHO_LOG%" "%SCRIPT_TMP_DIR%\%MAIN_LOG%" "�o�b�N�A�b�v��f�o�C�X�̃`�F�b�N��..."
	call "%SYSTEM_BACKUP_DEV_CHECK%" > nul 2>&1
	rem if errorlevel 1 goto DEV_CHECK_SUB
goto :EOF

rem �o�b�N�A�b�v��f�o�C�X�̃}�E���g (SUB)
:DEV_MOUNT_SUB
	call "%SYSTEM_BACKUP_DEV_MOUNT%"
	if errorlevel 1 goto DEV_MOUNT_SUB
goto :EOF

rem �o�b�N�A�b�v��f�o�C�X�̃}�E���g���� (SUB)
:DEV_UMOUNT_SUB
	call "%SYSTEM_BACKUP_DEV_UMOUNT%"
	if errorlevel 1 goto DEV_UMOUNT_SUB
goto :EOF

rem DEV_CHECK_LOG �̕\��
:SHOW_DEV_CHECK_LOG
	echo -I DEV_CHECK_LOG �̕\�����J�n���܂�
	type "%DEV_CHECK_LOG%"
	if not errorlevel 0 (
		echo -E DEV_CHECK_LOG �̕\�����ُ�I�����܂��� 1>&2
		rem �㑱�������l�����A�����ł�exit���Ȃ� rem call :POST_PROCESS & exit /b 1
	) else (
		echo -I DEV_CHECK_LOG �̕\��������I�����܂���
		rem �㑱�������l�����A�����ł�exit���Ȃ� rem exit /b 0
	)
	echo.
goto :EOF

:end_def_subroutine_2

rem **********************************************************************
rem * ���C�����[�`��
rem **********************************************************************

call :FUNC_FULL

