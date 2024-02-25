
# Laravel Docker Workflow

This is a pretty simplified, but complete, workflow for using Docker and Docker Compose with Laravel development. The included docker-compose.yml file, Dockerfiles, and config files, set up a LEMP stack powering a Laravel application in the `code` directory.

## Getting Started

[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/GwgwgoWCm8Q/0.jpg)](https://www.youtube.com/watch?v=GwgwgoWCm8Q)


### Configuration Settings
Copy `.env_example` to `.env` and set the following variables:

#### Application Settings
- `COMPOSE_PROJECT_NAME=abc_app` Used in the docker-compose.yml file to namespace the services.
- `APP_DOMAIN=abc_app.local` - Used in the nginx service to automatically create a self-signed certificate for this domain.
- `PATH_TO_CODE=../code` - Location of the code that is used to configure map volumes into the containers

#### Docker Container Versions
The following are used to set the container versions for the services. Here is an example configuration:
- `PHP_VERSION=8.0`
- `MYSQL_VERSION=5.7.32`
- `NODE_VERSION=13.7`
- `REDIS_VERSION=latest`
- `NGINX_VERSION=stable`

#### Docker Services Exposed Ports
The following are used to configure the exposed ports for the services. Here is an example, but update to de-conflict ports:
- `HTTP_ON_HOST=8001`
- `HTTPS_ON_HOST=44301`
- `MYSQL_ON_HOST=33061`
- `REDIS_ON_HOST=6379`

#### Database Settings
The following are used by docker when building the database service:
- `MYSQL_DATABASE=abc_db`
- `MYSQL_USER=laravel`
- `MYSQL_PASSWORD=secret`
- `MYSQL_ROOT_PASSWORD=secret`

### Hosts File
For local development, update your Operating System's host file. For example, add the following line to resolve a domain to localhost:

- `127.0.0.1     abc_app.local`

## Usage

To get started, make sure you have [Docker installed](https://docs.docker.com/docker-for-mac/install/) on your system, and then copy this directory to a desired location on your development machine.

Next, open the .env file and update any settings (e.g., versions & exposed ports) to match your desired development environment.

Then, navigate in your terminal to that directory, and spin up the containers for the full web server stack by running `docker-compose up -d --build nginx`.

After that completes, run the following to install and compile the dependencies for the application:

- `docker-compose run --rm composer install`
- `docker-compose run --rm npm install`
- `docker-compose run --rm npm run dev`

When the container network is up, the following services and their ports are available to the host machine:

- **nginx** - `:HTTPS_ON_HOST`, `:HTTP_ON_HOST`
- **mysql** - `:MYSQL_ON_HOST`
- **redis** - `:REDIS_ON_HOST`

Additional containers are included that are not brought up with the webserver stack, and are instead used as "command services". These allow you to run commands that interact with your application's code, without requiring their software to be installed and maintained on the host machine. These are:

- `docker-compose run --rm composer <COMMAND>` runs a composer command
- `docker-compose run --rm artisan <COMMAND>` runs an artisan command
- `docker-compose run --rm npm <COMMAND>` runs a npm command 
- `docker-compose run --rm cron` starts a crontab that runs the `php artisan schedule` command
- `docker-compose run -d horizon` starts a new horizon container (you can start multiple horizon containers)
- `docker-compose stop horizon` stops all the horizon containers

You would use them just like you would with their native counterparts, including your command after any of those lines above (e.g. `docker-compose run --rm artisan db:seed`).

You can create an interactive shell by doing one of the following:

- `docker-compose run -it --entrypoint /bin/bash <SERVICE>`
-  `docker compose exec -it <SERVICE> /bin/sh` 
