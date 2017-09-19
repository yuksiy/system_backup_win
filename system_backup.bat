@echo off

rem ==============================================================================
rem   機能
rem     システムをバックアップする
rem   構文
rem     USAGE 参照
rem
rem   Copyright (c) 2004-2017 Yukio Shiiya
rem
rem   This software is released under the MIT License.
rem   https://opensource.org/licenses/MIT
rem ==============================================================================

rem **********************************************************************
rem * 基本設定
rem **********************************************************************
rem 環境変数のローカライズ開始
setlocal

rem 遅延環境変数展開の有効化
verify other 2>nul
setlocal enabledelayedexpansion
if errorlevel 1 (
	echo -E Unable to enable delayedexpansion 1>&2
	pause & exit /b 1
)

rem ウィンドウタイトルの設定
title %~nx0 %*

for /f "tokens=1" %%i in ('echo %~f0') do set SCRIPT_FULL_NAME=%%i
for /f "tokens=1" %%i in ('echo %~dp0') do set SCRIPT_ROOT=%%i
for /f "tokens=1" %%i in ('echo %~nx0') do set SCRIPT_NAME=%%i
set RAND=%RANDOM%

set CYGWIN=nodosfilewarning
set LANG=ja_JP.SJIS

rem **********************************************************************
rem * 変数定義
rem **********************************************************************
rem ユーザ変数
call "%ALLUSERSPROFILE%\system_backup\env.bat"
if errorlevel 1 exit /b 1

rem システム環境 依存変数

rem プログラム内部変数
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
rem * サブルーチン定義 (単独実行可)
rem **********************************************************************
:def_subroutine_1
goto end_def_subroutine_1

rem 作業開始前処理
:PRE_PROCESS
	rem ロックファイルの作成
	if exist "%SCRIPT_LOCK_FILE%" (
		echo -E lock file already exists -- %SCRIPT_LOCK_FILE% 1>&2
		exit /b 1
	) else (
		copy /y nul "%SCRIPT_LOCK_FILE%" > nul 2>&1
	)
	rem 前回の一時ディレクトリの削除
	if exist "%SCRIPT_TMP_DIR%" (
		rem ディレクトリが空でない(=想定外の)場合も削除される
		rmdir /s /q "%SCRIPT_TMP_DIR%"
	)
	rem 一時ディレクトリの作成
	mkdir "%SCRIPT_TMP_DIR%"
goto :EOF

rem 作業終了後処理
:POST_PROCESS
	rem 一時ディレクトリの削除
	if not "%DEBUG%"=="TRUE" (
		if exist "%SCRIPT_TMP_DIR%" (
			rem ディレクトリが空でない(=想定外の)場合も削除される
			rem rmdir /s /q "%SCRIPT_TMP_DIR%"
			rem ディレクトリが空でない(=想定外の)場合は削除されない
			rmdir "%SCRIPT_TMP_DIR%"
		)
	)
	rem ロックファイルの削除
	del /f /q "%SCRIPT_LOCK_FILE%"
goto :EOF

rem 前回のログファイルの全削除
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

rem 今回のログファイルの全移動
:MOVE_LOG_NOW
	if not "%LOG_DIR%"=="" (
		for /f "tokens=1" %%i in ('dir /ad /b "%SCRIPT_TMP_DIR%"') do (
			xcopy /s /e /i /h /y "%SCRIPT_TMP_DIR%\%%i\*.*" "%LOG_DIR%\%%i" > nul 2>&1
			rmdir /s /q "%SCRIPT_TMP_DIR%\%%i"
		)
		move /y "%SCRIPT_TMP_DIR%\*.*" "%LOG_DIR%\" > nul 2>&1
	)
goto :EOF

rem MAIN_LOG の初期化
:INIT_MAIN_LOG
	call :OUTPUT_FILE_HEADER > "%SCRIPT_TMP_DIR%\%MAIN_LOG%" 2>&1
goto :EOF

rem ジョブ開始メッセージの表示
:SHOW_MSG_JOB_START
	call "%ECHO_LOG%" "%SCRIPT_TMP_DIR%\%MAIN_LOG%" "System backup job has started."
