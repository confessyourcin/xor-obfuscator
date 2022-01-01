const path = require('path');
const CopyWebpackPlugin = require('copy-webpack-plugin');

module.exports = {
  entry: './src/index.js',
  mode: 'production',
  output: {
    filename: 'bundle.js',
    path: path.resolve(__dirname, 'dist')
  },
  devServer: {
    host: '0.0.0.0',
    port: 80,
    compress:true,
    public:'obfuscate.filesecuring.com'
  },
  module: {
    rules: [
      {
        test: /\.lua$/i,
        use: 'raw-loader'
      }
    ]
  },
  plugins: [
    new CopyWebpackPlugin([
      {from: 'public', to: ''}
    ])
  ],
  devtool: 'source-map'
};
