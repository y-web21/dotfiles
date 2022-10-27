#!/usr/bin/env bash

# circleci
alias install-circleci='curl -fLSs https://circle.ci/cli | sudo bash && circleci setup'
if [ -e "$(which circleci 2>/dev/null)" ]; then
  alias ccvalidate='circleci config validate .circleci/config.yml'
  alias cclocaljob='circleci local execute --job build'
  # alias install-dockerOutsideOfDocker='curl -sSL https://get.docker.com/ | sh && usermod -aG docker root'
fi
