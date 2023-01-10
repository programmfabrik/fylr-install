# Requirements

* 16 GB of RAM
* The below mentioned containers are linux containers, so you need a linux server or linux virtual machine.
* fylr requires a running container engine. And in the here proposed installation method, we use docker. So refer to docker's official documentation: [how to install docker](https://docs.docker.com/engine/install/) and follow these steps.
* Port 443 for https and port 80 for registering (and renewing) an https certificate with letsencrypt.

The following commands assume a Debian or Ubuntu server as an example and a bash shell.

* docker-compose

```bash
apt-get install docker-compose
```

* Memory setting needed for elasticsearch:

```bash
echo "vm.max_map_count=262144" >> /etc/sysctl.d/99-memory_for_elasticearch.conf
sysctl -p /etc/sysctl.d/99-memory_for_elasticearch.conf
```

## Installation

Let us assume that you will install fylr in `/srv/fylr`:

```bash
mkdir /srv/fylr ; cd /srv/fylr
```

Create the following directories for the persistent data and configuration:

```bash
mkdir -p config/fylr postgres assets backups sqlbackups elasticsearch
chown 1000 assets backups elasticsearch
chown  999 postgres sqlbackups
```

## configuration

We suggest that you use our example configuration as a starting point:

```bash
curl https://raw.githubusercontent.com/programmfabrik/fylr-install/main/docker/config/fylr/fylr.yml -o config/fylr/fylr.yml
```

Edit `config/fylr/fylr.yml` and replace strings with `EXAMPLE`.

If unsure about wasting your quota with letsencrypt, start with `useStagingCA: true` until you see that a certificate (although not trusted by browser yet) could be retrieved.

## docker-compose

Much of the setup is encapsulated in a docker-compose file. Download and use it like this:

The following commands also assume that you are in the `/srv/fylr` directory.

```bash
curl https://raw.githubusercontent.com/programmfabrik/fylr-install/main/docker/docker-compose.yml -o docker-compose.yml

docker-compose up
```

Ctrl and c stops the services again.

If you are satisfied you can let them run in the background with:

```bash
docker-compose up -d
```

## Result

You can now surf to your fylr webfrontend at Port 443

Default login is `root` with password `admin`. Please replace with a secure password: Click on `root` in the upper left corner.

## Troubleshooting

* `docker-compose` needs to be executed in the directory with the `docker-compose.yml`.

* When elasticsearch does not work, make sure you used `sysctl` as shown above.

Such messages can be safely ignored:
> could not obtain lock on row in relation

> WRN Error occurred in NewIntrospectionRequest error=request_unauthorized Env=api
> WRN Accepting token failed error

## Further reading

* [Import an easydb into fylr](../customization/restore-easydb5.md)

* [Use a customized Web-Frontend](../customization/webfrontend.md)

