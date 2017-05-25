'use strict'

import Webpack from 'webpack'
import { sync } from 'glob'
import { resolve } from 'path'

export default {
  devtool: 'cheap-module-source-map',
  output: {
    path: resolve('.'),
    filename: '[name]-dll.js',
    library: '[name]-[hash]-dll'
  },
  entry: {
    vendor: sync('bower_components/**/*.{js,purs}').map(p => resolve('.', p))
  },
  module: {
    rules: [{
      test: /\.purs$/,
      use: [{
        loader: 'purs-loader',
        options: {
          src: ['bower_components/purescript-*/src/**/*.purs'],
          bundle: false,
          psc: 'psa',
          pscIde: false,
          warnings: false
        }
      }]
    }]
  },
  resolve: {
    modules: ['node_modules', 'bower_components'],
    extensions: ['.purs', '.js']
  },
  plugins: [
    new Webpack.DllPlugin({
      path: '[name]-manifest.json',
      name: '[name]-[hash]_dll'
    })
  ]
}
