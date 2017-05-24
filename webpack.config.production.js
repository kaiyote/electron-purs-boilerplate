import webpack from 'webpack'
import ExtractTextPlugin from 'extract-text-webpack-plugin'
import BabiliPlugin from 'babili-webpack-plugin'
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

    rules: [
      ...baseConfig.module.rules,

      {
        test: /\.styl$/,
        exclude: /node_modules|bower_components/,
        use: ExtractTextPlugin.extract({
          fallback: 'style-loader',
          use: ['css-loader', 'stylus-loader']
        })
      }
    ]
  },

  plugins: [
    ...baseConfig.plugins,

    new webpack.DefinePlugin({
      __DEV__: false,
      'process.env': {
        NODE_ENV: JSON.stringify('production')
      }
    }),
    new BabiliPlugin(),
    new ExtractTextPlugin({
      filename: 'bundle.css',
      allChunks: true
    })
  ],

  target: 'electron-renderer'
}

config.module.rules[0].use[0].options.bundle = true

export default config
