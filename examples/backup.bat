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
set DEST_ROOT=\DAT

set ROBOCOPY_SRC_LIST=%ALLUSERSPROFILE%\system_backup\src_list.txt
set ROBOCOPY_DEST_DIR=%BKUP_MNT_1%:%DEST_ROOT%\%COMPUTERNAME%
set ROBOCOPY_CUT_DIRS_NUM=1
set ROBOCOPY_DIR_OPTIONS=/np /njh /njs /mir
set ROBOCOPY_FILE_OPTIONS=/np /njh /njs

rem システム環境 依存変数

rem プログラム内部変数
set ROBOCOPY_BACKUP=robocopy_backup.sh

rem **********************************************************************
rem * メインルーチン
rem **********************************************************************

start /min /wait cmd.exe /c "bash --login -i '%ROBOCOPY_BACKUP%' -C %ROBOCOPY_CUT_DIRS_NUM% --robocopy-dir-options='%ROBOCOPY_DIR_OPTIONS%' --robocopy-file-options='%ROBOCOPY_FILE_OPTIONS%' '%ROBOCOPY_SRC_LIST%' '%ROBOCOPY_DEST_DIR%' 2>&1 | tee '%SCRIPT_TMP_DIR%\%ROBOCOPY_LOG%'"

