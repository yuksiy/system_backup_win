#!/bin/bash

# ==============================================================================
#   機能
#     BKUP_CHECK_LOG_Nの内容をチェックする
#   構文
#     log_check_system_backup_dev_check_win.sh
#
#   Copyright (c) 2007-2023 Yukio Shiiya
#
#   This software is released under the MIT License.
#   https://opensource.org/licenses/MIT
# ==============================================================================

######################################################################
# 基本設定
######################################################################
LANG=ja_JP.UTF-8

######################################################################
# 変数定義
######################################################################
# ユーザ変数
# 呼び出し元から継承

# システム環境 依存変数
EXTCODE2INT="nkf -w -x"
INTCODE2EXT="nkf -w -x"
INTCODE2DISP="nkf -s -x"

# プログラム内部変数
#LOG_CHECK="sh -x log_check.sh"
LOG_CHECK="log_check.sh"

######################################################################
# 関数定義
######################################################################
CMD_INTCODE2EXT() {
	(eval "`echo \"$*\" | ${INTCODE2EXT}`" 2>&1 | ${INTCODE2DISP})
	return
}

SKIP_FAIL_MSG_CHECK () {
	cat <<- EOF | ${INTCODE2DISP}
		-I 失敗メッセージチェックが省略されました -- "${LOG_FILE}"
	EOF
}
SKIP_END_MSG_CHECK () {
	cat <<- EOF | ${INTCODE2DISP}
		-I 終了メッセージチェックが省略されました -- "${LOG_FILE}"
	EOF
}

BKUP_CHECK_LOG_CHECK_FAT() {
	# 失敗メッセージチェック
	MSG_PATTERN='-F "ディスク上でエラーを検出しました。"'
	CMD_INTCODE2EXT "${LOG_CHECK} ${MSG_PATTERN} \"${LOG_FILE}\""
	sleep 1
	# 終了メッセージチェック
	MSG_PATTERN='-E "ファイル システムのチェックが終了しました。問題は見つかりませんでした。"'
	CMD_INTCODE2EXT "${LOG_CHECK} ${MSG_PATTERN} \"${LOG_FILE}\""
	sleep 1
}
BKUP_CHECK_LOG_CHECK_NTFS() {
	# 失敗メッセージチェック
	MSG_PATTERN='-F "ファイル システムに問題が見つかりました。"'
	CMD_INTCODE2EXT "${LOG_CHECK} ${MSG_PATTERN} \"${LOG_FILE}\""
	sleep 1
	# 終了メッセージチェック
	MSG_PATTERN='-E " 0 KB : 不良セクタ"'
	CMD_INTCODE2EXT "${LOG_CHECK} ${MSG_PATTERN} \"${LOG_FILE}\""
	sleep 1
}
BKUP_CHECK_LOG_CHECK_SKIP() {
	# 失敗メッセージチェック
	SKIP_FAIL_MSG_CHECK
	sleep 1
	# 終了メッセージチェック
	SKIP_END_MSG_CHECK
	sleep 1
}

######################################################################
# メインルーチン
######################################################################

# BKUP_CHECK_LOG_N チェック
for N in 1 2
do
	BKUP_CHECK_LOG_N=BKUP_CHECK_LOG_${N}
	BKUP_DEV_N=BKUP_DEV_${N}
	BKUP_DEV_FS_N=BKUP_DEV_FS_${N}

	if [ ! "${!BKUP_CHECK_LOG_N}" = "" ];then
		LOG_FILE="${!BKUP_CHECK_LOG_N}"
	else
		LOG_FILE="${BKUP_CHECK_LOG_N}"
	fi
	if [ "${MOUNT_TYPE}" = "local" ];then
		if [ ! "${!BKUP_DEV_N}" = "" ];then
			case ${!BKUP_DEV_FS_N} in
			fat16|fat32)
				BKUP_CHECK_LOG_CHECK_FAT
				;;
			ntfs)
				BKUP_CHECK_LOG_CHECK_NTFS
				;;
			esac
		else
			BKUP_CHECK_LOG_CHECK_SKIP
		fi
	elif [ "${MOUNT_TYPE}" = "remote" ];then
		BKUP_CHECK_LOG_CHECK_SKIP
	fi
done

