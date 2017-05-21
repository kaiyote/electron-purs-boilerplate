import webpack from 'webpack'
import baseConfig from './webpack.config.base'

const config = {
  ...baseConfig,

  entry: [
    'webpack-hot-middleware/client?path=http://localhost:3000/__webpack_hmr&reload=true',
    './app/index'
  ],

  output: {
    ...baseConfig.output,

    publicPath: 'http://localhost:3000/dist/'
  },

  module: {
    ...baseConfig.module,

    rules: [
      ...baseConfig.module.rules,

      {
        test: /\.styl$/,
        exclude: /node_modules|bower_components/,
        use: ['style-loader', 'css-loader', 'stylus-loader']
      }
    ]
  },

  plugins: [
    ...baseConfig.plugins,

    new webpack.HotModuleReplacementPlugin(),

    new webpack.NoEmitOnErrorsPlugin(),

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
