# Docker

Since fylr requires a fully running installation of docker, refer to it's official documentation [how to install docker](https://docs.docker.com/engine/install/) and follow these steps.

## Installation

Since fylr is deployed via. docker, we don't need to install 3rd-party applications since everything is included in the fylr container.

For deployment, you only need to place the `docker-compose.yml` somewhere on your system and configure the volume paths. Our recommendation is to create the following directory tree to run the fylr:

```text
./fylr
  /data
    /elastic
    /minio
    /postgres
    /sqlite
  /config
    /execserver
    /fylr
  /docker-compose.yml
```

The following commands help you to set up this directory tree:

```bash
mkdir -p ./fylr/data/elastic ./fylr/data/minio ./fylr/data/postgres ./fylr/config ./fylr/resources ./fylr/data/sqlite
chmod -R a+rwx ./fylr/data
```

**ATTENTION**

As you have seen, we have manipulated the access rights to the file tree to 'a+rwx' for the data directory of `postgres`, `minio`, `elastic` and `sqlite`. Since `elastic`, `postgres`, `minio` and `sqlite` need permissions to write to disk, these permissions are required.

### docker-compose.yml

Since fylr is provided via. docker and the easiest way to provide a set of containers is to provide a `docker-compose` file, we provide two solutions for you:

- [docker-compose.postgres.yml](docker-compose.postgres.yml)
- and [docker-compose.sqlite.yml](docker-compose.sqlite.yml)

If you want to run the ***sqlite*** solution, you must use the `docker-compose.sqlite.yml`.

```bash
docker-compose -f docker-compose.sqlite.yml up -d
```

## Webfrontend changes

Since some installations require you to change the webfrontend, the following documentation contains steps for providing a custom webfrontend.

During the following steps we assume you have placed your webfrontend to the following path: `./fylr/webfrontend`.

Since the webfrontend is not reachable for the fylr yet, we must make it known to him. Such goal can be reached by adding a volume mapping to the fylr container as you can see in the configuration snipped below:

```yaml
  fylr-server:
    image: "docker.fylr.io/fylr/fylr:main"
    container_name: fylr-server
    ...
    volumes:
      - "./fylr/webfrontend:/fylr/files/webfrontend"
```
