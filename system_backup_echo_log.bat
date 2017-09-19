@echo off

rem ==============================================================================
rem   機能
rem     ログメッセージを画面とログファイルに出力する
rem   構文
rem     system_backup_echo_log.bat ログファイル名 ログメッセージ
rem
rem   Copyright (c) 2012-2017 Yukio Shiiya
rem
rem   This software is released under the MIT License.
rem   https://opensource.org/licenses/MIT
rem ==============================================================================

echo %DATE% %TIME:~0,-3% %~2 2>&1 | tee -a "%~1"

