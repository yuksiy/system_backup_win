# system_backup_win

## 概要

システムのバックアップ (Windows)

特徴は以下の通りです。

* 可能なバックアップパターン
  * ローカルホストのローカルバックアップ

* バックアップ前/後に実行可能な追加タスク
  * バックアップ先デバイスのマウント/マウント解除
  * サービスの停止/起動

* バックアップ前に実行可能な追加タスク
  * システム構成情報の取得
  * ユーザデータファイルリストの取得

* バックアップ後に実行可能な追加タスク
  * バックアップ先デバイスのチェック

## 使用方法

* 以下のコマンドはすべて「管理者として実行」した「コマンド プロンプト」から実行する必要があります。

### system_backup.bat

    ローカルホストをローカルバックアップします。
    system_backup.bat

### その他

* 上記で紹介したツールの詳細については、各ファイルのヘッダー部分を参照してください。

* バックアップ先デバイスの初期設定(参考手順)に関しては、
  [hdd_setup_win.txt ファイル](https://github.com/yuksiy/system_backup_win/blob/master/hdd_setup_win.txt)
  を参照してください。

* バックアップ先デバイスの交換方法(参考手順)に関しては、
  [hdd_change_win.txt ファイル](https://github.com/yuksiy/system_backup_win/blob/master/hdd_change_win.txt)
  を参照してください。

## 動作環境

OS:

* Cygwin

依存パッケージ または 依存コマンド:

パッケージ名 または コマンド名                                       | ローカルバックアップのローカルホスト
-------------------------------------------------------------------- | -------------------------------------
make (インストール目的のみ)                                          | 必須
[nkf](https://osdn.net/projects/nkf/)                                | 必須
smartmontools                                                        | 任意 (*1)
[fs_tools_win](https://github.com/yuksiy/fs_tools_win)               | 必須
[get_info_win](https://github.com/yuksiy/get_info_win)               | 必須
[log_check](https://github.com/yuksiy/log_check)                     | 必須
[robocopy_backup](https://github.com/yuksiy/robocopy_backup)         | 必須

*1 … バックアップ先デバイスのS.M.A.R.T.情報を使用する場合のみ  

## インストール

ソースからインストールする場合:

    (Cygwin の場合)
    # make install

fil_pkg.plを使用してインストールする場合:

[fil_pkg.pl](https://github.com/yuksiy/fil_tools_pl/blob/master/README.md#fil_pkgpl) を参照してください。

## インストール後の設定

環境変数「PATH」にインストール先ディレクトリを追加してください。

[examples/README.md ファイル](https://github.com/yuksiy/system_backup_win/blob/master/examples/README.md)
を参照して設定ファイルをインストールしてください。

## 最新版の入手先

<https://github.com/yuksiy/system_backup_win>

## License

MIT License. See [LICENSE](https://github.com/yuksiy/system_backup_win/blob/master/LICENSE) file.

## Copyright

Copyright (c) 2004-2023 Yukio Shiiya
