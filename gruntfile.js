module.exports = function(grunt) {
  grunt.initConfig({
    watch: {
      scripts: {
        files: [
          "app/**/*.ls"
        ],
        tasks: [
          "scripts"
        ]
      },
      styles: {
        files: [
          "app/styles/**/*.css"
        ],
        tasks: [
          "styles"
        ]
      }
    },
    concurrent: {
      options: {
        logConcurrentOutput: true
      },
      build: {
        tasks: [
          "scripts",
          "styles"
        ]
      },
      watch: {
        tasks: [
          "watch:scripts",
          "watch:styles"
        ]
      }
    },
    myth: {
      default: {
        options: {
          compress: true
        },
        files: {
          "public/dist/bundle.css": "app/styles/index.css"
        }
      }
    },
    browserify: {
      default: {
        files: {
          "public/dist/bundle.js": [
            "app/index.ls"
          ]
        },
        options: {
          transform: [
            "liveify"
          ]
        }
      }
    },
    uglify: {
      option: {
        mangle: true
      },
      default: {
        files: {
          "public/dist/bundle.js": "public/dist/bundle.js"
        }
      }
    }
  })

  require("load-grunt-tasks")(grunt)

  grunt.registerTask("styles", [
    "myth"
  ])

  grunt.registerTask("scripts", [
    "browserify",
    "uglify"
  ])

  grunt.registerTask("default", [
    "concurrent:build",
    "concurrent:watch"
  ])
}
