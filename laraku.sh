#!/bin/sh

# Laraku
# Copyright (c) 2017 kamukiriri
# This software is released under the MIT License.
# https://opensource.org/licenses/mit-license.php

set -e
set -u

#init param
appname=${1:-laravel}
webserver=${2:-apache}
db=${3:-}
laradock=${4:-}

#create project
if [ -d "$appname" ]; then

	echo "$appname already exist"
	cd "$appname"

else

	composer create-project --prefer-dist laravel/laravel "$appname"
	cd "$appname"
	git init
	git add .
	git commit -m 'create app'

fi

#create webserver setting
if [ ! -f "Procfile" ]; then
	if [ "$webserver" = "apache" ]; then

		echo web: vendor/bin/heroku-php-apache2 public/ > Procfile
		git add .
		git commit -m 'add web server setting'

	elif [ "$webserver" = "nginx" ]; then

		echo web: vendor/bin/heroku-php-nginx -C nginx_app.conf public/ > Procfile
		echo 'location / { index index.html index.php; try_files $uri $uri/ /index.php?$query_string; }' > nginx_app.conf
		git add .
		git commit -m 'add web server setting'

	else
		echo "webserver: $webserver not supported"
	fi

else
	echo "webserver: Procfile already exist"
fi

#create heroku app
set +e
heroku create $(basename $(pwd)) &>/dev/null
if [ "$?" -eq 0 ]; then

	heroku config:set APP_KEY=$(php artisan --no-ansi key:generate --show)
	git push heroku master

else
	echo "heroku app: already exist"
fi
set -e

#add db addon
set +e
heroku addons --app "$appname" | grep DATABASE &>/dev/null
if [ "$?" -ne 0 ]; then
	if [ "$db" = "postgres" ]; then

		heroku addons:create heroku-postgresql:hobby-dev
		php -r 'preg_match("/^postgres:\/\/(.+?):(.+?)@(.+?):(.+?)\/(.*?)$/", `heroku config:get DATABASE_URL`, $matches); `heroku config:set DB_CONNECTION=pgsql DB_HOST=$matches[3] DB_PORT=$matches[4] DB_DATABASE=$matches[5] DB_USERNAME=$matches[1] DB_PASSWORD=$matches[2]`;'

	else
		echo "db: $db not supported"
	fi
else
	echo "db: already exist"
fi
set -e

#init laradock
if [ "$laradock" = "laradock" ]; then

	git clone https://github.com/Laradock/laradock.git
	mv laradock/ $(basename $(pwd))dock/
	cd $(basename $(pwd))dock
	cp "env-example" ".env"
	docker-compose up -d "$webserver" "$db"
	php ../../sync_env.php
fi