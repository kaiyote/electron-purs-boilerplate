import path from 'path'

export default {
  module: {
    loaders: [{
      test: /\.purs$/,
      loader: 'purs',
      query: {
        src: ['bower_components/purescript-*/src/**/*.purs', 'src/**/*.purs'],
        bundle: true,
        psc: 'psa',
        pscArgs: {sourceMaps: true}
      }
    }, {
      test: /\.js$/,
      exclude: [/node_modules|bower_components/],
      loaders: ['source-map', 'babel']
    }, {
      test: /\.json$/,
      loader: 'json'
    }]
  },
  output: {
    path: path.join(__dirname, 'dist'),
    filename: 'bundle.js',
    libraryTarget: 'commonjs2'
  },
  resolve: {
    extensions: ['', '.js', '.purs', '.styl'],
    packageMains: ['webpack', 'browser', 'web', 'browserify', ['jam', 'main'], 'main'],
    modulesDirectories: ['node_modules', 'bower_components']
  },
  plugins: [

  ],
  externals: [
    // put your node 3rd party libraries which can't be built with webpack here
    // (mysql, mongodb, and so on..)
  ]
}
