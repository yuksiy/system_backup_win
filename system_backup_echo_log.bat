@echo off

rem ==============================================================================
rem   �@�\
rem     ���O���b�Z�[�W����ʂƃ��O�t�@�C���ɏo�͂���
rem   �\��
rem     system_backup_echo_log.bat ���O�t�@�C���� ���O���b�Z�[�W
rem
rem   Copyright (c) 2012-2017 Yukio Shiiya
rem
rem   This software is released under the MIT License.
rem   https://opensource.org/licenses/MIT
rem ==============================================================================

echo %DATE% %TIME:~0,-3% %~2 2>&1 | tee -a "%~1"

