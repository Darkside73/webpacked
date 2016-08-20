const path = require('path')
const webpack = require('webpack')

module.exports = {
  context: __dirname,
  output: {
    // where to generate webpack assets
    path: path.join(__dirname, '..', 'public', 'assets', 'webpack'),
    filename: 'bundle-[name].js'
  },
  entry: {
    application: ['./app/base-entry'],
  },
  resolve: {
    // Default extensions to require file without extension
    extensions: ['', '.js'],
    modulesDirectories: [ 'node_modules' ],
    alias: {
      // Handy shortcut: use absolute path `require(~lib/mylib)` from any place
      lib: path.join(__dirname, 'lib'),
    }
  },
  module: {
    // Loaders with identical settings for both
    // development and production environments
    loaders: [

      // Use ES6 syntax (highly recommended!)
      // (run `npm install babel-loader babel-core babel-preset-es2015 --save-dev`)
      // {
      //   test: /\.js$/,
      //   include: [ path.resolve(__dirname + 'frontend/app') ],
      //   loader: 'babel?presets[]=es2015'
      // },

      // Use Coffescript
      // { test: /\.coffee$/, loader: 'coffee-loader' },

      // Use Vue.js framework (run `npm install vue vue-loader --save-dev`)
      // { test: /\.vue$/, loader: 'vue' },

      // Makes `$` and `jQuery` available globally
      // { test: require.resolve('jquery'), loader: 'expose?$!expose?jQuery' }
    ],
  },
  plugins: [
    // new webpack.ProvidePlugin({
    //   $: 'jquery',
    //   jQuery: 'jquery',
    // }),

    // Use `__RAILS_ENV__` variable in your Javascript code
    // new webpack.DefinePlugin({
    //   __RAILS_ENV__: JSON.stringify(process.env.RAILS_ENV || 'production'),
    // })
  ]
}
