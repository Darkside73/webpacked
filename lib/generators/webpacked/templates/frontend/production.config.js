const path = require('path')
const webpack = require('webpack')
const CleanPlugin = require('clean-webpack-plugin')
const ExtractTextPlugin = require("extract-text-webpack-plugin")
// const CompressionPlugin = require("compression-webpack-plugin")
const AssetsPlugin = require('assets-webpack-plugin')

module.exports = {
  output: {
    filename: './bundle-[name]-[chunkhash].js',
    chunkFilename: 'bundle-[name]-[chunkhash].js',
    publicPath: '/assets/webpack/'
  },
  module: {
    loaders: [
      {
        test: /\.css$/,
        loader: ExtractTextPlugin.extract("style-loader", "css?minimize")
      },
      // {
      //   test: /\.scss$/,
      //   loader: ExtractTextPlugin.extract(
      //     "style-loader", "css?minimize!resolve-url!sass?sourceMap"
      //   )
      // },
      { test: /\.(png|jpg|gif)$/, loader: 'url?limit=8192' },
      {
        test: /\.(ttf|eot|svg|woff(2)?)(\?.+)?$/,
        loader: 'file'
      },
    ]
  },
  plugins: [
    // Creates separate manifest for production
    new AssetsPlugin({
      prettyPrint: true, filename: 'webpack-assets-deploy.json'
    }),

    // Extacts CSS to stanalone file
    new ExtractTextPlugin("bundle-[name]-[chunkhash].css", {
      allChunks: true
    }),

    new CleanPlugin(
      path.join('public', 'assets', 'webpack'),
      { root: path.join(process.cwd()) }
    ),

    // Some webpack built-in optimizations
    // Fill free to switch off if don't need some of it
    new webpack.optimize.CommonsChunkPlugin('common', 'bundle-[name]-[hash].js'),
    new webpack.optimize.DedupePlugin(),
    new webpack.optimize.OccurenceOrderPlugin(),

    //Enables Javascript source code uglifying
    // new webpack.optimize.UglifyJsPlugin({
    //   mangle: true,
    //   compress: {
    //     warnings: false
    //   }
    // }),

    // Enables gzip compression for Javascript and CSS assets
    // (remember to uncomment corresponding `require` on top of this file)
    // new CompressionPlugin({ test: /\.js$|\.css$/ }),
  ]
}
