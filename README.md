
# Laravel Docker Workflow

This is a pretty simplified, but complete, workflow for using Docker and Docker Compose with Laravel development. The included docker-compose.yml file, Dockerfiles, and config files, set up a LEMP stack powering a Laravel application in the `code` directory.

## Features
- `nginx` - Already configured with SSL/TLS
- `php` - All the drivers for `SQL Server ODBC Drivers`, `Active Directory via LDAP`. Configurable PHP version
- `mysql` - Data is stored on local disk NOT INSIDE container. Persists across rebuilding container.
- `composer` - Easily run all your favorite composer commands.
- `artisan` - Easily run all your favorite artisan commands.
- `npm` - Easily run all your favorite npm commands.
- `phpunit` - Easily run your unit tests.
- `redis` - Easily use redis for your session cache.
- `horizon` - Easily use horizon to manage your workers and job queues.
- `cron` - Easily use cron to schedule periodic commands.

## Quick Start
1. Copy `.env_example` to `.env`
2. Adjust values in `.env` (see Configuration Settings below)
3. `./kit create` to create a new Laravel application based on `.env` settings

The create command will do the following automatically:
1. Create code directory as specified by PATH_TO_CODE variable in `.env`
2. Clone the Laravel framework into the code directory
3. Create a `.env` in the code directory for the Laravel application. Many of the values are updated based on the `.env` in the docker settings
4. Build the Docker images. 
5. `composer install` to install PHP dependencies
6. `php artisan key:generate` to create the app key
7. `php artisan migrate` to run the initial migrations
8. `npm install` to install the Node dependencies
9. `npm run build` to build the front-end assets
10. `./kit open` to open up a browser tab to the application


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

### Starting / Stopping Application
To get started, make sure you have [Docker installed](https://docs.docker.com/docker-for-mac/install/) on your system, and then copy this directory to a desired location on your development machine.

Next, open the .env file and update any settings (e.g., versions & exposed ports) to match your desired development environment.

Then, navigate in your terminal to that directory, and spin up the containers for the full web server stack by running:

- `./kit build` to build the Docker images
- `./kit start` to start the running the web application
- `./kit open`  to open the web application in the browser

Once running you can do one of the following:

- `./kit stop`    to stop the web application
- `./kit restart` to restart the running the web application (equivalent to stop and the start)
- `./kit destroy` to stop the web application and delete the associated Docker images

### Exposed Ports
When the container network is up, the following services and their ports are available to the host machine:

- **nginx** - `:HTTPS_ON_HOST`, `:HTTP_ON_HOST`
- **mysql** - `:MYSQL_ON_HOST`
- **redis** - `:REDIS_ON_HOST`

### Additional Services & Shortcuts
Additional services are included that are not brought up with the webserver stack, and are instead used as "command services". These allow you to run commands that interact with your application's code, without requiring their software to be installed and maintained on the host machine. These are:

- `./kit composer <COMMAND>` runs a composer command (e.g., `./kit composer install`)
- `./kit artisan <COMMAND>`  runs an artisan command (e.g., `./kit artisan db:seed`)
- `./kit npm <COMMAND>`      runs a npm command (e.g., `./kit npm install`)

You would use them just like you would with their native counterparts, including your command after any of those lines above (e.g. `./kit artisan db:seed`). Here are a few shortcuts for common commands:

- `./kit migrate` equivalent to `./kit artisan migrate`

### Queues, Jobs, and Cron
To run Laravel jobs use the following commands to start / stop Laravel Horizon. Horizon will run in its own container:

- `./kit horizon start`   starts a new horizon container (you can start multiple horizon containers to increase the number of workers). NOTE: If Laravel Horizon is not installed, it will be installed automatically
- `./kit horizon stop`    stops all the horizon containers
- `./kit horizon destroy` stops all the horizon containers and deletes the associated Docker images

To automatically schedule jobs use the following commands to run `php artisan schedule:run`

- `./kit cron start`   starts a new horizon container (recommended you only run a single cron container)
- `./kit cron stop`    stops all the horizon containers
- `./kit cron destroy` stops all the horizon containers and deletes the associated Docker images

### Shell Access
You can create an interactive shell by doing one of the following:

- `kit ssh <SERVICE>` for example `./kit ssh nginx` to access a shell command inside the nginx container.
