'use strict'

const os = require('os')
const webpack = require('webpack')
const electronCfg = require('../webpack.config.electron.js')
const cfg = require('../webpack.config.production.js')
const packager = require('electron-packager')
const del = require('del')
const exec = require('child_process').exec
const argv = require('minimist')(process.argv.slice(2))
const pkg = require('../package.json')
const deps = Object.keys(pkg.dependencies)
const devDeps = Object.keys(pkg.devDependencies)
const externals = Object.keys(electronCfg.externals)
const externalDevDeps = externals.map(external => {
  let extPkg = require(`../node_modules/${external}/package.json`)
  return Object.keys(extPkg.devDependencies).map(devDep => `${external}/node_modules/${devDep}($|/)`)
})

const appName = argv.name || argv.n || pkg.productName
const shouldUseAsar = argv.asar || argv.a || false
const shouldBuildAll = argv.all || false

const DEFAULT_OPTS = {
  dir: './',
  name: appName,
  asar: shouldUseAsar,
  ignore: [
    '^/test(s)?($|/)',
    '^/.pulp-cache($|/)',
    '^/bower_components($|/)',
    '^/src($|/)',
    '^/test($|/)',
    '^/output($|/)',
    '^/release($|/)',
    '^/main.development.js',
    '^/.*.sublime-project$',
    '^/package.js$',
    '^/server.js$',
    '^/webpack..*.js$',
    '^/app/.*.(js)($|/)',
    '^/.(babelrc|editorconfig|gitattributes|gitignore)$'
  ].concat(devDeps.map(name => `/node_modules/${name}($|/)`))
  .concat(
    deps.filter(name => !externals.includes(name))
      .map(name => `/node_modules/${name}($|/)`)
  ).concat(...externalDevDeps)
}

const icon = argv.icon || argv.i || 'app/app'

if (icon) {
  DEFAULT_OPTS.icon = icon
}

const version = argv.version || argv.v

if (version) {
  DEFAULT_OPTS.version = version
  startPack()
} else {
  // use the same version as the currently-installed electron-prebuilt
  exec('npm list electron-prebuilt --dev', (err, stdout) => {
    if (err) {
      DEFAULT_OPTS.version = '1.3.5'
    } else {
      DEFAULT_OPTS.version = stdout.split('electron-prebuilt@')[1].replace(/\s/g, '')
    }

    startPack()
  })
}

function build (cfg) {
  return new Promise((resolve, reject) => {
    webpack(cfg, (err, stats) => {
      if (err) return reject(err)
      resolve(stats)
    })
  })
}

function startPack () {
  console.log('start pack...')
  build(electronCfg)
    .then(() => build(cfg))
    .then(() => del('release'))
    .then(paths => {
      if (shouldBuildAll) {
        // build for all platforms
        const archs = ['ia32', 'x64']
        const platforms = ['linux', 'win32', 'darwin']

        platforms.forEach(plat => {
          archs.forEach(arch => {
            pack(plat, arch, log(plat, arch))
          })
        })
      } else {
        // build for current platform only
        pack(os.platform(), os.arch(), log(os.platform(), os.arch()))
      }
    })
    .catch(err => {
      console.error(err)
    })
}

function pack (plat, arch, cb) {
  // there is no darwin ia32 electron
  if (plat === 'darwin' && arch === 'ia32') return

  const iconObj = {
    icon: DEFAULT_OPTS.icon + (() => {
      let extension = '.png'
      if (plat === 'darwin') {
        extension = '.icns'
      } else if (plat === 'win32') {
        extension = '.ico'
      }
      return extension
    })()
  }

  const opts = Object.assign({}, DEFAULT_OPTS, iconObj, {
    platform: plat,
    arch,
    prune: true,
    'app-version': pkg.version || DEFAULT_OPTS.version,
    out: `release/${plat}-${arch}`
  })

  packager(opts, cb)
}

function log (plat, arch) {
  return err => {
    if (err) return console.error(err)
    console.log(`${plat}-${arch} finished!`)
  }
}
