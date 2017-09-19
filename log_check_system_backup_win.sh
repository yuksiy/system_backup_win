#!/bin/sh

# ==============================================================================
#   機能
#     ROBOCOPY_LOGの内容をチェックする
#   構文
#     log_check_system_backup_win.sh
#
#   Copyright (c) 2004-2017 Yukio Shiiya
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

UNIXPATH2WIN="cygpath -w"
WINPATH2UNIX="cygpath -u"

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

MAIN_LOG_CHECK() {
	# 終了メッセージチェック
	MSG_PATTERN='-E "System backup job has ended."'
	CMD_INTCODE2EXT "${LOG_CHECK} ${MSG_PATTERN} \"${LOG_FILE}\""
	sleep 1
}

ROBOCOPY_LOG_CHECK() {
	# 失敗メッセージチェック
	MSG_PATTERN='-F "^-W " -F "^-E "'
	CMD_INTCODE2EXT "${LOG_CHECK} ${MSG_PATTERN} \"${LOG_FILE}\""
	sleep 1
	# 終了メッセージチェック
	MSG_PATTERN='-E "-I robocopy backup has ended successfully."'
	CMD_INTCODE2EXT "${LOG_CHECK} ${MSG_PATTERN} \"${LOG_FILE}\""
	sleep 1
}

######################################################################
# メインルーチン
######################################################################

# MAIN_LOG チェック
LOG_FILE="`${WINPATH2UNIX} \"${SCRIPT_TMP_DIR}/${MAIN_LOG}\"`"
if [ "${MOUNT_TYPE}" = "local" -o "${MOUNT_TYPE}" = "remote" ];then
	MAIN_LOG_CHECK
fi

# ROBOCOPY_LOG チェック
LOG_FILE="`${WINPATH2UNIX} \"${SCRIPT_TMP_DIR}/${ROBOCOPY_LOG}\"`"
if [ "${MOUNT_TYPE}" = "local" -o "${MOUNT_TYPE}" = "remote" ];then
	ROBOCOPY_LOG_CHECK
fi

