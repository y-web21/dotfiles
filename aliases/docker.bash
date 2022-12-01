#!/usr/bin/env bash

if [ -e "$(which docker 2>/dev/null)" ]; then
  alias dc='docker compose'
  alias dcu='docker compose up -d'
  alias dcub='docker compose up -d --build'
  alias dcurb='docker compose up -d --no-deps --build' # 1イメージをのみリビルド
  alias dcd='docker compose down'
  alias dcdi='docker compose down --rmi=all'
  alias dcr='docker compose down && docker compose up -d'
  alias dcri='docker compose down --rmi=all && docker compose up -d --build'
  alias dcconf='docker compose config'
  alias dps='docker compose ps'

  alias d='docker '
  alias dls='docker container ls'
  alias dlsa='docker container ls --all'
  alias dsize='docker ps --format "{{.ID}} {{.Names}} {{.Image}} {{.Size}}" | column -t'
  alias drmiall='docker rmi $(docker images -q)'
  alias ddestoroy='docker ps -q | xargs docker stop && docker ps -aq | xargs docker rm && docker images -qa | xargs docker rmi'
  dmountedvolume (){ docker inspect "$(docker ps -q "${1}")" | grep -i source | tr -d ' '; }

  alias drmByName='docker-remove-by-name'; docker-remove-by-name() { docker ps -a -f 'name='$1 | sed "1d" | cut -d" "  -f1 | xargs docker rm ; }

  alias container-ip='docker inspect -format='\''{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'\'''

  docker-helpo() {
    cat <<-'EOF'
		docker pull nginx
		docker run --rm --name test2 -d -p 80:80 -t nginx:latest
		docker ps -a
		docker ps -as
		docker rm
		docker images
		docker rmi
		# Dockerfile から image build
		docker build -t nginfox:oldest .
		docker run -d -p 80:80 -t nginfox:oldest
		# -q で id列のみ。awk '{print $1}'的
		$ docker ps -q | xargs docker stop
		EOF
  }

  # 宙ぶらりんイメージ（dangling image）のみ削除します。宙ぶらりんイメージとは、タグを持たず、他のコンテナからも参照されないイメージです。
  # docker image prune
  # 既存のコンテナ～使われていないイメージすべてを削除するには、 -a フラグを使います。
  # docker image prune -a
  # remove dangling image cotainer volume network
  # alias drune='docker system prune'

  # docker container
  alias da='docker container attache'

  alias dphp='docker exec -it php bash'
  alias dfpmreload='docker exec php ps aux | grep master | sed '\''s/ \+/ /g'\'' | cut -d '\'' '\'' -f 2 | xargs docker exec php kill -USR2' # sshrc用
  # shellcheck disable=SC2142
  alias dfpmreload='docker exec php kill -USR2 $(docker exec php ps aux | grep master | awk '\''{print $2}'\'')'
  alias dphpserve='docker exec -t php bash -c "php artisan serve --host 0.0.0.0"'

  alias dmysql='docker exec -it db bash -c '\''mysql -uroot -p'\'''
  alias dnginxreload='docker exec -it nginx bash -c '\''nginx -s reload'\'''


  # docker 2nd gen

  # docker exec -it P bash -g は、グローバルエイリアスで zsh の機能らしい
  # alias -g P='`docker ps | tail -n +2 | peco | cut -d" " -f1`'

  # shellcheck disable=SC2142
  alias dget-cid='docker ps -a | tail +2 | peco | awk '\''{print $1}'\'''
  # shellcheck disable=SC2142
  alias dget-image='docker ps -a | tail +2 | peco | awk '\''{print $2}'\'''
  alias dget-name='docker ps -a | tail +2 | peco | awk '\''{print $NF}'\'''
  # なぜかエラー
  # alias d-bash='docker ps -a | tail +2 | peco | awk '\''{print $NF}'\'' | xargs -i docker exec -it {} bash'
  alias d-bash='docker exec -it $(docker ps -a | tail +2 | peco | awk '\''{print $NF}'\'') bash'


  # bash 代替
  alias P='CURRENT_CONTAINER=$(docker ps | tail -n +2 | peco | cut -d" " -f1)'

  dsh (){
    CONTAINER=${1:-${CONTAINER}}
    echo "container 【${CONTAINER}】 shell"
    docker exec -t ${CONTAINER} bash -c "$2"
  }
  dish (){
    CONTAINER=${1:-${CONTAINER}}
    echo "container 【${CONTAINER}】 intaractive shell"
    docker exec -it ${CONTAINER} bash
  }
fi
