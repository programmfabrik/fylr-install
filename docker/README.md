# Docker

Since fylr requires a fully running installation of docker, refer to it's official documentation [how to install docker](https://docs.docker.com/engine/install/) and follow these steps.

## Single installation

Since fylr is deployed via. docker, we don't need to install 3rd-party applications since everything is included in the fylr container.

For deployment, you only need to place the `docker-compose.yml` somewhere on your system and configure the volume paths. Our recommendation is to create the following directory tree to run the fylr:

```text
./fylr
  /data
    /elastic
    /minio
    /postgres
  /config
  /docker-compose.yml
```

The following commands help you to set up this directory tree:

```bash
mkdir -p ./fylr/data/elastic ./fylr/data/minio ./fylr/data/postgres ./fylr/config ./fylr/resources ./fylr/data/sqlite
chmod -R a+rwx ./fylr/data
```

**ATTENTION**

As you have seen, we have manipulated the access rights to the file tree to 'a+rwx' for the data directory of `postgres`, `minio` and `elastic`. Since `elastic`, `postgres` and `minio` need permissions to write to disk, these permissions are required.

### docker-compose.yml

Since fylr is provided via. docker and the easiest way to provide a set of containers is to provide a `docker-compose` file, we provide two solutions for you:

- [docker-compose-postgres.yml](docker-compose-postgres.yml)
- and [docker-compose-sqlite.yml](docker-compose-sqlite.yml)

If you want to run the ***sqlite*** solution, you must copy the `fylr-sqlite.yml` to the configuration directory and rename it to `fylr.yml`.

```bash
cp fylr-sqlite.yml ./fylr/config/fylr.yml
```

As you have seen in the docker-compose file, we use a **custom** elastic container. This is a requirement because fylr uses resources that the standard elastic container does not provide. If you want to see what changes have been made to the container, you can check out our official repository at [github](https://github.com/programmfabrik/elastic-icu).
