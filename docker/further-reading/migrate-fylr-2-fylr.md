# how to migrate a whole fylr into another

e.g. when you want to create a production instance with data from a development instance. In the example below called old server and new server.

## prepare

Make sure you have a mounted volume for sql-backups (e.g. in the [docker-compose.yml](https://github.com/programmfabrik/fylr-install/blob/main/docker/docker-compose.yml#L34) of our installation [instructions](https://github.com/programmfabrik/fylr-install/blob/main/docker/README.md)):
```
services:
  postgresql:
    volumes:
      - "./sqlbackups:/mnt"
```

## migrate

We currently recommend to treat this like a sysadmin's backup and restore, so you need access to the command line.

1. dump the sql of the old server:
```
docker exec postgresql pg_dump -U fylr -v -Fc -f /mnt/fylr.pg_dump fylr
```

The sql does include datamodel, objects, users, groups, user rights, base configuration.

2. install fylr on the new server but only start postgresql:
```
docker-compose up -d postgresql
```
3. import the sql-dump on the new server: (scp is just an example method of copying here, used on the new server)
```
scp old-server:/srv/fylr/sqlbackups/fylr.pg_dump /srv/fylr/sqlbackups/

docker exec -it postgresql pg_restore -U fylr -v -d fylr /mnt/fylr.pg_dump
```
4. copy assets from old server to new server. For example, with file based assets (not s3 based):
```
rsync -a --numeric-ids old-server:/srv/fylr/assets/* /srv/fylr/assets
```
5. start fylr on the new server:
```
docker-compose up -d
```
6. You may need to force a re-index in Elasticsearch: surf to /inspect/system/ on the new server, so e.g. fylr.new-server.example.com/inspect/system/ and click a Reindex button.
