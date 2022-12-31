@echo off

rem ==============================================================================
rem   機能
rem     前回のログファイルを全削除する
rem   構文
rem     system_backup_log_del.bat
rem
rem   Copyright (c) 2006-2023 Yukio Shiiya
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
set CHOICE=choice.exe
set SYSTEM_BACKUP_DEV_MOUNT=%SCRIPT_ROOT%\system_backup_dev_mount.bat
set SYSTEM_BACKUP_DEV_UMOUNT=%SCRIPT_ROOT%\system_backup_dev_umount.bat

rem **********************************************************************
rem * サブルーチン定義
rem **********************************************************************
:def_subroutine
goto end_def_subroutine

:PRE_PROCESS
	rem バックアップ先デバイスのマウント
	if "%MOUNT_AUTO%"=="TRUE" (
		call :DEV_MOUNT
	) else if "%MOUNT_AUTO%"=="FALSE" (
		rem 実行しない
	)

	%BKUP_MNT_1%:
goto :EOF

:POST_PROCESS
	%SystemDrive%

	rem バックアップ先デバイスのマウント解除
	if "%MOUNT_AUTO%"=="TRUE" (
		call :DEV_UMOUNT
	) else if "%MOUNT_AUTO%"=="FALSE" (
		rem 実行しない
	)
goto :EOF

rem バックアップ先デバイスのマウント
:DEV_MOUNT
	call "%SYSTEM_BACKUP_DEV_MOUNT%"
	if errorlevel 1 goto DEV_MOUNT
	rem if "%DEBUG%"=="TRUE" goto :EOF
goto :EOF

rem バックアップ先デバイスのマウント解除
:DEV_UMOUNT
	call "%SYSTEM_BACKUP_DEV_UMOUNT%"
	if errorlevel 1 goto DEV_UMOUNT
	rem if "%DEBUG%"=="TRUE" goto :EOF
goto :EOF

:end_def_subroutine

rem **********************************************************************
rem * メインルーチン
rem **********************************************************************

rem 作業開始前処理
call :PRE_PROCESS

for /f "tokens=1" %%i in ('dir /b /ad /on "%LOG_ROOT%\"') do (
	rem 削除対象ファイルの確認
	echo + dir /a /on "%LOG_ROOT%\%%i"
	       dir /a /on "%LOG_ROOT%\%%i"

	rem 削除確認
	echo -Q Remove? 1>&2
	%CHOICE% /c YN
	rem YES の場合
	if !errorlevel! equ 1 (
		for /f "tokens=1" %%j in ('dir /ad /b "%LOG_ROOT%\%%i"') do (
			echo + rmdir /s /q "%LOG_ROOT%\%%i\%%j"
			       rmdir /s /q "%LOG_ROOT%\%%i\%%j"
		)
		echo + del /f /q "%LOG_ROOT%\%%i\*.*"
		       del /f /q "%LOG_ROOT%\%%i\*.*"
		rem 削除対象ファイルの確認
		echo + dir /a /on "%LOG_ROOT%\%%i"
		       dir /a /on "%LOG_ROOT%\%%i"
	rem NO の場合
	) else (
		echo -W Skipping... 1>&2
	)
	pause
)

rem 作業終了後処理
call :POST_PROCESS & exit /b 0

