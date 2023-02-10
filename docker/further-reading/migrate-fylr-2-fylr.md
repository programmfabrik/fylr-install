# how to migrate a whole fylr into another

e.g. when you want to create a production instance with data from a development instance.

## prepare

Make sure you have a mounted volume for sql-backups (this was missing in our instructions' docker-compose.yml until recently):
```
services:
  postgresql:
    volumes:
      - "./sqlbackups:/mnt"
```

## migrate

We currently recommend to treat it like a sysadmin's backup and restore:

1. dump the sql of the dev server:
```
docker exec postgresql pg_dump -U fylr -v -Fc -f /mnt/fylr.pg_dump fylr
```

The sql does include datamodel, objects, users, groups, user rights, base configuration.

2. install the prod fylr but only start postgresql:
```
docker-compose up -d postgresql
```
3. import the sql-dump on the prod server:
```
scp dev-server:/srv/fylr/sqlbackups/fylr.pg_dump /srv/fylr/sqlbackups/

docker exec -it postgresql pg_restore -U fylr -v -d fylr /mnt/fylr.pg_dump
```
4. copy assets from dev to prod. For example, with file based assets (not s3 based):
```
rsync -a --numeric-ids dev-server:/srv/fylr/assets/* /srv/fylr/assets
```
5. start fylr on prod:
```
docker-compose up -d
```
6. You may need to force a re-index in Elasticsearch: surf to fylrURL/inspect/system/ and click a Reindex button

