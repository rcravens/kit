# 🚀 Kit - Laravel Template 🚀

This is a pretty simplified, but complete, workflow for using Docker and Docker Compose with Laravel development. The included docker-compose.yml file, Dockerfiles, and config files, set up a LEMP stack powering a Laravel application in the `code` directory.

## 💥 Quick Start

Run `kit new laravel` and then answer the questions. That's it!

During the creation process the `build` script will be executed.
- `build`: Runs the following:
    - `composer install`
    - `php artisan migrate`
    - `npm install`
    - `npm run build`
## 💥 Laravel Commands


- `kit <app:srv> artisan <cmd>`: Allows you to run artisan commands inside the development or production (`srv`) container.
- `kit <app> composer`: Allows you to run composer commands inside the development container.
- `kit <app:srv> cron <start|stop>`: Start or stop the crontab scheduled jobs. 
- `kit <app:srv> horizon <start|stop>`: Start or stop the horizon service
- `kit <app:srv> migrate`: Runs the migrations.
- `kit <app> npm`: Allows you to run NPM commands inside the development container