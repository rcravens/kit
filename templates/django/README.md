# 🚀 Kit - Empty Template 🚀

To create your own template do the following:

1. Create your Docker files.
2. Create setup scripts for the application.
3. Create template kit commands.

## 💥 Docker Files

The following docker file must exist:

- `docker-compose.yml` - This is the root Docker Compose environment.
- `docker-compose.ENV.yml` - This is the override Docker Compose environment for the ENV=`dev`, `stage`, or `prod` environments.
- `.env.ENV` - This is the environment variables for the ENV=`dev`, `stage`, or `prod` environments.

> [!NOTE]
> This empty template contains the Docker files to create a Nginx / PHP-FPM stack. The `docker-compose.ENV.yml` files target a build that is included in the multi-stage Dockerfile (`web.dockerfile`).


Whe the kit calls docker command it will call it in the following format:

`docker compose -f "${APP_DIRECTORY}/docker-compose.yml" -f "${APP_DIRECTORY}/docker-compose.${ENV}.yml" --env-file "${APP_DIRECTORY}/.env.${ENV}" [COMMAND]`

This allows you to differentiate Docker environments.

## 💥 Setup Scripts

`bin/init.sh` - Initialize your application be collecting data, copying files, ...etc.
`bin/create.sh` - If needed, create your application in the `../code/[APP_NAME]` directory. This should include git clone, and build steps.
`bin/set_env.sh` - When a user runs a kit command for an application created by your template, this script is run early in the command life-cycle. This allows your template to define environment variables (or perform other initialization) that your commands will leverage. That allows you to factor our "common code" and place it in the `set_env.sh` script.

## 💥 Kit Commands

Each template can provide additional commands to the kit platform. By following the `example.sh` format your commands will automatically be loaded for applications created from your template.

If your project requires a build step (e.g., `composer install` or `npm install`) you can package the build commands into the `build.sh` example. This is currently setup for building a Laravel project, but can be adapted for your project. The `build.sh` command for the template is called when you call `kit new` for the template type.
