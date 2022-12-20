# How to add the data of an easydb 5 to a fylr

## Preparations

You may or may not want to prepare some of the following:

* Allow purging in your fylr instance. Either in a fylr.yml:

```
fylr:
  allowpurge: true
  db:
    init:
      config:
        system:
          config:
            purge:
              allow_purge: true
              purge_storage: true
```

* Or in the frontend in URL`/configmanager`: `Development`: `Purge`: Check `Allow [...]` and `Delete [...]`. To not loose these settings while purging, also download and upload them as described in the next point.

* In case you want to override defaults during purge: Download the base config containing your settings in fylr web-frontend (URL`/configmanager`: gear symbol at the bottom), to later upload it during and with `fylr restore --purge --base-config=DOWNLOADED_FILE`.

* Another way to preserve location configuration during purge & restore is to write it in your fylr.yml. For example:
```
fylr:
  db:
    # The init block is used to pre-fill the database when its created or purged.
    init:
      # Inline base config. Default is empty.
      config:
      # E.g. to set up a purgeable system with default storage locations
      # mylocalfiles & mys3, configure the following. The location_default map
      # accepts location ids as well as names:
        system:
          config:
            purge:
              allow_purge: true
              purge_storage: true
            location_defaults:
              originals: mys3
              versions: mylocalfiles
              backups: mys3

      # preconfigure locations for empty databases
      locations:
        # the location's name can be any string which you choose
        #
        # Inside the storage location fylr will create a structure like this:
        #
        # [prefix/]fylr-UUID/originals
        # [prefix/]fylr-UUID/versions
        # [prefix/]fylr-UUID/backups
        mylocalfiles:
          # The kind is either "file" or "s3" (see below)
          kind: file
          # Each location can configure a prefix which will
          # be attached before the file to be created
          prefix: "myprefix/"
          # Set to true if files in this location can be
          # purged by FYLR (if the purge api call is used)
          allow_purge: true
          config:
            file:
              # path inside the container
              dir: "/fylr/files/backups"
        mys3:
          kind: s3
          prefix: "myprefix/"
          allow_purge: true
          config:
            s3:
              bucket: myfylr
              accesskey: "minio"
              secretkey: "minio123"
              region: "us-east-1"
              ssl: false
```

* In case you want to restore without purge (This would be atypical): Upload the data model into fylr. (`fylr restore --purge` does the upload of the data model for you).

## Backup easydb5

1. Surf to your fylr and add to the URL: /inspect/backup/

  * example: http://fylr.example.com/inspect/backup/

2. Fill in the paragraph `Create backup [...] via API` there. Use URL and login of an easydb 5. Make sure `OAuth2` is not selected, as easydb5 does not know OAuth. Click the button `backup`.

## Restore into fylr

Fill in the paragraph `Restore backup [...] via API`. This time with URL and login of fylr.

  * This will delete the data in fylr. And the data model.

  * Make sure `OAuth2` is selected, it is mandatory for fylr.
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

# Command Line

If you want to access the backup via command line:

```
docker exec -ti fylr-server /bin/sh
cd /tmp/fylrctrl
```

* The directory `/tmp/fylrctrl` could also be used for a bind mount if you need space for a larger backup.

Each backup and restore log shows at the end, which command line was used. After checking paths and passwords it can be executed by hand in the container:

```
docker exec -ti fylr-server /bin/sh
cd /tmp/fylrctrl
fylr restore [...]
```

* If you use this to continue an aborted restore then replace `--purge` with `--continue`.

* There is also help with `fylr restore --help`.

* Examples as a starting point:

```
docker exec -ti fylr-server /bin/sh
cd /tmp/fylrctrl
fylr backup --server https://easydb.example.com/api/v1 \
 --login root --password '*' --dir backup1 --log backup1/backup.log \
 --chunk 100 --size 1000 --limit 0 --compression 9 \
 --purge
```

* during backup, `--purge` will just "purge" any backup with same name.

```
docker exec -ti fylr-server /bin/sh
cd /tmp/fylrctrl
fylr restore --server http://localhost:8080/api/v1 --login root --password '*' \
 -m backup1/manifest.json --chunk 100 --clientId web-client --clientSecret foo \
 --clientTokenUrl http://localhost:8080/api/oauth2/token \
 --limit 0 --upload-parallel 4 --timeout 15 --log backup1/restore.log \
 --file-api eas --upload-versions \
 --purge --continue # EITHER --purge OR --continue
```

* during restore, use `--purge` on your first run and if that aborts, `--continue` instead.

