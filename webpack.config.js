'use strict'

import renderer from './webpack.renderer.config'
import electron from './webpack.electron.config'

let devMode = process.env.NODE_ENV === 'development'

if (devMode) module.exports = renderer
else module.exports = [renderer, electron]
