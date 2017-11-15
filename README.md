Laraku
====

quickly setup Laravel + heroku environment.

## Description

this script do,

- create Laravel project
- create heroku app
- first deploy
- setting db addon
- initilize Laradock(Beta)

## Example

### setup webserver only.

`./laraku.sh larakudemo nginx`

run `heroku open`, new application will be displayed.

### setup with Database and Laradock.

`./laraku.sh larakudemo nginx postgres laradock`

access http://localhost, new application will be displayed.

of course even heroku.

## Requirement
- PHP(5.6.x, 7.1.x)
- Composer
- Git
- Heroku CLI
- Docker (if use laradock)

## Install

```
git clone https://github.com/kamukiriri/laraku.git && cd laraku && chmod 755 laraku.sh
```

**In the future, would like to distribute it from package manager.**

## Usage

move to laraku directory,

`./laraku.sh <project name> <webserver type> [<database type>] [<use laradock>]`

### Args

#### project name

using for directory name, heroku app name and laradock prefix.

#### webserver type

`nginx` or `apache`.

#### database type

`postgres`

sorry, other db not support yet.

#### use laradock

`laradock`

if omitted, skip Laradock setup.

## Caution

sorry, I tested this script on macOS sierra only.


