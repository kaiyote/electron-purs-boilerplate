import webpack from 'webpack'
import baseConfig from './webpack.config.base'

const config = {
  ...baseConfig,

  debug: true,

  entry: [
    'webpack-hot-middleware/client?path=http://localhost:3000/__webpack_hmr',
    './app/index'
  ],

  output: {
    ...baseConfig.output,

    publicPath: 'http://localhost:3000/dist/'
  },

  module: {
    ...baseConfig.module,

    loaders: [
      ...baseConfig.module.loaders,

      {
        test: /\.styl$/,
        exclude: /node_modules|bower_components/,
        loaders: ['style', 'css', 'stylus']
      }
    ]
  },

  plugins: [
    ...baseConfig.plugins,

    new webpack.HotModuleReplacementPlugin(),

    new webpack.NoErrorsPlugin(),

    new webpack.DefinePlugin({
      __DEV__: true,
      'process.env': {
        NODE_ENV: JSON.stringify('development')
      }
    })
  ],

  target: 'electron-renderer'
}

export default config
