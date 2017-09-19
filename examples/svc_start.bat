@echo off

net start "サービス名"
if errorlevel 1 exit /b 1

