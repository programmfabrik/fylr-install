How to take a look at fylr in your local environment.

# Requirements

* Docker Desktop: https://www.docker.com/products/docker-desktop

* 4 GB RAM available (we recommend 8 GB)

# Installation

1. create the directories for configuration:

```bash
mkdir -p fylr/config
```

2. download example configuration files

```bash
curl https://raw.githubusercontent.com/programmfabrik/fylr-install/main/desktop/fylr.yml > flyr/config/fylr.yml
curl https://raw.githubusercontent.com/programmfabrik/fylr-install/main/desktop/execserver.yml > flyr/config/execserver.yml
```
3. increase memory limit for elasticsearch:

* if your container engine is Docker Desktop for Windows with WSL2:

```bash
wsl -u root sysctl -w vm.max_map_count=262144
```

* If you are using Linux only:

```bash
sudo sysctl -w vm.max_map_count=262144
```

4. docker-compose: Much of the setup is encapsulated in a docker-compose file. Download and use it like this:

```bash
curl https://raw.githubusercontent.com/programmfabrik/fylr-install/main/desktop/docker-compose.yml > docker-compose.yml
docker-compose up -d
```

# result

you can now surf to your local fylr webfrontend at http://127.0.0.1:8080

# Further reading

* [Use a customized Web-Frontend](../customization/webfrontend.md)

