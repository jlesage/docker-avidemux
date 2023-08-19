# Docker container for Avidemux
[![Release](https://img.shields.io/github/release/jlesage/docker-avidemux.svg?logo=github&style=for-the-badge)](https://github.com/jlesage/docker-avidemux/releases/latest)
[![Docker Image Size](https://img.shields.io/docker/image-size/jlesage/avidemux/latest?logo=docker&style=for-the-badge)](https://hub.docker.com/r/jlesage/avidemux/tags)
[![Docker Pulls](https://img.shields.io/docker/pulls/jlesage/avidemux?label=Pulls&logo=docker&style=for-the-badge)](https://hub.docker.com/r/jlesage/avidemux)
[![Docker Stars](https://img.shields.io/docker/stars/jlesage/avidemux?label=Stars&logo=docker&style=for-the-badge)](https://hub.docker.com/r/jlesage/avidemux)
[![Build Status](https://img.shields.io/github/actions/workflow/status/jlesage/docker-avidemux/build-image.yml?logo=github&branch=master&style=for-the-badge)](https://github.com/jlesage/docker-avidemux/actions/workflows/build-image.yml)
[![Source](https://img.shields.io/badge/Source-GitHub-blue?logo=github&style=for-the-badge)](https://github.com/jlesage/docker-avidemux)
[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg?style=for-the-badge)](https://paypal.me/JocelynLeSage)

This is a Docker container for [Avidemux](https://avidemux.org).

The GUI of the application is accessed through a modern web browser (no
installation or configuration needed on the client side) or via any VNC client.

---

[![Avidemux logo](https://images.weserv.nl/?url=raw.githubusercontent.com/jlesage/docker-templates/master/jlesage/images/avidemux-icon.png&w=110)](https://avidemux.org)[![Avidemux](https://images.placeholders.dev/?width=256&height=110&fontFamily=monospace&fontWeight=400&fontSize=52&text=Avidemux&bgColor=rgba(0,0,0,0.0)&textColor=rgba(121,121,121,1))](https://avidemux.org)

Avidemux is a free video editor designed for simple cutting, filtering and encoding
tasks.  It supports many file types, including AVI, DVD compatible MPEG files, MP4
and ASF, using a variety of codecs.  Tasks can be automated using projects, job
queue and powerful scripting capabilities.

---

## Quick Start

**NOTE**:
    The Docker command provided in this quick start is given as an example
    and parameters should be adjusted to your need.

Launch the Avidemux docker container with the following command:
```shell
docker run -d \
    --name=avidemux \
    -p 5800:5800 \
    -v /docker/appdata/avidemux:/config:rw \
    -v /home/user:/storage:rw \
    jlesage/avidemux
```

Where:

  - `/docker/appdata/avidemux`: This is where the application stores its configuration, states, log and any files needing persistency.
  - `/home/user`: This location contains files from your host that need to be accessible to the application.

Browse to `http://your-host-ip:5800` to access the Avidemux GUI.
Files from the host appear under the `/storage` folder in the container.

## Documentation

Full documentation is available at https://github.com/jlesage/docker-avidemux.

## Support or Contact

Having troubles with the container or have questions?  Please
[create a new issue].

For other great Dockerized applications, see https://jlesage.github.io/docker-apps.

[create a new issue]: https://github.com/jlesage/docker-avidemux/issues
