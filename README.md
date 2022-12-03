# dotfiles

```bash
# 予定...
curl -L https://github.com/y-web21/dotfiles/main/init/install.bash | bash
```

## files

### .lesskey

以下コマンドで`~/.less`を生成してから機能する。

```sh
cd ~
lesskey
```

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
