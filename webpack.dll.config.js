'use strict'

import Webpack from 'webpack'
import { sync } from 'glob'

export default {
  devtool: 'cheap-module-source-map',
  output: {
    path: '.',
    filename: '[name]-dll.js',
    library: '[name]-[hash]-dll'
  },
  entry: {
    vendor: sync('./bower_components/**/*.{js, purs}')
  }
}
