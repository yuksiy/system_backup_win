# examples

## 設定ファイルのインストール

下表に従って、サンプルファイル(=表中の必須/任意の後に続く括弧内のファイル)を元に内容を編集した上で、
各対象ホストに必要な設定ファイルをインストールしてください。

設定ファイル名                | インストール先ファイル名                               | ローカルバックアップのローカルホスト
----------------------------- | ------------------------------------------------------ | -------------------------------------
バックアップ定義ファイル      | %ALLUSERSPROFILE%\system_backup\env.bat                | 必須 (env.local.bat)
ファイルリスト取得スクリプト  | %ALLUSERSPROFILE%\system_backup\get_file_list.bat      | 必須 (get_file_list.bat)
バックアップスクリプト        | %ALLUSERSPROFILE%\system_backup\backup.bat             | 必須 (backup.bat)
バックアップソースリスト      | 任意 (backup.bat中の変数「ROBOCOPY_SRC_LIST」で指定)   | 必須 (src_list.txt)
サービス起動スクリプト        | 任意 (env.bat中の変数「SVC_START」で指定)              | 任意 (svc_start.bat)
サービス停止スクリプト        | 任意 (env.bat中の変数「SVC_STOP」で指定)               | 任意 (svc_stop.bat)

## 設定ファイルの詳細

### バックアップ定義ファイル

#### MENU_DEFAULT

system_backup.bat を対話形式で起動した際に表示されるメニューのデフォルトの選択肢を指定します。

#### MENU_TIMEOUT

system_backup.bat を対話形式で起動した際に表示されるメニューのタイムアウト時間を秒数で指定します。

#### MOUNT_TYPE

バックアップ先デバイスが
ローカルの場合は「local」、リモートの場合は「remote」を指定します。

#### MOUNT_AUTO

バックアップ前/後にバックアップ先デバイスのマウント/マウント解除を
実行する場合は「TRUE」、実行しない場合は「FALSE」を指定します。

#### CHECK_AUTO

バックアップ後にバックアップ先デバイスのチェックを
実行する場合は「TRUE」、実行しない場合は「FALSE」を指定します。

#### BKUP_DEV_N, BKUP_DEV_FS_N, BKUP_MNT_N, BKUP_MNT_OPT_N, BKUP_UMNT_OPT_N, BKUP_CHK_OPT_N, BKUP_MOUNT_LOG_N, BKUP_UMOUNT_LOG_N, BKUP_CHECK_LOG_N

バックアップ先デバイスの以下のパラメータを指定します。

* ボリュームラベル
* ファイルシステム
* ドライブ文字
* マウントオプション
* マウント解除オプション
* チェックオプション
* マウントログファイル名
* マウント解除ログファイル名
* チェックログファイル名

#### LOG_ROOT

コンピューター別ログファイル格納ディレクトリの親ディレクトリ名を指定します。

#### LOG_DIR

コンピューター別ログファイル格納ディレクトリ名を指定します。

#### DEST_ROOT

コンピューター別バックアップ先ディレクトリの親ディレクトリ名を指定します。

#### DEST_DIR

コンピューター別バックアップ先ディレクトリ名を指定します。

#### MAIN_LOG

メインログファイル名を指定します。

#### CHECK_LOG

チェックログファイル名を指定します。

#### DEV_CHECK_LOG

バックアップ先デバイスのチェックログファイル名を指定します。

#### ROBOCOPY_LOG

robocopy によるバックアップ処理のログファイル名を指定します。

#### SVC_START, SVC_STOP

バックアップ前/後にサービスの停止/起動を実行する場合、
以下のパラメータを指定します。

* サービス起動スクリプトのファイル名
* サービス停止スクリプトのファイル名

#### GET_FILE_LIST_DIR_ARG_SUFFIX

ユーザデータファイルリストの取得を実行するためのパラメータを
以下の形式で指定します。

    "検索開始ディレクトリ,ユーザデータファイルリストのファイル名の接尾辞 ..."

### ファイルリスト取得スクリプト

必要に応じて内容を編集してください。

### バックアップスクリプト, バックアップソースリスト

必要に応じて内容を編集してください。

関連パッケージ:
* [robocopy_backup](https://github.com/yuksiy/robocopy_backup)

### サービス起動スクリプト, サービス停止スクリプト

必要に応じて内容を編集してください。
