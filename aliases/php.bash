#!/usr/bin/env bash

if which composer >/dev/null 2>&1; then
  # laravel framework
  alias pa='php artisan'
  alias pao='php artisan optimize'
  alias paoc='php artisan optimize:clear'
  alias pdotenv_reload='php artisan cache:clear & php artisan config:cache'
  alias edit_composer-json='composer dump-autoload'
fi
