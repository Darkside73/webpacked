const webpack = require('webpack')
const WebpackDevServer = require('webpack-dev-server')
const config = require('./main.config')
const webpackDevHost = process.env.WEBPACK_DEV_HOST || 'localhost'
const webpackDevPort = process.env.WEBPACK_DEV_PORT || 3500

config.output.publicPath = `http://${webpackDevHost}:${webpackDevPort}/assets/`;
for (var entryName in config.entry) {
  config.entry[entryName].push(
    `webpack-dev-server/client?http://${webpackDevHost}:${webpackDevPort}`,
    'webpack/hot/only-dev-server'
  )
}

config.plugins.push(
  new webpack.optimize.OccurenceOrderPlugin(),
  new webpack.HotModuleReplacementPlugin(),
  new webpack.NoErrorsPlugin()
)

new WebpackDevServer(webpack(config), {
  publicPath: config.output.publicPath,
  hot: true,
  inline: true,
  historyApiFallback: true,
  quiet: false,
  noInfo: false,
  lazy: false,
  stats: {
    colors: true,
    hash: false,
    version: false,
    chunks: false,
    children: false,
  }
}).listen(webpackDevPort, webpackDevHost, function (err, result) {
  if (err) console.log(err)
  console.log(
    `=> 🔥  Webpack development server is running on port ${webpackDevPort}`
  )
})
