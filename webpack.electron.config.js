'use strict'

import Webpack from 'webpack'
import BabiliPlugin from 'babili-webpack-plugin'
import { resolve } from 'path'

let config = {
  target: 'electron-main',
  devtool: 'source-map',
  output: {
    path: resolve('.'),
    filename: '[name].js',
    libraryTarget: 'commonjs2'
  },
  entry: {
    main: resolve('./main.development.js')
  },
  module: {
    rules: [{
      test: /\.js$/,
      exclude: [/node_modules|bower_components|src/],
      use: ['source-map-loader', 'babel-loader']
    }]
  },
  resolve: {
    extensions: ['.js'],
    modules: ['node_modules', 'bower_components']
  },
  plugins: [
    new BabiliPlugin(),
    new Webpack.DefinePlugin({
      // this config is only loaded for production build
      __DEV__: false,
      'process.env': {
        NODE_ENV: 'production'
      }
    })
  ],
  node: {
    __dirname: false,
    __filename: false
  }
}

export default config
