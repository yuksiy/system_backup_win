@echo off

rem ==============================================================================
rem   機能
rem     log_check_system_backup_win.shのラッパースクリプト
rem   構文
rem     system_backup_log_check.bat
rem
rem   Copyright (c) 2004-2023 Yukio Shiiya
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
set DOS2UNIX=dos2unix.exe
set UNIX2DOS=unix2dos.exe

rem プログラム内部変数
for /f "tokens=1" %%i in ('cygpath -u "%SCRIPT_ROOT%\log_check_system_backup_win.sh"') do set LOG_CHECK_SYSTEM_BACKUP_WIN=%%i

rem **********************************************************************
rem * メインルーチン
rem **********************************************************************

(bash --login -i "%LOG_CHECK_SYSTEM_BACKUP_WIN%") 2>&1 | %UNIX2DOS% > "%SCRIPT_TMP_DIR%\%CHECK_LOG%"

