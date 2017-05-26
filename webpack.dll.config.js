'use strict'

import Webpack from 'webpack'
import BabiliPlugin from 'babili-webpack-plugin'
import { sync } from 'glob'
import { resolve } from 'path'

let config = {
  target: 'electron-renderer',
  devtool: 'cheap-module-source-map',
  output: {
    path: resolve('./dist'),
    filename: '[name].js',
    library: '[name][hash]'
  },
  entry: {
    vendor: sync('bower_components/purescript-*/src/**/*.{js,purs}').map(p => resolve('.', p))
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
    new BabiliPlugin(), // always minify, you shouldn't care about stepping through the code in this bundle anyway
    new Webpack.DllPlugin({
      path: '[name]-manifest.json',
      name: '[name][hash]'
    })
  ]
}

if (process.env.NODE_ENV === 'development') {
  config.entry.vendor.push('webpack-dev-server/client?http://localhost:8080', 'webpack/hot/only-dev-server')

  config.plugins.unshift(new Webpack.HotModuleReplacementPlugin(), new Webpack.NamedModulesPlugin())

  config.devServer = {
    hot: true,
    contentBase: resolve('./dist'),
    publicPath: '/'
  }
}

export default config
