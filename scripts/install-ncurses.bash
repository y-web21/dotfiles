#!/usr/bin/env bash

install-ncurses-wc(){
  # 2バイト文字対応
  PKG=ncurses
  VER=6.3
  wget http://ftp.gnu.org/gnu/ncurses/ncurses-6.3.tar.gz
  tar -xzvf ncurses-6.3.tar.gz
  cd ncurses-6.3
  ./configure --with-shared --enable-widec
  make
  make install
}
install-ncurses-wc
