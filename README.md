# dotfiles

```bash
# 予定...
curl -L https://github.com/y-web21/dotfiles/main/init/install.bash | bash
```

## files

`rc`には表示するコマンドは書かない。

- [rsync -e ssh error protocol incompatibility](https://www.linuxquestions.org/questions/linux-networking-3/rsync-e-ssh-error-protocol-incompatibility-345101/)

`ssh`でもトラブルが起きる。

### .lesskey

以下コマンドで`~/.less`を生成してから機能する。

```sh
cd ~
lesskey
```

### .inputrc

いじっていると`tty`系のトラブルが起きる。

- コマンドは受け付けるが打ち込んでいる内容がラインバッファが表示されない -> `stty echo`
- `Enter`が`^M`となる -> `stty sane`
  - `stty -a`で確認して`stty icrnl`で解決するケースもあるようだが、遭遇していない

- このあたりで解決しなければ、再起動しよう
  - `/usr/bash/clear`
  - `/usr/bash/reset`
  - `stty sane`
  - `stty echo`
  - `stty icrnl`

#### Key sequence に使うキーの調べ方

`cat`して`Home`キーとか制御キーを押して見る。

#### `\e`の扱い

`.inputrc` に `"\e\C-a": "__test_bind\n"` と設定した場合

| 環境   | `Alt+Ctrl+a` | `Esc` -> `Ctrl+a` |
| ------ | ------------ | ----------------- |
| Cmder  | ⭕            | ⭕                 |
| VSCode | ❌            | ⭕                 |

## そりゅーしょん

- GNU Readline ライブラリの設定する
  - `.inputrc` に書く場合
    - `"\e\C-l": unix-filename-rubout`
  - `.bashrc` に書く場合
    - `bind -x '"\e\C-l": unix-filename-rubout'`
    - `bind -x`以降をシングルクォートで囲む
- ユーザ定義 function を呼び出す
  - **長い関数名は入力しきれずに終わってしまうのでダメダメかも**
    - `__interacrive_cd_recurse\n`が`__interacrive_cd_recur`まで入力されて実行されずに終わる。
    - 一応、設定もできるかもしれないが、この挙動ならユーザー定義関数は`.bashrc`に書いたほうがいいと思う
  - `.inputrc` に書く場合
    - `"\e\C-l": "__relogin\n"`
    - `"\e\C-l": "__relogin\015"`
    - ダブルクォートで関数名を囲んで、表記はどちらでもいいので改行コードを付与する
  - `.bashrc` に書く場合
    - `bind -x '"\e\C-l": __relogin'`
    - `bind -x`以降をシングルクォートで囲む

### S キーが動かなくなった

切り分けた結果、`stty werase undef`に原因があることはわかった

- OK `set bind-tty-special-chars Off`
- NG `stty werase undef`

素晴らしい回答

- [linux - .inputrc override Control+W - Stack Overflow](https://stackoverflow.com/questions/23349325/inputrc-override-controlw)
- [Re: stty settings override ~/.inputrc?](https://lists.gnu.org/archive/html/bug-bash/2005-08/msg00003.html)

## git

### gitignore

- /etc/gitconfig
- .git/info/exclude
- ~/.gitignore_global
- .gitignore

### .gitignore_global

デフォルトは、`~/.config/git/.gitignore`

指定するなら以下。ただしこれは、`1.7`くらいまでの古の作法。

`git config --global core.excludesfile ~/.gitignore_global`

``` t
# ~/.gitconfig
[core]
    excludesfile = ~/.gitignore_global
```

### private セッティングの切り分け

``` t
# ~/.gitconfig
[include]
    path = ~/.gitconfig.local
```

### config/git

対応リスト

- .gitconfig
- .gitignore
- .git-credentials

## なぐり書き

### 初期化

- ls の 設定
  - PAGER, page送り
- package 初期インストール実行
  - dnf
  - brew
  - apt

## グローバルエイリアスが使いたい

[bashとzshの違い。bashからの乗り換えで気をつけるべき16の事柄](https://kanasys.com/tech/803#index3)
