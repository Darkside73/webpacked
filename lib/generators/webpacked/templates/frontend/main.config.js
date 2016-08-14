const webpack = require('webpack')
const merge = require('webpack-merge')

const env = process.env.NODE_ENV || 'development'

module.exports = merge(
  require('./base.config.js'),
  require(`./${env}.config.js`)
)
