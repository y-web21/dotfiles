# README

## [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html)

- `XDGBDS`は必須ではないが、強く推奨されている。
- ホームが設定ファイルだらけになるので、対応しているものはなるべく`XDG_CONFIG_HOME`に置く
  - 基本ロケーションは `$HOME/.config`、環境変数`$XDG_CONFIG_HOME`に従う。

## peco/config.json

[peco/README.md at master · peco/peco](https://github.com/peco/peco/blob/master/README.md)

location `$HOME/.config/peco/config.json`

## gh/config.yml

エディタは、`yml`の編集か、`gh config set editor vim`で設定できるが、

[gh environment](https://cli.github.com/manual/gh_help_environment)より

> GH_EDITOR, GIT_EDITOR, VISUAL, EDITOR (in order of precedence): the editor tool to use for authoring text.

となっている。決め打ちすることではないので、`editor`は未指定で良い。

```yml
editor:
```

また、GUIベースの`VSCode`の場合、`code --wait`とする。
`nano`や`vim`はオプション無しで良い。
