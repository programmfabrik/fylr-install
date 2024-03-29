# fylr installation methods

This is now newer at https://docs.fylr.io/for-system-administrators/installation

Thus, this repo will be removed at some point.

* [container server](https://docs.fylr.io/for-system-administrators/installation/linux-docker-compose): To set up fylr container on a server (With a container engine like docker, for Linux containers).

* [kubernetes](https://github.com/programmfabrik/fylr-helm): See our [helm chart](https://github.com/programmfabrik/fylr-helm).

* [fylr.exe](https://docs.fylr.io/for-system-administrators/installation/windows): To run fylr.exe on Windows.

## Contact us

For Issues and questions please write to support@programmfabrik.de

## Recommended hardware

4 cores and 16 GB RAM. For more than 100k assets, 32 GB RAM. (requirements depend heavily on data model and usage)


# Changelog

## 03.2023 v6.2.5

Missing utilities (like fylr_metadata, Image Magick, etc.) do not cause fylr startup to fail.

The utiltiy `fylr_copy` is not needed any more and shall be removed from configuration. So under this structure ...

```
fylr:
  services:
    execserver:
      services:
```

... the following part shall be removed:

```
        copy:
          waitgroup: a
          commands:
            fylr_copy:
              prog: "fylr_copy"
```

## 01.2023

To get preview images for video assets, in your fylr.yml add:

```
            ffmpegthumbnailer:
              prog: ffmpegthumbnailer
              startupCheck:
                args:
                - "-v"
                regex: "ffmpegthumbnailer version: 2\\..*"
```

  ... with context, see https://github.com/programmfabrik/fylr-install/commit/b802c949ffcd4653dcacdac930a47b71bf56f20b

## 12.2022

If you used fylr.exe with sqlite, then your old fylr.yml, ...

```
fylr:
  db:
    dsn: "C:data\\sqlite.db"
```

... now should be changed to a relative path without drive letter:

```
fylr:
  db:
    dsn: "data\\sqlite.db"
```

The zip file for windows does not contain a fylr_windows directory any more but fylr.exe (etc.) on the uppermost level.

## 10.2022

There has been a rename from clientSecret to secret in `fylr.yml` ...

```
fylr:
  services:
    api:
      oauth2Server:
        clients:
          EXAMPLECLIENT:
            secret:
```

## 9.2022

There has been a change in the `fylr.yml` ...

new:

```
           redirectURIs:
             - http://example
```

old:

```
           redirectURL: http://example
```

## 22.8.2022

fylr received a revision that removes backward compatibility. This is an important change and requires you to update your configuration concerning the execserver. Here are the updated example configurations:

* [desktop/execserver.yml](desktop/execserver.yml)
* [docker/config/execserver/fylr.yml](docker/config/execserver/fylr.yml)

```
fylr:
  services:
    execserver:
      services:
        pdf2pages:
          commands:
            fylr_pdf2pages:
              prog: "fylr_pdf2pages"
              # fylr_* utils use other programs to do their job. These
              # programs must be either found in the $PATH of the OS or
              # passed in by environment in the form of FYLR_CMD_<prog>
              # The <prog> is the program name (upper case)
              #
              # In case fylr_metadata is not in the PATH:
              env:
                - FYLR_CMD_FYLR_METADATA=../../utils/fylr_metadata/fylr_metadata
```

## 9.5.2022

On 09/05/2022, fylr received a revision that removes backward compatibility. This is an important change and requires you to update your configuration.

Migration guide:

This revision changes the way fylr works with files. The old way was to store files in a static location (s3). The new way is to support multiple locations. This allows you to store files in multiple locations, for example on a local hard drive or in cloud storage (currently we only support s3). With this change, we have also removed the feature to create s3 buckets. This task is now the responsibility of the user. In addition, we now finally support configuring the S3 bucket in fylr. In version v6.1.0-beta.5, we added the functionality to configure the location either through the configuration (on first startup as init config) or through the web frontend.

Old configuration:

```yaml
fylr:
  ...
  # DEPRECATED, will be removed in next version
  # files are stored in S3. Buckets are created by FYLR automatically
  s3:
    endpoint: ""
    accessKeyID: ""
    secretAccessKey: ""
    bucketLocation: ""
    ssl: false
    allowPurge: false
```

New configuration:

```yaml
fylr:
  # encryptionKey is used to AES-encrypt sensitive information before writing it
  # to the database. It must be 32 bytes long. Default is empty.
  #    openssl rand -hex 16
  encryptionKey: "41559d909bf92473c250c0195fc8346a"
  ...
  db:
    driver: postgres
    ...
    init:
      config:
        system:
          config:
            purge:
              allow_purge: true
              purge_storage: true
            location_defaults:
              originals: S3
              versions: S3
              backups: S3
      locations:
        S3:
          kind: s3
          prefix: ""
          allow_purge: true
          config:
            s3:
              # ENV: FYLR_DB_INIT_LOCATIONS_S3_CONFIG_S3_BUCKET
              bucket: fylr-assets
              # ENV: FYLR_DB_INIT_LOCATIONS_S3_CONFIG_S3_ENDPOINT
              endpoint: ""
              # ENV: FYLR_DB_INIT_LOCATIONS_S3_CONFIG_S3_ACCESSKEY
              accesskey: ""
              # ENV: FYLR_DB_INIT_LOCATIONS_S3_CONFIG_S3_SECRETKEY
              secretkey: ""
              # ENV: FYLR_DB_INIT_LOCATIONS_S3_CONFIG_S3_REGION
              region: ""
              # ENV: FYLR_DB_INIT_LOCATIONS_S3_CONFIG_S3_SSL
              ssl: false
```

**ATTENTION**: When you configure S3 credentials in the configuration, these credentials are stored encrypted in the database. To change the credentials for the S3 bucket, you must change the configuration through the web front end. This is because the credentials are written to the database once at first startup and cannot be changed after that.

For existing installations, you may need to change the configuration. Even if the configuration has been migrated, you should review and resave the configuration to store the credentials encrypted in the database.

![Location Manager](docs/storage_location_manager.png)

