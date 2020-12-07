# Kubernetes

In the example below we assume that you already use the following services:

- s3
- elasticsearch
- postgres

**Other requirements:**

A fully configured and running kubernetes cluster at least in version `1.19.3-00` or newer with a working ingress controller ([nginx ingress controller](https://github.com/kubernetes/ingress-nginx)).

## Required changes

Changes that apply to all related entries:

```yml
apiVersion: *
kind: *
metadata:
  namespace: <fylr-namespace>
```

required ***fylr.yml*** configmap changes:

```yml
apiVersion: v1
kind: ConfigMap
metadata:
  name: fylr-configmap
  namespace: <fylr-namespace>
data:
  fylr.yml: |
    server:
      urlExternal: <fylr-external-url>
      name: <fylr-instance-name>
      db:
        driver: <fylr-database-driver>
        dsn: <fylr-dsn>
      elastic:
        addresses: <fylr-elasticsearch-address>
      s3:
        endpoint: <fylr-s3-storage-target-url>
        accessKeyID: <fylr-s3-access-key>
        secretAccessKey: <fylr-s3-secret-key>
        bucketLocation: <fylr-s3-bucket-location>
        ssl: <fylr-s3-use-ssl>
      ...
    ...
```
