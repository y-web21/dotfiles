# dotfiles

## clone with submodules

`git clone` だけだと中身が空なので、追加操作が必要

`git`, `gh`, `ghq` で対応状況ややり方が変わる

普通に `git clone` 系を実行後 `git submodule update --init --recursive` がシンプル。
おそらく何回実行しても良いが、編集中の場合上書きされるので注意。
(`--recursive` は submodule の入れ子に対応するが不要でも使ってしまって問題ない。)

```bash
git git clone --recurse-submodules
gh gh repo clone && git submodule update
ghq GIT_CLONE_OPTS="--recurse-submodules" && ghq get
```

for CI

```bash
git clone --recurse-submodules --depth=1
```

## init

```bash
./make_link.bash
# 確認なし
./make_link.bash -f
```

## memo

- `zsh`のセッティングは`bash`のファイルに大きく依存している。
  - エイリアスなどを`source`しているため