goto :EOF

rem ジョブ終了メッセージの表示
:SHOW_MSG_JOB_END
	call "%ECHO_LOG%" "%SCRIPT_TMP_DIR%\%MAIN_LOG%" "System backup job has ended."
	rem 画面とMAIN_LOG に改行を追加出力
	echo. | tee -a "%SCRIPT_TMP_DIR%\%MAIN_LOG%"
goto :EOF

rem サービスの起動
:START_SVC
	call :START_SVC_SUB
goto :EOF

rem サービスの停止
:STOP_SVC
	call :STOP_SVC_SUB
goto :EOF

rem システム構成情報の取得
:GET_CONFIG_LIST
	call "%ECHO_LOG%" "%SCRIPT_TMP_DIR%\%MAIN_LOG%" "システム構成情報の取得中..."
	call "%GET_CONFIG_LIST%" "%SCRIPT_TMP_DIR%"
goto :EOF

rem ユーザデータファイルリストの取得
:GET_FILE_LIST
	call "%SYSTEM_BACKUP_GET_FILE_LIST%"
goto :EOF

rem バックアップ処理
:SYSTEM_BACKUP_BACKUP
	if not "%ROBOCOPY_LOG%"=="" (
		call "%ECHO_LOG%" "%SCRIPT_TMP_DIR%\%MAIN_LOG%" "バックアップ処理の実行中..."
		if exist "%SYSTEM_BACKUP_BACKUP%" (
			call "%SYSTEM_BACKUP_BACKUP%"
		)
	)
goto :EOF

rem バックアップ先デバイスのチェック
:DEV_CHECK
	if "%CHECK_AUTO%"=="TRUE" (
		if "%MOUNT_TYPE%"=="local" (
			rem バックアップ先デバイスのマウント解除
			call :DEV_UMOUNT_SUB 2>&1 | tee -a "%SCRIPT_TMP_DIR%\%MAIN_LOG%"
			rem バックアップ先デバイスのチェック
			call :DEV_CHECK_SUB
			rem バックアップ先デバイスのマウント
			call :DEV_MOUNT_SUB 2>&1 | tee -a "%SCRIPT_TMP_DIR%\%MAIN_LOG%"
		) else if "%MOUNT_TYPE%"=="remote" (
			rem 実行しない
		)
	) else if "%CHECK_AUTO%"=="FALSE" (
		rem 実行しない
	)
goto :EOF

rem バックアップ先デバイスのマウント
:DEV_MOUNT
	if "%MOUNT_AUTO%"=="TRUE" (
		call :DEV_MOUNT_SUB
	) else if "%MOUNT_AUTO%"=="FALSE" (
		rem 実行しない
	)
goto :EOF

rem バックアップ先デバイスのマウント解除
:DEV_UMOUNT
	if "%MOUNT_AUTO%"=="TRUE" (
		call :DEV_UMOUNT_SUB
	) else if "%MOUNT_AUTO%"=="FALSE" (
		rem 実行しない
	)
goto :EOF

rem CHECK_LOG の生成
:OUTPUT_CHECK_LOG
	call "%SYSTEM_BACKUP_LOG_CHECK%"
goto :EOF

rem CHECK_LOG の表示
:SHOW_CHECK_LOG
	echo -I CHECK_LOG の表示を開始します
	type "%SCRIPT_TMP_DIR%\%CHECK_LOG%"
	if not errorlevel 0 (
		echo -E CHECK_LOG の表示が異常終了しました 1>&2
		rem 後続処理を考慮し、ここではexitしない rem call :POST_PROCESS & exit /b 1
	) else (
		echo -I CHECK_LOG の表示が正常終了しました
		rem 後続処理を考慮し、ここではexitしない rem exit /b 0
	)
	echo.
goto :EOF

