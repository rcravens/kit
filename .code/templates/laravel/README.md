# 🚀 Kit - Laravel Template 🚀

This is a pretty simplified, but complete, workflow for using Docker and Docker Compose with Laravel development. The included docker-compose.yml file, Dockerfiles, and config files, set up a LEMP stack powering a Laravel application in the `code` directory.

## 💥 Quick Start

1. Run `kit new laravel` and then answer the questions. That's it!

## 💥 Laravel Commands

- `build`: Runs the following:
    - `composer install`
    - `php artisan migrate`
    - `npm install`
    - `npm run build`
- `artisan`: Allows you to run artisan commands inside the container.
- `composer`: Allows you to run composer commands inside the container.
- `cron`: WIP
- `horizon`: WIP
- `migrate`: Runs the migrations.
- `npm`: Allows you to run NPM commands inside the container