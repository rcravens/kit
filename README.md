# 🚀 Application Development Kit 🚀

This is an easy-to-use application starter kit. The workflows from creating a new application, doing development, and managing dev, stage, and prod environments are included.

> [!NOTE]
> Why another Docker based workflow? Two reasons:
> - 👉 Template Based - I want to be able to use the same kit for many different frameworks. So no matter if you are developing in **Laravel** or **Django** or just need to spin up a quick **MySQL** data server, there are templates to support your needs.
> - 👉 Enhanced Environment - The template provides the initial infrastructure as code. If needed, you can modify the image to add new features. For example, I had a need to integrate with SQL Server, Active Directory, and other services, so a quick modification of the Dockerfile got me where I needed to be.
> - 👉 Architecture - I believe that the code for the CI/CD or DevOps tooling does not belong in the same git repo as your application code.
> - 👉 Deployments - The deployment pipeline should leverage infrastructure as code and be easy. This kit makes it easy to deploy your changes to any number of servers.

# ‼️ Getting Started

## 1️⃣ Installation

### Docker Environment

To get started, make sure you have [Docker installed](https://docs.docker.com/docker-for-mac/install/) on your system.

### Install the kit

Setup directory structure and clone this repo:

1. `mkdir project`
2. `cd projects`
3. `git clone https://github.com/rcravens/kit.git infra`
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
1. Manually create the desired number of linux boxes you want in your Docker Swarm. Future versions will automate this step, but for now you just need to have the new instances running with public / private ip addresses.
2. Run `kit make server <name>` where `<name>` is the destination name (e.g., prod, stage, test). This will scaffold in the files needed to configure the Docker Swarm server. In the resulting directory:
   1. Add the ssh key pair to the `.ssh` directory that was created.
   2. Update the `inventory.yml` file with the IP addresses and key pairs for the manager and worker nodes.
   3. Update the `server_settings.yml` file.
3. Run `kit provision <name>` command. This runs an Ansible playbook that provisions and configures your nodes.

After the above completes, you should have a destination where you can deploy your application. Repeat the above steps to create destinations for all your desired environments (e.g., test, stage, prod).

## 4️⃣ Deployments
First we need to configure a Docker container registry for our application.
1. Run `kit <app> make registry` answer the on-screen questions and you are done!

Now the deployment process is super easy:
1. Run `kit <app> image` to build a new production ready Docker image.
2. Run `kit <app> push <tag>` to tag and push the image to the configured container registry.
3. Run `kit <app> deploy <dest>` where `<dest>` is one of the servers you set up. This will deploy your application to that server.

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
Commands have the following format: `kit <app> <command> <arguments>`

- `<app>` is the application name. This kit allows you to create many apps under one directory. Defaults to the app corresponding to the first child directory in `./apps`.
- `<command>` is the command to be run. This kit has a number of "base" commands (e.g., `deploy`, `destroy`, `down`,...) that provide base functionality. Once you create an application using the `kit new <template>` command, then each application can provide additional commands (e.g., laravel applications have `artisan` add-on commands).
- Depending on the `<command>`, actions will be taken either on the `dev` or `prod` environments. The following files are used automatically when running commands that envoke Docker:

| env     | files                                                             |
|---------|-------------------------------------------------------------------|
| `dev`   | `docker-compose.yml`, `docker-compose.dev.yml` and `.env.dev`     |
| `prod`  | `docker-compose.yml`, `docker-compose.prod.yml` and `.env.prod`   |

> [!NOTE]
> The biggest difference between the `dev` and `prod` environments is where the application code exits:
> - `dev` environments have the code mounted into the image using a `volume`. This allows you to make code changes and those dynamically appear in the browser.
> - `prod` environments have the code "baked into the image" using a `add` statement. This creates a fully functioning containerized environment that can be pushed to a container registry and deployed to production or other servers.

- `<arguments>` are arguments expected by the command. For example, `kit new laravel` the `new` command takes as an argument the template name, this case `laravel`.

## 💡 Templates

### Template Structure
Each technology stack is created using the `kit new <template>` command. Each template has all the files necessary to create both the initial application code (based on a repo or a default starter project) and the infrastructure code.
Templates require the following files:
- `.env.example` gets transformed by `bin/init.sh` into `.env.dev` and `.env.prod`
- `docker-compose.yml` the base compose file used by Docker
- `docker-compose.dev.yml` and `docker-compose.prod.yml` the override files for the `dev` and `prod` environments
- `Dockerfile` a multi-stage build that allows a `dev` and `prod` target
- `bin/init.sh` a custom initialization script that is run early in the `kit new` command. This allows the template to gather data and create the `env.dev` and `env.prod` environments.
- `bin/create.sh` a custom creations script that is run later in the `kit new` command. This allows the creation of the initial application code.
- `bin/set_env.sh` this is a script that sets any custom environment variables. it is run when any commands are executed for applications created with this template.
- `bin/commands/build.sh` a custom build script for the application code. What ever your application requires when it needs to be build can be put in here.
- `other files` any other files that your template needs.

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

