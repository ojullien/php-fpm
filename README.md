# PHP7.x-FPM configuration and pool templates

PHP 7.x FPM personnal configuration and pool templates on Debian linux distribution.

*Note: I use this package for my own projects, it contains only the features I need.*

## Table of Contents

- [Requirements](#requirements)
- [Configuration](#configuration)
- [Pools](#pools)
- [Documentation](#documentation)
- [Contributing](#contributing)
- [License](#license)

## Requirements

- Debian linux distribution: ~9.5
- PHP-FPM: ~7.2

## Configuration

I do not modify any PHP configuration files. I just add new configuration files to override the default PHP configuration.

PHP includes a central configuration file `/etc/php/7.x/fpm/php.ini` and, then, the particular configuration snippets (`/etc/php/7.x/fpm/conf.d/*.ini`) which manage the modules.

PHP-FPM uses a central configuration file `/etc/php/7.x/fpm/php-fpm.ini` and configures the pools using conf files located in `/etc/php/7.x/fpm/pool.d/`

### Files

- zzz-prod: overrides the main PHP configuration for production server.
- zzz-dev: overrides the main PHP configuration for development server.

### How to setup the PHP personnal configuration

1. Copy the configuration [files](/src/mods-available) into `/etc/php/7.x/mods-available/`
2. Edit the named like zzz-***.ini files and make changes as you need.
3. Enable the configuration you need using `phpenmod zzz-***`
4. Review your settings using `php -i`

## Pools

I wrote thoses templates to ease the process of creating named-based PHP-FPM pools.

Each pool runs under is own user/group process (see [adduser](https://manpages.debian.org/stretch/adduser/adduser.8.fr.html) documentation). The process manager is set to `ondemand`.

### Features

- fpm/phpdisconf.sh: bash script used to disable a pool configuration.
- fpm/phpenconf.sh: bash script used to enable a pool configuration.
- fpm/conf-available/10-php-fpm.conf: overrides the main PHP-FPM configuration (php-fpm.conf)
- fpm/conf-available/20-domain_01.tld.conf: pool settings for domain_01.tld.
- fpm/conf-available/20-domain_02.tld.conf: pool settings for domain_02.tld.
- fpm/conf-available/common.conf: contains common settings used by all pools.
- fpm/conf-available/www.conf: default PHP FPM pool settings.

### How to setup the pools

1. Copy all the [files and directories](/src/fpm) into /etc/php/7.x/fpm
2. Move the default pool from `/etc/php/7.x/fpm/pool.d/www.conf` to `/etc/php/7.x/fpm/conf-available/www.conf`
3. Make executable the `phpdisconf.sh` script file using `chmod u+x /etc/php/7.x/fpm/phpdisconf.sh`
4. Make executable the `phpenconf.sh` script file using `chmod u+x /etc/php/7.x/fpm/phpenconf.sh`
5. Edit the FPM configuration file (`/etc/php/7.x/fpm/conf-available/10-php-fpm.conf`) and make changes as you need.
6. Enable yours FPM settings using `./phpenconf.sh 10-php-fpm`
7. Edit the named like `/etc/php/7.x/fpm/conf-available/20-***.conf` files and make changes as you need.
8. Enable the pools using `./phpenconf.sh 20-domain_01.tld 20-domain_02.tld`
9. Restart the PHP-FPM using `systemctl restart php7.2-fpm.service`

## Documentation

I wrote and I use this package for my own projects. And, unfortunately, I do not provide exhaustive documentation. Please read the code and the comments ;)

For instructions on how to use, best practices, templates and other usage information, please visit the [PHP documentation](https://secure.php.net/docs.php).

## Contributing

Thanks you for taking the time to contribute. Please fork the repository and make changes as you'd like.

As I use these configuration and templates for my own projects, it contains only the features I need. But If you have any ideas, just open an [issue](https://github.com/ojullien/php7.x-fpm/issues) and tell me what you think. Pull requests are also warmly welcome.

If you encounter any **bugs** in the configuration or templates, please open an [issue](https://github.com/ojullien/php7.x-fpm/issues).

Be sure to include a title and clear description,as much relevant information as possible, and a code sample or an executable test case demonstrating the expected behavior that is not occurring.

## License

**php7.x-fpm configuration and templates** are open-source and are licensed under the [MIT License](https://github.com/ojullien/php7.x-fpm/blob/master/LICENSE).
