#!/usr/bin/env bash

# network
print(){
  cat <<- EOS
		ss -atn
		ss -nultp
		netstat -anp
	EOS
}

print