# Webfrontend changes

## Requirements

We assume you installed fylr via ../docker/README.md
If you want to change the webfrontend, use this as a starting point:

To instruct fylr to use a custom webfrontend in e.g. the path `./fylr/webfrontend/`, add to docker-compose.yml:

```yaml
  fylr-server:
    container_name: fylr-server
    ...
    volumes:
      - "./fylr/webfrontend:/fylr/files/webfrontend"
```

