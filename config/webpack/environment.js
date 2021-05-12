const { environment } = require('@rails/webpacker')
const erb = require('./loaders/erb')

const webpack = require('webpack');

environment.plugins.append('Provide', new webpack.ProvidePlugin({
  $: 'jquery',
  jQuery: 'jquery',
  CodeMirror: 'codemirror'
 }));

 const config = environment.toWebpackConfig();

 config.resolve.alias = {
  jquery: 'jquery/src/jquery',
  'jquery-ui': 'jquery-ui-dist/jquery-ui.js',
  codemirror: 'codemirror'
 };

environment.loaders.prepend('erb', erb)
module.exports = environment
