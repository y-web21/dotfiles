#!/usr/bin/env bash

install-ncurses-wc(){
  # マルチバイト文字対応
  VER=6.3
  wget http://ftp.gnu.org/gnu/ncurses/ncurses-${VER}.tar.gz
  tar -xzvf ncurses-${VER}.tar.gz
  cd ncurses-${VER}
  ./configure --with-shared --enable-widec
  make
  make install
}
install-ncurses-wc
