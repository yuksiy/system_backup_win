@echo off

net stop "サービス名"
if errorlevel 1 exit /b 1

