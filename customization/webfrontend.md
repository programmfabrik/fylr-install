# Webfrontend changes

To instruct fylr to use a custom webfrontend which is located in e.g. `./fylr/webfrontend/`:

add to docker-compose.yml:

```yaml
  fylr-server:
    volumes:
      - "./fylr/webfrontend:/fylr/files/webfrontend"
```

