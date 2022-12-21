#!/usr/bin/env bash

# circleci
# alias install-circleci='curl -fLSs https://circle.ci/cli | sudo bash && circleci setup'
if [ -e "$(which circleci 2>/dev/null)" ]; then
  alias cc-validate='circleci config validate' # .circleci/config.yml'
  alias cc-test='cc-local-execute';__cc-local-execute(){ circleci local execute --job "${1:-build}"; }
  # alias install-dockerOutsideOfDocker='curl -sSL https://get.docker.com/ | sh && usermod -aG docker root'

fi
