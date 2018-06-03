# gitlab-runner

This is a Gitlab runner which registers before running and automaticly unregisters the runner after a stop signal has sent to the container.

## Custom TLS certificates
Custom CA certificates can be placed in `/usr/local/share/ca-certificates/ca.crt`. If this file is available, the CA certificates will be updated automatically.

## Git config
Git is configured to include the CA path `/etc/ssl/certs/ca-certificates.crt`.

## Environment Variables
The following environment variables are available to customize the runner registration:

| Variable | Required | Default | Type | Description |
| --- | --- | --- | --- | --- |
| TOKEN | yes |  | String | Runner token |
| URL | yes |  | Url | Gitlab Url |
| NAME | yes |  | String | Unique name of the runner  |
| TAG_LIST | no |  | String (comma seperated) | List of tags |
| LOCKED | no | false | Boolean |  |
| DOCKER_IMAGE | no | docker:latest | String | Default image for jobs |
| PRIVILEGED | no | false | Boolean | On true, job containers run privileged |
| SHARE_DOCKER_SOCKET | no | false | Boolean | On true, volume /var/run/docker.sock:/var/run/docker.sock is mounted. |
| TZ | no |  | Timezone String | Set custom timzone |
| SHARE_ZONEINFO | no | true | Boolean | On true and if `TZ` is set, volume /usr/share/zoneinfo:/usr/share/zoneinfo:ro is mounted |
| ADDITIONAL_OPTIONS | no |  | String | Any available options can be inserted here. To see the list of all available options run `docker run --rm --entrypoint "/usr/bin/gitlab-runner" smueller18/gitlab-runner register --help` |

Here is an example how the variable `ADDITIONAL_OPTIONS` can be used:
```bash
docker run -e ADDITIONAL_OPTIONS="--env TEST=test" smueller18/gitlab-runner
```

## Running

When starting the image, the Gitlab runner is registerd with the given options. After the runner has registered sucessfully, the Gitlab runner run command is executed.
When a stop signal is sent to the container, the Gitlab runner stops and the runner will be unregistered so that it gets removed from Gitlab immediately.

Attention: If a Gitlab runner is not stopped regularly (e.g. force kill), the runner is not unregistered. Therefore, the runner will always be listed in the runners list and must be removed from hand.

Here is an example of a docker-compose file:

```yaml
version: '2.3'

services:
  runner:
    image: smueller18/gitlab-runner
    restart: always
    environment:
      URL: ${URL}
      TOKEN: ${TOKEN}
      NAME: unique-runner-name
      PRIVILEGED: "true"
      TZ: Europe/Berlin
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - /usr/share/zoneinfo:/usr/share/zoneinfo:ro
```
