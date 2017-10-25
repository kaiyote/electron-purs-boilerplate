# electron-purs-boilerplate

> Live editing development on desktop app

[Electron](http://electron.atom.io/) application boilerplate based on [Purescript](http://www.purescript.org/) and [Webpack](http://webpack.github.io/docs/), for rapid, statically-typed application development.

## Install

Clone the repo via git:

```bash
git clone https://github.com/kaiyote/electron-purs-boilerplate.git your-project-name
```

Install bower
```bash
npm i -g bower
```

And then install dependencies.

```bash
$ cd your-project-name && yarn
```

This project is configured to require Node 7+. If you don't have that installed, you'll either need to modify the package.json or upgrade your node.


## Run

Run the entire development setup with this one simple command:

```bash
$ yarn dev
```
*Important Note: `yarn dev` seems to produce an E2BIG error on macOS. If this is the case for you, you can instead use `npm run dev`*

*Note: requires a node version >= 7 and an npm version >= 3.*


## DevTools

#### Toggle Chrome DevTools

- OS X: <kbd>Cmd</kbd> <kbd>Alt</kbd> <kbd>I</kbd> or <kbd>F12</kbd>
- Linux: <kbd>Ctrl</kbd> <kbd>Shift</kbd> <kbd>I</kbd> or <kbd>F12</kbd>
- Windows: <kbd>Ctrl</kbd> <kbd>Shift</kbd> <kbd>I</kbd> or <kbd>F12</kbd>

*See [electron-debug](https://github.com/sindresorhus/electron-debug) for more information.*

#### Devtron

Devtron is automatically configured by electron-debug.

*See [Devtron](http://electron.atom.io/devtron/) for more information.*

## Externals

If you use any 3rd party libraries which can't be built with webpack, you must list them in your `webpack.config.base.js`：

```javascript
externals: [
  // put your node 3rd party libraries which can't be built with webpack here (mysql, mongodb, and so on..)
]
```

You can find those lines in the file.


## Package

```bash
$ yarn package
```

To compress the resources into an asar:

```bash
$ yarn package -- -a
```

#### Options

- --name, -n: Application name (default: ElectronPurs)
- --version, -v: Electron version (default: package.json version)
- --asar, -a: [asar](https://github.com/atom/asar) support (default: false)
- --icon, -i: Application icon
- --all: pack for all platforms

Use `electron-packager` to pack your app with `--all` options for darwin (osx), linux and win32 (windows) platform. After build, you will find them in `release` folder. Otherwise, you will only find one for your os.

`test`, `release` folder and devDependencies in `package.json` will be ignored by default.

#### Default Ignore modules

We add some module's `peerDependencies` to ignore option as default for application size reduction.

- `babel-core` is required by `babel-loader` and its size is ~19 MB
- `node-libs-browser` is required by `webpack` and its size is ~3MB.

> **Note:** If you want to use any above modules in runtime, for example: `require('babel/register')`, you should move them from `devDependencies` to `dependencies`.

#### Building windows apps from non-windows platforms

Please checkout [Building windows apps from non-windows platforms](https://github.com/maxogden/electron-packager#building-windows-apps-from-non-windows-platforms).


## Maintainers

- [Tim Huddle](https://github.com/kaiyote)


## License
MIT © [Tim Huddle](https://github.com/kaiyote)
