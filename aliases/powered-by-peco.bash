
greview(){
  grep -r "$1" . -n | peco | cut -d':' -f1 | xargs bat
}

greviewmd(){
  grep -r "$1" . -n | peco | cut -d':' -f1 | xargs glow
}
