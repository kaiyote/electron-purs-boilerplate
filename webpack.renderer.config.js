'use strict'

import Webpack from 'webpack'
import BabiliPlugin from 'babili-webpack-plugin'
import ExtractTextPlugin from 'extract-text-webpack-plugin'
import { resolve } from 'path'

let devMode = process.env.NODE_ENV === 'development'

let config = {
  target: 'electron-renderer',
  devtool: 'cheap-module-source-map',
  output: {
    path: resolve('./dist'),
    filename: '[name].js',
    libraryTarget: 'commonjs2'
  },
  entry: {
    bundle: [resolve('./app/index')]
  },
  module: {
    rules: [{
      test: /\.purs$/,
      use: [{
        loader: 'purs-loader',
        options: {
          psc: 'psa',
          pscArgs: {
            sourceMaps: true,
            censorLib: true
          },
          bundle: !devMode
        }
      }]
    }, {
      test: /\.js$/,
      exclude: [/node_modules|bower_components|src/],
      use: ['source-map-loader', 'babel-loader']
    }]
  },
  resolve: {
    extensions: ['.js', '.purs', '.styl'],
    modules: ['node_modules', 'bower_components']
  },
  plugins: [
    new Webpack.DefinePlugin({
      __DEV__: devMode,
      'process.env': {
        NODE_ENV: JSON.stringify(devMode ? 'development' : 'production')
      }
    }),
    new Webpack.DllReferencePlugin({
      context: __dirname,
      manifest: require('./vendor-manifest.json')
    })
  ]
}

if (devMode) {
  config.entry.bundle.push('webpack-dev-server/client?http://localhost:8080', 'webpack/hot/only-dev-server')

  config.plugins.push(new Webpack.HotModuleReplacementPlugin(), new Webpack.NamedModulesPlugin(), new Webpack.NoEmitOnErrorsPlugin())

  config.devServer = {
    hot: true,
    contentBase: resolve('./dist'),
    publicPath: '/'
  }

  config.module.rules.push({
    test: /\.styl$/,
    exclude: /node_modules|bower_components/,
    use: ['style-loader', 'css-loader', 'stylus-loader']
  })
} else {
  config.plugins.push(
    new BabiliPlugin(),
    new ExtractTextPlugin({
      filename: 'bundle.css',
      allChunks: true
    })
  )

  config.module.rules.push({
    test: /\.styl$/,
    exclude: /node_modules|bower_components/,
    use: ExtractTextPlugin.extract({
      fallback: 'style-loader',
      use: ['css-loader', 'stylus-loader']
    })
  })

  config.externals = ['font-awesome']
}

export default config
