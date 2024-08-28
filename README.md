# 🚀 Docker Kit 🚀

This is an easy-to-use application starter kit. The workflows from creating a new application, doing development, and managing dev, stage, and prod environments are included.

> [!NOTE]
> Why another Docker based workflow? Two reasons:
> - 👉 Template Based - I want to be able to use the same kit for many different frameworks. So no matter if you are developing in **Laravel** or **Django** or just need to spin up a quick **MySQL** data server, there are templates to support your needs.
> - 👉 Enhanced Environment - The template provides the initial infrastructure as code. If needed, you can modify the image to add new features. For example, I had a need to integrate with SQL Server, Active Directory, and other services, so a quick modification of the Dockerfile got me where I needed to be.
> - 👉 Architecture - I believe that the code for the CI/CD or DevOps tooling does not belong in the same git repo as your application code.


This kit uses "templates" to allow the kit to manage workflows for a number of technology stacks. Right now the following templates are supported out-of-the-box:

- Laravel (`kit new laravel`) - Read the `templates/laravel/README.md` for more details about this template.
- Django (`kit new django`) - Read the `templates/django/README.md` for more details about this template.
- MySQL (`kit new mysql`) - Read the `templates/mysql/README.md` for more details about this template.
- PostgreSsQL (`kit new postresql`) - Read the `templates/postresql/README.md` for more details about this template.
- Redis (`kit new redis`) - Read the `templates/redis/README.md` for more details about this template.

There is a `templates/.empty` example that you can use to create a new technology stack. Checkout the `templates/.empty/README.md` file for details on how to create your own.

## 💥 Quick Start

### 👉 Docker Environment

To get started, make sure you have [Docker installed](https://docs.docker.com/docker-for-mac/install/) on your system.

### Install the kit

Setup directory structure and clone this repo:

1. `mkdir project`
2. `cd projects`
3. `git clone https://github.com/rcravens/docker_starter_for_laravel.git docker`
4. `cd docker`
5. `./bin/install.sh` ‼️ this creates a `kit` alias that you can use ‼️

### Use a template to create an application

2. Create a new Laravel application

`kit new` will list out all the available templates. For example to create a Laravel application:

1. `kit new laravel` and answer the on-screen questions....that's it!

> [!IMPORTANT]
> The `kit new laravel` command will do all the following automatically:
> 1. Create code directory named `projects/code/<APP NAME>`
> 2. Clone the git repo into the code directory
> 3. Create a `.env` in the code directory for the Laravel application. Many of the values are updated based on the `.env` in the docker settings
> 4. Build the Docker images.
> 5. `composer install` to install PHP dependencies
> 6. `php artisan key:generate` to create the app key
> 7. `php artisan migrate` to run the initial migrations
> 8. `npm install` to install the Node dependencies
> 9. `npm run build` to build the front-end assets
> 10. Insert domain in /etc/hosts file
> 11. `kit open` to open up a browser tab to the application

## 💥 Videos

[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/nrG0O_qqMkk/0.jpg)](https://www.youtube.com/watch?v=nrG0O_qqMkk)
[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/Q8wrgqlpVY4/0.jpg)](https://www.youtube.com/watch?v=Q8wrgqlpVY4)
[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/qbdOO7pnJrU/0.jpg)](https://www.youtube.com/watch?v=qbdOO7pnJrU)
[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/GwgwgoWCm8Q/0.jpg)](https://www.youtube.com/watch?v=GwgwgoWCm8Q)

### General Information (WIP)

Commands have the following format: `kit [app] [env] COMMAND [options] [arguments]`

- `[app]` is the application name. This kit allows you to create many apps under one directory. Defaults to the app corresponding to the first child directory in `./apps`.
- `[env]` valid values are `dev`, `stage`, or `prod`. Defaults to `dev`. This is a flag to specify environment. Then the following files are used when running Docker commands:

| env     | files                                                             |
|---------|-------------------------------------------------------------------|
| `dev`   | `docker-compose.yml`, `docker-compose.dev.yml` and `.env.dev`     |
| `stage` | `docker-compose.yml`, `docker-compose.stage.yml` and `.env.stage` |
| `prod`  | `docker-compose.yml`, `docker-compose.prod.yml` and `.env.prod`   |

- `COMMAND` the command to run
- `[options]` any options supported by the command
- `[arguments]` arguments expected by the command

There is an onboard help system that allows you to quickly get details about available commands:

- `kit` or `kit help` will list all the available commands
- `kit COMMAND help` (e.g., `kit artisan help` or `kit build help`) will provide additional details and examples for a command

Here are a few examples showing a command and the production version:

- `kit app1 image` and `kit app1 prod image`
- `kit app1 start` and `kit app1 prod start`

> [!NOTE]
> In the following the `[app]` and `[env]` options will be removed for brevity, but all commands support that option.

### Creating a Application

- `kit new [TEMPLATE] [--force]` will create a new application based on the specified template:
    - `--force`: the existing code directory will be deleted first

### Starting / Stopping Application

To get started, make sure you have [Docker installed](https://docs.docker.com/docker-for-mac/install/) on your system, and then copy this directory to a desired location on your development machine.

Next, open the .env file and update any settings (e.g., versions & exposed ports) to match your desired development environment.

Then, navigate in your terminal to that directory, and spin up the containers for the full web server stack by running:

- `kit image` to build the Docker images
- `kit start` to start the running the web application
- `kit open`  to open the web application in the browser

Once running you can do one of the following:

- `kit stop`    to stop the web application
- `kit restart` to restart the running the web application (equivalent to stop and the start)
- `kit destroy` to stop the web application and delete the associated data (i.e., Docker images, app and code directories)

### Shell Access

You can create an interactive shell by doing one of the following:

- `kit ssh <SERVICE>` for example `kit ssh nginx` to access a shell command inside the nginx container.

### Template Specific Commands

Each template can inject additional commands into the kit platform. You can find out more details about template specific commands on the `README.MD` file for each template. Here are a few examples from the Laravel template:

- `kit composer <COMMAND>` runs a composer command (e.g., `kit composer install`)
- `kit artisan <COMMAND>`  runs an artisan command (e.g., `kit artisan db:seed`)
- `kit npm <COMMAND>`      runs a npm command (e.g., `kit npm install`)
- `kit migrate` equivalent to `kit artisan migrate`

# Create Your Own Template?

Yes, please! Would love to integrate additional templates for the community to use with this kit platform. Just follow the instructions in the `templates/.empty/README.md` file to create your own template.

Let me know if you have any issues!

Once you have a working template, create a pull request and I can merge it in!