rem DEV_CHECK_LOG の生成
:OUTPUT_DEV_CHECK_LOG
	if "%CHECK_AUTO%"=="TRUE" (
		if "%MOUNT_TYPE%"=="local" (
			rem DEV_CHECK_LOG の生成
			call "%SYSTEM_BACKUP_DEV_CHECK_LOG_CHECK%" > nul 2>&1
			rem DEV_CHECK_LOG の表示
			call :SHOW_DEV_CHECK_LOG
		) else if "%MOUNT_TYPE%"=="remote" (
			rem 実行しない
		)
	) else if "%CHECK_AUTO%"=="FALSE" (
		rem 実行しない
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
rem * サブルーチン定義 (単独実行不可)
rem **********************************************************************
:def_subroutine_2
goto end_def_subroutine_2

:USAGE
	echo Usage:                1>&2
	echo     system_backup.bat 1>&2
goto :EOF

rem メニューの表示
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

rem 出力ファイル共通ヘッダーの生成
:OUTPUT_FILE_HEADER
	echo ==============================================================================
	echo   This file is automatically created by system backup job.
	echo ==============================================================================
	echo.
goto :EOF

rem サービスの起動 (SUB)
:START_SVC_SUB
	if not "%SVC_START%"=="" (
		call "%ECHO_LOG%" "%SCRIPT_TMP_DIR%\%MAIN_LOG%" "サービスの起動中..."
		call "%SVC_START%" > "%SVC_LOG_TMP%" 2>&1
		set SVC_RC=%ERRORLEVEL%
		type "%SVC_LOG_TMP%" | tee -a "%SCRIPT_TMP_DIR%\%MAIN_LOG%"
		del "%SVC_LOG_TMP%"
		if !SVC_RC! neq 0 (
			call "%ECHO_LOG%" "%SCRIPT_TMP_DIR%\%MAIN_LOG%" "サービスの起動が異常終了しました"
			call :POST_PROCESS & exit /b 1
		)
	)
goto :EOF

rem サービスの停止 (SUB)
:STOP_SVC_SUB
	if not "%SVC_STOP%"=="" (
		call "%ECHO_LOG%" "%SCRIPT_TMP_DIR%\%MAIN_LOG%" "サービスの停止中..."
		call "%SVC_STOP%" > "%SVC_LOG_TMP%" 2>&1
		set SVC_RC=%ERRORLEVEL%
		type "%SVC_LOG_TMP%" | tee -a "%SCRIPT_TMP_DIR%\%MAIN_LOG%"
		del "%SVC_LOG_TMP%"
		if !SVC_RC! neq 0 (
			call "%ECHO_LOG%" "%SCRIPT_TMP_DIR%\%MAIN_LOG%" "サービスの停止が異常終了しました"
			call :POST_PROCESS & exit /b 1
		)
	)
goto :EOF

rem バックアップ先デバイスのチェック (SUB)
:DEV_CHECK_SUB
	call "%ECHO_LOG%" "%SCRIPT_TMP_DIR%\%MAIN_LOG%" "バックアップ先デバイスのチェック中..."
	call "%SYSTEM_BACKUP_DEV_CHECK%" > nul 2>&1
	rem if errorlevel 1 goto DEV_CHECK_SUB
goto :EOF

rem バックアップ先デバイスのマウント (SUB)
:DEV_MOUNT_SUB
	call "%SYSTEM_BACKUP_DEV_MOUNT%"
	if errorlevel 1 goto DEV_MOUNT_SUB
goto :EOF

rem バックアップ先デバイスのマウント解除 (SUB)
:DEV_UMOUNT_SUB
	call "%SYSTEM_BACKUP_DEV_UMOUNT%"
	if errorlevel 1 goto DEV_UMOUNT_SUB
goto :EOF

rem DEV_CHECK_LOG の表示
:SHOW_DEV_CHECK_LOG
	echo -I DEV_CHECK_LOG の表示を開始します
	type "%DEV_CHECK_LOG%"
	if not errorlevel 0 (
		echo -E DEV_CHECK_LOG の表示が異常終了しました 1>&2
		rem 後続処理を考慮し、ここではexitしない rem call :POST_PROCESS & exit /b 1
	) else (
		echo -I DEV_CHECK_LOG の表示が正常終了しました
		rem 後続処理を考慮し、ここではexitしない rem exit /b 0
	)
	echo.
goto :EOF

:end_def_subroutine_2

rem **********************************************************************
rem * メインルーチン
rem **********************************************************************

call :FUNC_FULL

