var browserify = require('browserify');
var gulp = require('gulp');
var source = require('vinyl-source-stream');
var coffee = require('gulp-coffee');
var gutil = require('gulp-util');
var notify = require('gulp-notify');
var coffeelint = require('gulp-coffeelint')


var errorHandler = function(e) {
  gutil.log(e);
  this.emit('end');
};

gulp.task('lint', function(){
  gulp.src('./coffee/**/*.coffee')
    .pipe(coffeelint('coffeelint.json'))
    .pipe(coffeelint.reporter())
});

gulp.task('build', function() {
  return browserify('./coffee/app.coffee', {
      debug: true,
      extensions: ['.coffee', '.js']
    })
    .transform('coffeeify')
    .bundle()
    .on('error', notify.onError('build error'))
    .on('error', errorHandler)
    //Pass desired output filename to vinyl-source-stream
    .pipe(source('bundle.js'))
    // Start piping stream to tasks!
    .pipe(gulp.dest('dist/'));
});

gulp.task('watch', function() {
  gulp.watch('coffee/*.coffee', ['build']);
});

gulp.task('default', ['build', 'watch']);

gulp.task('js', function() {
  return gulp.src('./coffee/*.coffee')
    .pipe(coffee({
      sourceMaps: true
    }))
    .pipe(gulp.dest('dest/'));
})
