## FOR MAJOR RELEASES

Follow manual install guide

https://docs.nextcloud.com/server/21/admin_manual/maintenance/manual_upgrade.html

## FOR MINOR RELEASES

Bring the server down: `docker-compose down`

Retrieve the desired image tag from docker hub by adding it to docker-compose.yml

Then bring the server back up: `docker-compose up -d`

Run occ upgrade command


***
LEGACY!!! only use with generic docker image

## To upgrade nextcloud when there is an available update for "stable-apache" image:

`docker-compose down`

`docker image ls`

You will need to delete the images `nc-dc_app` and `nextcloud`

`docker rmi (IMAGE ID)`

`docker-compose up -d`

Done!
