###### Disclaimer:
AI was used to take my original Dockerfile and apply best practices

# Description
The web-app version of SpoolLink running in a Docker container

# Big thanks to:
* [Paxx12](https://github.com/paxx12-snapmaker-u1)  - The original creator of SpoolLink and the Snapmaker U1 Extended Firmware

# Instructions:
`docker-compose.yml`:

```
services:
  spoollink:
    container_name: spoolink
    image: ghcr.io/royaltongue/spoollink-web-docker
    hostname: spoollink
    ports:
      - 8443:8443
    restart: unless-stopped
      
```