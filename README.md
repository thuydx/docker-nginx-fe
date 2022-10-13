# Docker Linux Nginx
> Do not use this Nginx in Production.
> For production, use `thuydx/nginx-fe`

Name          | Version | Port
--------------|---------|------
nginx         | 1.18.0  | 80

## Usage

Install [docker](https://docs.docker.com/install/) in your machine.
Also recommended to install [docker-compose](https://docs.docker.com/compose/install/).

```sh
# pull latest image
docker pull thuydx/nginx-fe:latest
```

## With Docker compose

Create a `docker-compose.yml` in your project root with contents something similar to:

```yaml
# ./docker-compose.yml
version: '3'

services:
  app:
    image: thuydx/nginx-fe:latest
    # For different app you can use different names. (eg: )
    container_name: some-app
    volumes:
      # app source code
      - ./path/to/your/app:/var/www/html
      # db data persistence
      - db_data:/var/lib/mysql
      # Here you can also volume php ini settings
      # - /path/to/zz-overrides:/usr/local/etc/php/conf.d/zz-overrides.ini
    ports:
      - 80:80
    environment:
      -
volumes:
  db_data: {}
```

### Nginx

URL rewrite is already enabled for you.

Either your app has `public/` folder or not, the rewrite adapts automatically.