@echo off

rem ==============================================================================
rem   機能
rem     fs_umount.batのラッパースクリプト
rem   構文
rem     system_backup_dev_umount.bat
rem
rem   Copyright (c) 2005-2017 Yukio Shiiya
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

rem プログラム内部変数
set FS_UMOUNT=%SCRIPT_ROOT%\fs_umount.bat

rem **********************************************************************
rem * メインルーチン
rem **********************************************************************

rem 前回のログファイルの全削除
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

