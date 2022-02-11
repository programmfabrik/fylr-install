# fylr installation methods

* [desktop/README.md](desktop/README.md): To temporarily set up fylr on your Desktop.

* [docker/README.md](docker/README.md): To set up fylr on a server via docker: will be linked when updated.

* (kubernetes/README.md): To set up fylr via kubernetes: will be linked when updated.

Screenshot of running fylr webfrontend:

![](assets/fylr-preview.png)

## Download fylrctl

Since the fylr repository is so far in the private domain of Programmfabrik GmbH, there is no way to install the binary from source. Respecting the need to test fylr and to backup and restore an existing installation of easydb5 in fylr, we decided to provide versioned binaries that allow you to download the tool. Until now we only provide a Linux amd64 binary version.

Structure of the URL: https://s3.eu-central-1.wasabisys.com/releases/fylrctl/<version>/<binary_name>

Example: https://s3.eu-central-1.wasabisys.com/releases/fylrctl/6.0.0-alpha.3/fylrctl_linux_64bit

Using bash and curl to download that binary and make it executable:

```bash
curl -X GET https://s3.eu-central-1.wasabisys.com/releases/fylrctl/6.0.0-alpha.3/fylrctl_linux_64bit -o fylrctl
chmod u+x fylrctl
```
