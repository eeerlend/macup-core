# macup-core

The core of the [macup](https://github.com/eeerlend/macup-builder) framework. Holds all core functionality and is mandatory for all macup distributions

## Installation
Run the following command to add it to your repo

```bash
npm install eeerlend/macup-core
```

## Configuration

Add packages to be installed (without the macup- prefix) in the main config file (e.g. my.config):

```bash
macup-packages+=(
  core
  dotfiles-icloud
  homebrew
  ...
)
```
