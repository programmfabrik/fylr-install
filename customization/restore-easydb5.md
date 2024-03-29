# How to add the data of an easydb 5 to a fylr

(A migration from fylr to fylr is instead described in another document: [migrate a whole fylr into another](../docker/further-reading/migrate-fylr-2-fylr.md))

## Preparations

You may or may not want to prepare some of the following:

* Direct the easydb to include the passwords, described [here](https://docs.easydb.de/en/technical/api/user/#returning-password-hashes).

* The root password is a special case: You probably want to set the destination fylr’s root password to a secure one. Especially when you install a fresh fylr or drop the databse and thus reset the password to the insecure `admin`. Production data should not be migrated into an instance were it is not protected by a secure password. `fylr migrate` treats the root password like this: During the migration, root’s password will be set to the value it has had at the start of the migration in fylr. So do not expect it to have the value of the easydb’s root password.

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

* In case purging the destination fylr does not work, do it via these commands:

```
docker-compose kill fylr opensearch # or elasticsearch instead of opensearch, also in the following lines
docker rm -v fylr opensearch
rm -rf /srv/fylr/assets/fylr-example-9308-4362-b773-3434f06ef388/* # replace example string 

docker exec -ti postgresql psql -U fylr postgres
DROP DATABASE fylr;
CREATE DATABASE fylr OWNER fylr;
\q

rm -rf /srv/fylr/indexer/nodes/0
docker-compose up -d opensearch

docker-compose up -d fylr
```

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

### backup via frontend
(easier to get into but not robust for long runs, we recommend command line, see below)

1. Surf to your fylr and add to the URL: /inspect/backup/

  * example: http://fylr.example.com/inspect/backup/

2. Fill in the form fields of the paragraph `Create backup [...] via API` there. Use URL and login of an easydb 5. Make sure `OAuth2` is not selected, as easydb5 does not know OAuth. Click the button `backup`.

### backup via command line
(harder to learn but more robust and flexible)

Also run `fylr backup -h` for more infos about the parameters.

Example:
```
fylr backup -v \
  --server https://easydb.example.com/api/v1/ \
  --login root --password 'cleartext-example' \
  --dir backup1 --compression 9 --purge \
  --chunk 100 --size 1000 --limit 0
```

If your fylr is inside a docker container: `docker exec -ti fylr fylr backup ...`.

If you are using our docker-compose.yml: `--dir /srv/backup1` because /srv is already mapped to the outside. backup1 will be created.

`--server` ,`--login` and `--password` refer to the source server

`--purge` deletes the directory at `--dir …` in case there is already one. And re-creates it.

Beware: No assets are stored in the backup files, only URLs. All assets are pulled via URL from the backupped instance during restore. (So it needs the backupped instance still running).

## Restore into fylr

### restore via frontend
(easier to get into but not robust for long runs, we recommend [command line](#restore-via-command-line), see below)

Fill in the form fields of the paragraph `Restore backup [...] via API`. This time with URL and login of fylr.

  * This will delete the data in fylr. And the data model.

  * Make sure `OAuth2` is selected, it is mandatory for fylr.
    * OAuth2 credentials are configured in fylr.yml. To look them up in fylr config search something like ... :

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

### access a frontend backup via command line

Special case: If you want to access a backup made via frontend later via command line ...
* e.g. to restore via command line or 
* e.g. to continue an aborted restore via command line

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

* Also see below: restore via commandline

### restore via command line
(harder to learn but more robust and flexible)

Also see `fylr restore --help`.

Example:

```
fylr restore \
  --log backup1/restore.log \
  --server <fylr url>/api/v1 \
  --login root --password 'cleartext' \
  --manifest backup1/manifest.json \
  --client-id web-client --client-secret foo \
  --client-token-url <fylr url>/api/oauth2/token \
  --chunk 100 --limit 0 --timeout-min=1 \
  --file-api put --file-version preview \
  --include-password \
  --purge --continue # EITHER --purge OR --continue
```

* for the `--server` parameter, include the HTTP Basic Auth: `http://<login>:<password>@<fylr url>/api/v1`

* `--server` ,`--login` and `--password` refer to the target server

* `--client-id fylr-web-frontend` is correct for our cloud instances. Likewise…

* `--client-secret foo` is a fylr default dummy value.

* `--chunk` defines the batch size of objects in POST requests to api/v1/db

  if the objects are too big or complex, the requests might take too long and cause a timeout

  in this case, lower the `--chunk` value and continue restoring with `--continue`

* `--include-password` when restoring users their passwords (hashes) are restored.

    **Pitfall:** For security reasons, easydb5 will ignore the `include_password` url parameter for the user API, if it is not explicitly allowed in the `easydb-server.yml` or `easydb-server.d/*.yml`.

    Make sure to enable this in the source easydb5 instance before running the backup. See https://docs.easydb.de/en/technical/api/user/#returning-password-hashes

    After the backup is done, this feature should be disabled again in the source instance.

    Example of this in the `easydb-server.yml` or `easydb-server.d/*.yml` (do not confuse with fylr's fylr.yml)

```
server:
  api:
    user:
      # default: false
      include_password: true
```

* `--purge` deletes the datamodel and all data on the target system!

* use `--purge` on your first run and if that aborts, `--continue` instead(!).

Valid strings for `--file-api="STRING"` :

* `put`: the fylr you called via command line does the uploads, waits

* `rput`: server uploads, backgrounded

* `rput_leave`: server uses the remote URL and never copies the data to local S3 storage

* `""` Leave empty to not upload files

For the final migration including assets, use `--file-version=original`
