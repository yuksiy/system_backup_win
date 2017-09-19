@echo off

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
	exit /b 1
)

rem ウィンドウタイトルの設定
title %~nx0 %*

for /f "tokens=1" %%i in ('echo %~f0') do set SCRIPT_FULL_NAME=%%i
for /f "tokens=1" %%i in ('echo %~dp0') do set SCRIPT_ROOT=%%i
for /f "tokens=1" %%i in ('echo %~nx0') do set SCRIPT_NAME=%%i

rem **********************************************************************
rem * 変数定義
rem **********************************************************************
rem ユーザ変数
call "%ALLUSERSPROFILE%\system_backup\env.bat"
if errorlevel 1 exit /b 1

rem システム環境 依存変数

rem プログラム内部変数
set ECHO_LOG=system_backup_echo_log.bat

rem **********************************************************************
rem * メインルーチン
rem **********************************************************************

if "%SYSTEM_BACKUP_RUN%"=="" exit /b 0
if not exist "%SCRIPT_TMP_DIR%" exit /b 0

rem ユーザデータファイルリストの取得
call :GET_FILE_LIST_SUB %GET_FILE_LIST_DIR_ARG_SUFFIX%
goto :EOF

:GET_FILE_LIST_SUB
	if "%~1"=="" goto :EOF
	for /f "tokens=1" %%i in ('echo %~1') do set arg=%%i
	for /f "tokens=2" %%i in ('echo %~1') do set suffix=%%i
	call "%ECHO_LOG%" "%SCRIPT_TMP_DIR%\%MAIN_LOG%" "ユーザデータファイルリスト(%arg%)の取得中..."
	dir /a /s /on "%arg%" > "%SCRIPT_TMP_DIR%\FILE_LIST-%suffix%.LOG" 2>&1
	shift
	goto GET_FILE_LIST_SUB
goto :EOF

