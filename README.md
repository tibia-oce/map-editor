# Map editor

This is a map editor for game servers that derivied from [OpenTibia](https://github.com/tibia-oce/server) server project.

It is a fork of a [Map Editor](https://github.com/hampusborgos/rme) created by [Remere](https://github.com/hampusborgos).

![rme](/docs/images/rme.png)

<br>

## Getting started

Download the latest release [here](https://github.com/tibia-oce/map-editor/releases/latest).

The assets used in the map editor are shared between a number of other services. They are tracked via [Git](https://git-scm.com/) to make collaboration and version tracking easier.

To get started contributing to the Mythbound world map and assets, you'll need to follow these [instructions](https://github.com/tibia-oce/assets?tab=readme-ov-file#prerequisites).

## Committing changes

If you follow the above [instructions](https://github.com/tibia-oce/assets?tab=readme-ov-file#prerequisites), you're changes were tracked against the published assets.

---

# Linux dependencies

```
sudo apt update
sudo apt install -y \
  ninja-build \
  pkg-config \
  python3 \
  python3-venv \
  python3-dev \
  libacl1-dev \
  libblkid-dev \
  libgcrypt20-dev \
  liblz4-dev \
  liblzma-dev \
  libzstd-dev \
  libsystemd-dev \
  libqrencode-dev \
  bison \
  python3-jinja2 \
  libglib2.0-dev \
  libdbus-1-dev \
  libatspi2.0-dev \
  libgirepository1.0-dev \
  python3-gi
pip3 install jinja2
```
