# fylr in K8s

In the example below we assume that you already use the following services:

- s3
- elasticsearch
- postgres
- execserver

**Other requirements:**

A fully configured and running kubernetes cluster at least in version `1.19.3-00` or newer with a working ingress controller ([nginx ingress controller](https://github.com/kubernetes/ingress-nginx)).

## Introduction

Since managing Kubernetes resources is a very complex task, we decided to provide a simple and easy to use "Kustomization" file to manage all required resources to run *fylr* in a Kubernetes cluster.

## Getting started

Since *fylr* depends on third-party services, we first need to install all the required dependencies before we can start deploying *fylr* to a Kubernetes cluster. Once everything is installed, we can start modifying the configuration of the *fylr* deployment. Changes need to be made in the following files:

- `config/db.conf`
- `config/elastic.conf`
- `config/s3.conf`
- `config/execserver.conf`
- `config/fylr.yaml`
- `ingress.yaml`

Most of the settings in the *config/fylr.yaml* file are already optimized for the Kubernetes environment. However, some settings still need to be changed. For example, the `<external-url>` placeholder needs to be replaced with the actual external URL of the service.

The *Ingress* resource is used to expose the *fylr* service to the Internet. In the file *ingress.yaml* we refer to the *nginx* Ingress gateway and the *cert-manager* cluster issuer *letsencrypt-prod*. This can of course be changed to any other ingress controller and/or certificate issuer.

## Deploying

```bash
kubectl apply -k ./
```
