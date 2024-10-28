Mythbound Map Editor
=============

This is a map editor for game servers that derivied from [OpenTibia](https://github.com/tibia-oce/server) server project.

It is a fork of a [Map Editor](https://github.com/hampusborgos/rme) created by [Remere](https://github.com/hampusborgos).

![rme](/docs/images/rme.png)




## Usage

### Cloning the Repository

When cloning this repository, Git LFS will automatically download the large files:

```bash
git clone https://github.com/tibia-oce/map-editor.git
```

### Download the latest assets
The up to date assets are found in: https://github.com/tibia-oce/assets

Automate the updating process
```bash
make fetch
```



Compiling
=========
Required libraries:
* wxWidgets >= 3.0
* Boost >= 1.55.0

### VCPKG libraries:
* 32-bit : `vcpkg install wxwidgets freeglut asio nlohmann-json fmt libarchive boost-spirit`
* 64-bit : `vcpkg install --triplet x64-windows wxwidgets freeglut asio nlohmann-json fmt libarchive boost-spirit`

[Compile on Windows](https://github.com/hjnilsson/rme/wiki/Compiling-on-Windows)

[Compile on Ubuntu](https://github.com/hjnilsson/rme/wiki/Compiling-on-Ubuntu)

[Compile on Arch Linux](https://github.com/hjnilsson/rme/wiki/Compiling-on-Arch-Linux)

[Compile on macOS](https://github.com/hjnilsson/rme/wiki/Compiling-on-macOS)








