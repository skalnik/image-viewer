module.exports = function(grunt) {
  grunt.initConfig({
    coffee: {
      compile: {
        files: {
          'dist/image-viewer.js': 'src/image-viewer.coffee'
        }
      }
    }
  });

  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.registerTask('default', ['coffee']);
};
