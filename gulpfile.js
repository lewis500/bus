var browserify = require('browserify');
var gulp = require('gulp');
var source = require('vinyl-source-stream');
var gutil = require('gulp-util');
var notify = require('gulp-notify');
var watchify = require('watchify');

var errorHandler = function(e) {
  gutil.log(e);
  this.emit('end');
};


gulp.task('watch', function() {
  var bundler = watchify(browserify('./app/app.coffee', {
    debug: true,
    extensions: ['.coffee', '.js'],
    cache: {},
    packageCache: {},
    transform: ['coffeeify']
  }));

  function rebundle() {
    return bundler
      .bundle()
      .on('error', notify.onError('build error'))
      .on('error', errorHandler)
      .pipe(source('bundle.js'))
      .pipe(gulp.dest('./dist/'));
  }

  bundler.on('update', rebundle);

  return rebundle();
});

gulp.task('default', ['watch']);