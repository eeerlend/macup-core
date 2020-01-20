# macup-core

The core of the [macup](https://github.com/eeerlend/macup-builder) framework. Holds all core functionality and is mandatory for all macup distributions

## Installation
Run the following command to add it to your repo

```bash
npm install eeerlend/macup-core
```

## Configuration

macup modules are installed using NPM and then registered in the main config file (e.g. my.config)

```bash
macup-packages+=(
  macup-dotfiles-icloud
  ...
)
```
