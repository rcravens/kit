# 🚀 Kit - Empty Template 🚀

To create your own template do the following:

1. Create your Docker files.
2. Create template kit commands.
3. Set environment variables for your template.

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

## 💥 Kit Commands

Each template can provide additional commands to the kit platform. By following the `example.sh` format your commands will automatically be loaded for applications created from your template.

## 💥 Environment Variables

When a user runs a kit command for an application created by your template, the `set_env.sh` script is run early in the command life-cycle. This allows your template to define environment variables (or perform other initialization) that your commands will leverage. That allows you to factor our "common code" and place it in the `set_env.sh` script.