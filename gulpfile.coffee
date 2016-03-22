require 'coffee-react/register'
gulp = require 'gulp'
gulpif = require 'gulp-if'
rename = require 'gulp-rename'
uglify = require 'gulp-uglify'
concat = require 'gulp-concat'
minifyCSS = require 'gulp-minify-css'
fs = require 'fs'
del = require 'del'
webpack = require 'webpack-stream'

isProduction = (process.env.NODE_ENV == 'production');

webpackConfig = {
  output: {
    filename: 'bundle.js'
  },
  resolve: {
    modulesDirectories: ['node_modules', '/usr/local/lib/node_modules'],
    extensions: ['', '.js', '.cjsx', '.coffee'],
  },
  module: {
    loaders: [
      {
        test: /\.cjsx$/,
        exclude: /node_modules/,
        loaders: ['coffee', 'cjsx'],
      }
    ]
  },
  node: {
    fs: 'empty',
    net: 'empty',
    tls: 'empty'
  }
}

gulp.task 'clean-script', () ->
  del(['./assets/js'])


gulp.task 'script', ['clean-script'], () ->
   gulp.src('app/scripts/index.cjsx')
       .pipe(webpack(webpackConfig))
       .pipe(gulpif(isProduction, uglify()))
       .pipe(gulp.dest('assets/js'))

gulp.task 'compile', ['script']

gulp.task 'default', ['compile']
