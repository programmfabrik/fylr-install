# fylr installation methods

* [container desktop](desktop/README.md): Set up the fylr container on your desktop

* [container server](docker/README.md): Set up fylr container on a server: will be linked when updated

* [kubernetes](kubernetes/README.md): Set up fylr via Kubernetes

* [fylr.exe](windows/README.md): Set up fylr.exe on a Windows desktop

Screenshot of running fylr webfrontend:

![fylr-preview](assets/fylr-preview.png)

## Changelog

## 08.22.2022

On 8/22/2022, fylr received a refactor that breaks backward compatibility. This is an important change and requires an update to your configuration. To simplify this process, we have updated the examples to use the new format.

* [desktop/execserver.yml](desktop/execserver.yml)
* [docker/config/execserver/fylr.yml](docker/config/execserver/fylr.yml)
* [kubernetes/execserver/config/execserver.yaml](kubernetes/execserver/config/execserver.yaml)

## Download fylrctl

Since the fylr repository is so far in the private domain of Programmfabrik GmbH, there is no way to install the binary from source. Respecting the need to test fylr and to backup and restore an existing installation of easydb5 in fylr, we decided to provide versioned binaries that allow you to download the tool. Until now we only provide a Linux amd64 binary version.

Structure of the URL: https://s3.eu-central-1.wasabisys.com/releases/fylrctl/<-version->/<-binary_name->

Example: https://s3.eu-central-1.wasabisys.com/releases/fylrctl/6.0.0-alpha.3/fylrctl_linux_64bit

Using bash and curl to download that binary and make it executable:

```bash
curl -X GET https://s3.eu-central-1.wasabisys.com/releases/fylrctl/6.0.0-alpha.3/fylrctl_linux_64bit -o fylrctl
chmod u+x fylrctl
```
