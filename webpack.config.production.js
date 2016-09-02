import webpack from 'webpack'
import ExtractTextPlugin from 'extract-text-webpack-plugin'
import baseConfig from './webpack.config.base'

const config = {
  ...baseConfig,

  devtool: 'source-map',

  entry: './app/index',

  output: {
    ...baseConfig.output,
    publicPath: '../dist/'
  },

  module: {
    ...baseConfig.module,

    loaders: [
      ...baseConfig.module.loaders,

      {
        test: /\.styl$/,
        exclude: /node_modules|bower_components/,
        loader: ExtractTextPlugin.extract('style', 'css!stylus')
      }
    ]
  },

  plugins: [
    ...baseConfig.plugins,

    new webpack.optimize.OccurenceOrderPlugin(),

    new webpack.DefinePlugin({
      __DEV__: false,
      'process.env': {
        NODE_ENV: JSON.stringify('production')
      }
    }),

    new webpack.optimize.UglifyJsPlugin({
      compressor: {
        screw_ie8: true,
        warnings: false
      }
    }),

    new ExtractTextPlugin('style.css', { allChunks: true })
  ],

  target: 'electron-renderer'
}

export default config
