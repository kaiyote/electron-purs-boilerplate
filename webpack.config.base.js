import path from 'path'

export default {
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
          }
        }
      }]
    }, {
      test: /\.js$/,
      exclude: [/node_modules|bower_components|src/],
      use: ['source-map-loader', 'babel-loader']
    }]
  },
  output: {
    path: path.join(__dirname, 'dist'),
    filename: 'bundle.js',
    libraryTarget: 'commonjs2'
  },
  resolve: {
    extensions: ['.js', '.purs', '.styl'],
    modules: ['node_modules', 'bower_components']
  },
  plugins: [

  ],
  externals: [
    // put your node 3rd party libraries which can't be built with webpack here
    // (mysql, mongodb, and so on..)
  ]
}
