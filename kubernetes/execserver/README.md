# execserver in K8s

## Getting started

Changes need to be made in the following files:

- `config/execserver.yaml`

Most of the settings in the *config/execserver.yaml* file are already optimized for the Kubernetes environment. However, it may be necessary to adapt some of the options to your environment.

## Deploying

```bash
kubectl apply -k ./
```
