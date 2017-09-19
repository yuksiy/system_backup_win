@echo off

rem ==============================================================================
rem   機能
rem     fs_check.batのラッパースクリプト
rem   構文
rem     system_backup_dev_check.bat
rem
rem   Copyright (c) 2007-2017 Yukio Shiiya
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

set LANG=ja_JP.SJIS

rem **********************************************************************
rem * 変数定義
rem **********************************************************************
rem ユーザ変数
call "%ALLUSERSPROFILE%\system_backup\env.bat"
if errorlevel 1 exit /b 1

rem システム環境 依存変数

rem プログラム内部変数
set FS_CHECK=%SCRIPT_ROOT%\fs_check.bat

rem **********************************************************************
rem * メインルーチン
rem **********************************************************************

rem 前回のログファイルの全削除
if not "%BKUP_CHECK_LOG_1%"=="" if exist "%BKUP_CHECK_LOG_1%" del /f /q "%BKUP_CHECK_LOG_1%"
if not "%BKUP_CHECK_LOG_2%"=="" if exist "%BKUP_CHECK_LOG_2%" del /f /q "%BKUP_CHECK_LOG_2%"
if not "%DEV_CHECK_LOG%"==""    if exist "%DEV_CHECK_LOG%"    del /f /q "%DEV_CHECK_LOG%"

if not "%BKUP_DEV_1%"=="" (
	call %FS_CHECK% "%BKUP_MNT_1%" %BKUP_CHK_OPT_1% 2>&1 | tee "%BKUP_CHECK_LOG_1%"
	rem if errorlevel 1 exit /b 1
)
if not "%BKUP_DEV_2%"=="" (
	call %FS_CHECK% "%BKUP_MNT_2%" %BKUP_CHK_OPT_2% 2>&1 | tee "%BKUP_CHECK_LOG_2%"
	rem if errorlevel 1 exit /b 1
)

