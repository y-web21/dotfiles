# README

## PS1

[Bash Shell: Take Control of PS1, PS2, PS3, PS4 and PROMPT_COMMAND](https://www.thegeekstuff.com/2008/09/bash-shell-take-control-of-ps1-ps2-ps3-ps4-and-prompt_command/)

### ターミナルのコマンド受付状態の表示変更

- `\u` ユーザ名
- `\h` ホスト名
- `\H` ホスト名
- `\W` カレントディレクトリ
- `\w` カレントディレクトリのパス
- `\n` 改行
- `\d` 日付
- `\t` 時刻 HH:MM:SS 24h
- `\T` 時刻 HH:MM:SS 12h
- `\@` 時刻 am/pm 12h
- `\a` ベルを鳴らす
- `\s` シェルの名前
- `\[` 表示させない文字列の開始
- `\]` 表示させない文字列の終了
- `\$` `$` UIDが0の場合は`#`になる
- `\\` バックスラッシュ
- `\xxx` 8進数での文字指定
- `\!` コマンドの履歴番号
- `\v` Bashのバーション
- `\V` Bashのリリース

### ANSI escape codes

https://en.wikipedia.org/wiki/ANSI_escape_code#3-bit_and_4-bit

### 装飾 attributes

sample こういう感じのフォーマットです

`PS1='\e[0;33;40m\t\e[1;37;49m \u\e[30;32m@\H \e[39;49m \W \e[0m \! \n\$ '`

- OS初期だと、`\[\033[01;32m\]\u`のように`\[...\]`で囲う表記があるが、これは省略可能
- `\033`=`\e`、`\033`はオクテット表記。意味は`ESC`。
- `\e[...m`でワンブロック。
  - `\e[<font-style>;<font-color>;<back-color>m`
  - `\e[01;3xm` 太文字。
    - `01`は、`1`に省略可能。`\e[1;3xm`
    - `0`を指定することで`Bold`をリセット。`\e[0;3xm`
  - `\e[3xm` 文字色指定。
  - `\e[4xm` 背景色指定。
  - `\e[0m` 装飾オールリセット(最後に設ける。コマンドラインバッファに影響が出るため)
- `00`部の bold 以外のスタイル
  - 1 `bold`
  - 2 `low intensity`
  - 4 `underline`
  - 5 `blink`
  - 7 `reverse video`
  - 8 `invisible text`
- RGB カラー
  - `[34]0` #000000 黒
  - `[34]1` #ff0000 赤
  - `[34]2` #00ff00 緑
  - `[34]3` #ffff00 黄
  - `[34]4` #0000ff 青
  - `[34]5` #ff00ff マ
  - `[34]6` #00ffff シ
  - `[34]7` #ffffff 白
  - `39,49m`で文字と背景の色リセット。

## zsh key bind

- [Re: key codes table.](https://www.zsh.org/mla/users/2014/msg00266.html)
- [ZshでHomeやEndキーが機能しない - Akionux-wiki](https://wiki.akionux.net/index.php/Zsh%E3%81%A7Home%E3%82%84End%E3%82%AD%E3%83%BC%E3%81%8C%E6%A9%9F%E8%83%BD%E3%81%97%E3%81%AA%E3%81%84)
