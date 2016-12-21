import webpack from 'webpack'
import BabiliPlugin from 'babili-webpack-plugin'
import baseConfig from './webpack.config.base'

export default {
  ...baseConfig,

  devtool: 'source-map',

  entry: './main.development',

  output: {
    path: __dirname,
    filename: './main.js'
  },

  plugins: [
    new webpack.DefinePlugin({
      'process.env': {
        NODE_ENV: JSON.stringify('production')
      }
    }),
    new BabiliPlugin()
  ],

  target: 'electron-main',

  node: {
    __dirname: false,
    __filename: false
  },

  externals: [
    ...baseConfig.externals,
    'font-awesome'
  ]
}
