## How to add the data of an easydb 5 to an empty fylr

1. Surf to your fylr and add to the URL: /inspect/backup/

  * example: http://fylr.example.com/inspect/backup/

2. Fill in the paragraph `Create backup [...] via API` there. Use URL and login of an easydb 5. Make sure `OAuth2` is not selected, as easydb5 does not know OAuth. Click the button `backup`.

3. Fill in the paragraph `Restore backup [...] via API`. This time with URL and login of fylr.

  * This will delete the data in flyr. And the data model.

  * Make sure `OAuth2` is selected, it is mandatory for flyr.
    * OAuth2 credentials are configured in fylr.yml, example:

```
fylr:
  services:
    api:
      oauth2Server:
        clients:
          web-client:
            # bcrypt hash of foo
            clientSecret: $2y$04$81xGNnm8PS1uiIzjbos6Le3NzFaNB0goNqnBpOx7S/EyrayzJCNAq
    webapp:
      oauth2:
        clientID: web-client # matches above
        clientSecret: foo    # matches above
```

  * When in doubt about the form field "File Mode":
    * "Client Copy" copies asset files from easydb to fylr via your browser.
    * "Server Copy" copies asset files from easydb to fylr as a server background task, instead.
    * "Remote leave" does not copy asset files but uses the easydb-URLs to display assets in fylr.
    * "Remote leave, versions": dito, but in fylr generate image variants for preview.
    * "Remote leave, fast": dito, but from easydb even use the image variants for preview.

  *  Click the button `restore`.

## Command Line

If you want to access the backup via command line:

```
docker exec -ti fylr-server /bin/sh
cd /tmp/fylrctrl
```

* The directory `/tmp/fylrctrl` could also be used for a bind mount if you need space for a larger backup.

At the end of each backup and restore log there is the command line used. After checking paths and passwords it can be executed by hand in the container:

```
docker exec -ti fylr-server /bin/sh
cd /tmp/fylrctrl
/fylr/bin/fylrctl restore [...]
```

* If you use this to continue an aborted restore then replace `--purge` with `--continue`.

* There is also help with `fylrctl --help`.

* Examples as a starting point:

```
docker exec -ti fylr-server /bin/sh
cd /tmp/fylrctrl
/fylr/bin/fylrctl backup --server https://easydb.example.com/api/v1 \
 --login root --password '*' --dir backup1 --log backup1/backup.log \
 --chunk 100 --size 1000 --limit 0 --compression 9 \
 --purge
```

* during backup, `--purge` will just "purge" any backup with same name.

```
docker exec -ti fylr-server /bin/sh
cd /tmp/fylrctrl
/fylr/bin/fylrctl restore --server http://localhost:8080/api/v1 --login root --password '*' \
 -m backup1/manifest.json --chunk 100 --clientId web-client --clientSecret foo \
 --clientTokenUrl http://localhost:8080/api/oauth2/token \
 --limit 0 --upload-parallel 4 --timeout 15 --log backup1/restore.log \
 --file-api eas --upload-versions \
 --purge --continue # EITHER --purge OR --continue
```

* during restore, use `--purge` on your first run and if that aborts, `--continue` instead.

