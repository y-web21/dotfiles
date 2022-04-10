#!/usr/bin/env bash

# ドットファイルのpublishブランチを公開用リポジトリのドットファイルへぶっこむやつを書いた
(
  mkdir __workdir__/ && cd $_
  git clone -b publish https://github.com/y-web21/dotfiles dotfiles_private___
  git clone -b main https://github.com/y-web21/dotfiles-pub dotfiles_public___
  rm -rf dotfiles_public___/*
  cp -r dotfiles_private___/* dotfiles_public___/
  cd dotfiles_public___/
  git remote set-url origin https://github.com/y-web21/dotfiles-pub.git
  git add .
  git commit -m 'update' -m 'update!'
  git push -f origin HEAD
  cd ../../
  rm -rf __workdir__/
)
