# 🚀 Application Development Kit 🚀

This is an easy-to-use application starter kit. The workflows from creating a new application, doing development, and managing dev, stage, and prod environments are included.

> [!NOTE]
> Why another Docker based workflow? Two reasons:
> - 👉 Template Based - I want to be able to use the same kit for many different frameworks. So no matter if you are developing in **Laravel** or **Django** or just need to spin up a quick **MySQL** data server, there are templates to support your needs.
> - 👉 Enhanced Environment - The template provides the initial infrastructure as code. If needed, you can modify the image to add new features. For example, I had a need to integrate with SQL Server, Active Directory, and other services, so a quick modification of the Dockerfile got me where I needed to be.
> - 👉 Architecture - I believe that the code for the CI/CD or DevOps tooling does not belong in the same git repo as your application code.
> - 👉 Deployments - The deployment pipeline should leverage infrastructure as code and be easy. This kit makes it easy to deploy your changes to any number of servers.

# ‼️ Getting Started

[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/hKDQyOWAgtc/0.jpg)](https://www.youtube.com/watch?v=hKDQyOWAgtc)

## 1️⃣ Installation

### Docker Environment

To get started, make sure you have [Docker installed](https://docs.docker.com/docker-for-mac/install/) on your system.

### Install the kit

Setup directory structure and clone this repo:

1. `mkdir project`
2. `cd projects`
3. `git clone https://github.com/rcravens/kit.git --config core.autocrlf=false infra`
4. `cd infra`
5. `./.code/bin/install.sh` ‼️ this creates a `kit` alias that you can use ‼️

## 2️⃣ ️Create Development Environment

Development environments are created using a template to scaffold both infrastructure code and application code. `kit new` will list out all the available templates. For example to create a Laravel development environment:

- `kit new laravel` and answer the on-screen questions....that's it!

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

Using `kit new <template>` will quickly create a development environment on your local machine. There you can make changes to the application code or changes to the infrastructure code.

`kit new` - Will list out the currently available templates. Here are a few of the supported technology stacks:

- Django (`kit new django`) - Read the `templates/django/README.md` for more details about this template.
- FastApi (`kit new fastapi`) - Read the `templates/fastapi/README.md` for more details about this template.
- Flask (`kit new flask`) - Read the `templates/flask/README.md` for more details about this template.
- Laravel (`kit new laravel`) - Read the `templates/laravel/README.md` for more details about this template.
- MySQL (`kit new mysql`) - Read the `templates/mysql/README.md` for more details about this template.
- PostgreSQL (`kit new postresql`) - Read the `templates/postresql/README.md` for more details about this template.
- Redis (`kit new redis`) - Read the `templates/redis/README.md` for more details about this template.

Not seeing what you want? There is a `templates/.empty` example that you can use to create a new technology stack. Checkout the `templates/.empty/README.md` file for details on how to create your own.

## 3️⃣ Provision Servers
Provisioning infrastructure for deployments should be easy and repeatable. The templates provide "infrastructure as code" that you can use to provision servers. 
Need multiple environments? No problem! Just repeat the process below for your stage, test, prod, or other environments.

> [!NOTE]
> Under the hood, this kit use the following technologies:
> - **Docker** to containerize your application. Each application uses a multi-stage build so that both the `dev` and `prod` environments sit on the same "base image".
> - **Docker Swarm** to deploy your application across a number of nodes. This makes for easy zero-downtime deployments that you can scale to meet demand.
> - **Ansible** as a configuration management tool to ensure your nodes have the right packages and configurations required.

Follow these steps to create a server environment:
1. Run `kit make server <name>` where `<name>` is the destination name (e.g., prod, stage, test). This will scaffold in the files needed to provision the Docker Swarm server. In the resulting directory:
   1. Update the `swarm_settings.yml` file with the following information:
      1. `___AWS_ACCOUNT_ID___` - the Amazon AWS account where the infrastructure will be provisioned.
      2. `___PREFIX___` - the prefix used in all the infrastructure component names.
      3. `___DOMAIN___` and `___SUB_DOMAIN___` - the domain and sub-domain to set up DNS records for. Your app will be available at https://___SUB_DOMAIN___.___DOMAIN___ 
      4. `num_worker_nodes` - update this number to the desired number of worker nodes.
      5. `is_mysql_needed` - update this flag if MySQL is needed. If this flag is `yes` then an RDS - MySQL variant will be provisioned. Scroll down to the RDS section and complete the configuration of db name, user, and passwords.
      6. `is_redis_needed` - update this flag if Redis is needed. If this flag is `yes` then an Elasticahce - Redis variant will be provisioned.
      7. `cidr_first_two_octets` - Set the first to octets of the CIDR block. This helps to avoid collisions if you are deploying multiple swarms.
2. Run `kit provision <name>` command. This runs an Ansible playbook that provisions the infrastructure, and configures your Docker Swarm.

After the above completes, you should have a cloud architecture where you can deploy your application. Repeat the above steps to create destinations for all your desired environments (e.g., test, stage, prod).

## 4️⃣ Deployments
First we need to configure a Docker container registry for our application.
1. Run `kit <app> make registry` answer the on-screen questions and you are done!

Now the deployment process is super easy:
1. Run `kit <app> image` to build a new production ready Docker image.
2. Run `kit <app> push <tag>` to tag and push the image to the configured container registry.
3. Run `kit <app:srv> deploy` where `<srv>` is one of the servers you set up. This will deploy your application to that server.

## 5️⃣ Shell Access and Running Remote Commands
To get shell access run the following:

`kit <app:srv> ssh <ip>`
- `app` is the application
- `srv` is the external server
- `ip` is an optional IP address in the external server Docker Swarm

Either `app` or `srv` should be specified. Examples:

- `kit laravel ssh` gets shell access inside the local `laravel` application
- `kit :prod ssh` gets shell access inside the manager node of the `prod` Docker Swarm
- `kit :prod ssh 10.0.1.48` gets shell access inside `10.0.1.48` node of the `prod` Docker Swarm

To run a remote command for an application execute the following:

`kit <app:srv> run <cmd>`

This will create a new container using the `<app>` image on the manager node of the `<srv>` Docker Swarm. Then it will execute `<cmd>` inside this new container. Once execution completes, the container is destroyed. Examples:

- `kit laravel:prod run php artisan migrate` runs `php artisan migrate` in a container on the manager node of the `prod` Docker Swarm. The container is created from the `laravel` image.
- `kit laravel:prod run "php artisan horizon &"` starts Laravel Horizon in a container on the manager node of the `prod` Docker Swarm. The container is created from the `laravel` image.
- `kit laravel:prod run "crond -f`

# General Information (WIP)

## 📁 Directory Structure

If you followed the Quick Start above you will find the following directory structure (skipping some details for clarity):

- `projects`: This is the main directory that holds all the files
    - `code`: When you `kit new <template>` the application code is created here. This is where you go and edit your code. Each application will be in its own subdirectory.
    - `infra`: This directory holds all the "kit code and templates"
        - `.code`: Kit code. You should not change any files in this directory. Changes will be lost when you git pull.
        - `.code/bin`: Kit shells scripts. You should not change these. Changes will be lost when you git pull.
        - `.code/templates`: Kit templates. You should not change these. You are welcome to create your own and submit pull requests. Would love to build the ecosystem.
        - `apps`: When you `kit new <template>`, the infrastructure code is copied into here. One subdirectory per application. This allows you to alter or fine tune the infrastructure code.
        - `servers`: When you `kit make server <name>` your new server environment will be created here.
        - `kit`: This is the main kit shell script. Entry point for all kit commands.

## 💥 Commands
Commands have the following format: `kit <app:srv> <command> <arguments>`

- `<app:srv>` is the application name and the deployment server.
  - This kit allows you to create many apps under one directory. Defaults to the app corresponding to the first child directory in `./apps`.
  - The `:srv` part is optional. If not specified, then the command is applied to the local dev environment. Some commands can be run on a remote server by specifying the `:srv` option. The `:srv` option needs to match the name of an existing server that was created using the `kit make server <name>` command.
- `<command>` is the command to be run. This kit has a number of "base" commands (e.g., `deploy`, `destroy`, `down`,...) that provide base functionality. Once you create an application using the `kit new <template>` command, then each application can provide additional commands (e.g., laravel applications have `artisan` add-on commands).
- Depending on the `<command>`, actions will be taken either on the `dev` or `prod` environments. The following files are used automatically when running commands that envoke Docker:

| env     | files                                                             |
|---------|-------------------------------------------------------------------|
| `dev`   | `docker-compose.yml`, `dev/docker-compose.yml` and `dev/.env`     |
| `prod`  | `docker-compose.yml`, `prod/docker-compose.yml` and `prod/.env`   |

> [!NOTE]
> The biggest difference between the `dev` and `prod` environments is where the application code exits:
> - `dev` environments have the code mounted into the image using a `volume`. This allows you to make code changes and those dynamically appear in the browser.
> - `prod` environments have the code "baked into the image" using a `add` statement. This creates a fully functioning containerized environment that can be pushed to a container registry and deployed to production or other servers.

- `<arguments>` are arguments expected by the command. For example, `kit new laravel` the `new` command takes as an argument the template name, this case `laravel`.

## 💡 Templates

### Template Structure
Each technology stack is created using the `kit new <template>` command. Each template has all the files necessary to create both the initial application code (based on a repo or a default starter project) and the infrastructure code.
Templates require the following files:
- `bin` directory to hold all the scripts / executables for the template
  - `init.sh` (optional) a custom initialization script that is run early in the `kit new` command. This allows the template to gather data and create the `env.dev` and `env.prod` environments.
  - `create.sh` a custom creations script that is run later in the `kit new` command. This allows the creation of the initial application code.
  - `set_env.sh` this is a script that sets any custom environment variables. it is run when any commands are executed for applications created with this template.
  - `commands` directory to hold all custom commands that are introduced by the template
    - `build.sh` a custom build script for the application code. What ever your application requires when it needs to be build can be put in here.
- `envs` directory to hold directories for each supported environment
  - `.env.template` a template file that generates user prompts and is transformed int `.env` files for each environment directory
  - `dev` directory to hold all files related to the `dev` environment
    - `.env` environment file for Docker Compose. This file is generated by transforming `.env.template`
    - `docker-compose.yml` (optional) overrides file for Docker Compose
  - `prod` directory to hold all files related to the `prod` environment
    - `.env` environment file for Docker Compose. This file is generated by transforming `.env.template`
    - `docker-compose.yml` (optional) overrides file for Docker Compose
- `deploy_settings.yml` this data is updated as part of the `kit <app> make registry` command and has settings relevant to deployments.
- `docker-compose.yml` the base compose file used by Docker
- `Dockerfile` a multi-stage build that allows a `dev` and `prod` target
- `README.md` specific information about the template

### Create Your Own Template?

Yes, please! Would love to integrate additional templates for the community to use with this kit platform.

Just follow the instructions in the `templates/.empty/README.md` file to create your own template.

Let me know if you have any issues!

Once you have a working template, create a pull request and I can merge it in!



## 💥 Older Videos

> [!NOTE]
> I am keeping these here as they may still be useful. This kit has morphed from being a "dedicated" laravel kit, to leveraging templates to support any technology stack. It has also evolved from just supporting a local development environment to providing a more complete workflow that includes deployment. So the following videos may provide some additional value, the exact commands shown might not match the current kit.

[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/nrG0O_qqMkk/0.jpg)](https://www.youtube.com/watch?v=nrG0O_qqMkk)
[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/Q8wrgqlpVY4/0.jpg)](https://www.youtube.com/watch?v=Q8wrgqlpVY4)
[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/qbdOO7pnJrU/0.jpg)](https://www.youtube.com/watch?v=qbdOO7pnJrU)
[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/GwgwgoWCm8Q/0.jpg)](https://www.youtube.com/watch?v=GwgwgoWCm8Q)

