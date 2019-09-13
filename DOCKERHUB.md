# Docker container for Avidemux
[![Docker Automated build](https://img.shields.io/docker/automated/jlesage/avidemux.svg)](https://hub.docker.com/r/jlesage/avidemux/) [![Docker Image](https://images.microbadger.com/badges/image/jlesage/avidemux.svg)](http://microbadger.com/#/images/jlesage/avidemux) [![Build Status](https://travis-ci.org/jlesage/docker-avidemux.svg?branch=master)](https://travis-ci.org/jlesage/docker-avidemux) [![GitHub Release](https://img.shields.io/github/release/jlesage/docker-avidemux.svg)](https://github.com/jlesage/docker-avidemux/releases/latest) [![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://paypal.me/JocelynLeSage/0usd)

This is a Docker container for [Avidemux](http://avidemux.org/).

The GUI of the application is accessed through a modern web browser (no installation or configuration needed on client side) or via any VNC client.

---

[![Avidemux logo](https://images.weserv.nl/?url=raw.githubusercontent.com/jlesage/docker-templates/master/jlesage/images/avidemux-icon.png&w=200)](http://avidemux.org/)[![Avidemux](https://dummyimage.com/400x110/ffffff/575757&text=Avidemux)](http://avidemux.org/)

Avidemux is a free video editor designed for simple cutting, filtering and encoding tasks.  It supports many file types, including AVI, DVD compatible MPEG files, MP4 and ASF, using a variety of codecs.  Tasks can be automated using projects, job queue and powerful scripting capabilities.

---

## Quick Start

**NOTE**: The Docker command provided in this quick start is given as an example
and parameters should be adjusted to your need.

Launch the Avidemux docker container with the following command:
```
docker run -d \
    --name=avidemux \
    -p 5800:5800 \
    -v /docker/appdata/avidemux:/config:rw \
    -v $HOME:/storage:rw \
    jlesage/avidemux
```

Where:
  - `/docker/appdata/avidemux`: This is where the application stores its configuration, log and any files needing persistency.
  - `$HOME`: This location contains files from your host that need to be accessible by the application.

Browse to `http://your-host-ip:5800` to access the Avidemux GUI.
Files from the host appear under the `/storage` folder in the container.

## Documentation

Full documentation is available at https://github.com/jlesage/docker-avidemux.

## Support or Contact

Having troubles with the container or have questions?  Please
[create a new issue].

For other great Dockerized applications, see https://jlesage.github.io/docker-apps.

[create a new issue]: https://github.com/jlesage/docker-avidemux/issues
