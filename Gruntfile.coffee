module.exports = (grunt) ->
    
    'use strict'
    grunt.initConfig
    # Deletes deployment and temp directories.
    # The temp directory is used during the build process.
    # The deployment directory contains the artifacts of the build.
    # These directories should be deleted before subsequent builds.
    # These directories are not committed to source control.
        clean:
            bower:
                src: [
                    './src/libs/vendors/'
                    './bower_components/'
                    './src/views/vendors/'
                    './test/vendors/'
                ]
            dev:
                src: [
                    './public/'
                    './.test/'
                    './.temp/'
                ]
            prod:
                src: [
                    './.test/'
                    './.temp/'
                ]

    # lint CoffeeScript
        coffeelint:
            scripts:
                src: './src/scripts/**/*.coffee'
                options: 
                    indentation: 
                        value: 1
                        level: 'error'
                    max_line_length:
                        level: 'ignore'
                    no_tabs:
                        level: 'ignore'

    # Compile CoffeeScript (.coffee) files to JavaScript (.js).
        coffee:
            scripts:
                files: [
                    cwd: './.temp/'
                    src: 'scripts/**/*.coffee'
                    dest: './.temp/'
                    expand: true
                    ext: '.js'
                ]
                options:
                    # Don't include a surrounding Immediately-Invoked Function Expression (IIFE) in the compiled output.
                    # For more information on IIFEs, please visit http://benalman.com/news/2010/11/immediately-invoked-function-expression/
                    bare: true

    # Compile LESS (.less) files to CSS (.css).
        less:
            styles:
                files:
                    './.temp/styles/styles.css': './.temp/styles/styles.less'
                #options:
                #  sourcemap: true

    # Compresses png files
        imagemin:
            img:
                files: [
                    cwd: './src/'
                    src: 'img/**/*.png'
                    dest: './.temp/'
                    expand: true
                ]
                options:
                    optimizationLevel: 7

    # Copies directories and files from one location to another.
    # Copies the contents of the temp directory, except views, to the dist directory.
    # In 'dev' individual files are used.
        copy: 
            dev:
                files: [
                    cwd: './.temp/'
                    src: '**'
                    dest: './public/'
                    expand: true
                ]

        # Copies img directory to temp.
            img:
                files: [
                    cwd: './src/'
                    src: 'images/**/*.png'
                    dest: './.temp/'
                    expand: true
                ]
        # Copies favicon to temp.
            misc:
                files: [
                    cwd: './src/'
                    src: ['favicon.ico', 'robots.txt']
                    dest: './.temp/'
                    expand: true
                ]
        # Copies csslib directory to temp.
            csslib:
                files: [
                    cwd: './src/'
                    src: 'styles/lib/**/*'
                    dest: './.temp/'
                    expand: true
                ]
        # Copies fonts directory to temp.
            fonts:
                files: [
                    cwd: './src/'
                    src: 'fonts/**/*'
                    dest: './.temp/'
                    expand: true
                ]
        # Copies styles directory with less to temp.
            styleSource:
                files: [
                    cwd: './src/'
                    src: 'styles/**/*.css'
                    dest: './.temp/'
                    expand: true
                ]
    
        # Copies js files to the temp directory
            scriptSource:
                files: [
                    cwd: './src/scripts'
                    src: '**/*.js'
                    dest: '.temp/scripts'
                    expand: true
                ,
                    cwd: './src/scripts'
                    src: '**/*.coffee'
                    dest: '.temp/scripts'
                    expand: true
                ,
                    cwd: './src/libs/'
                    src: '**/*.js'
                    dest: '.temp/scripts/libs'
                    expand: true
                ,
                    cwd: './src/libs/'
                    src: '**/*.coffee'
                    dest: '.temp/scripts/libs'
                    expand: true
                ]

        # Task is run when the watched index.template file is modified.
            index:
                files: [
                    cwd: './.temp/'
                    src: 'index.html'
                    dest: './public/'
                    expand: true
                ]
        # Task is run when a watched script is modified.
            scripts:
                files: [
                    cwd: './.temp/'
                    src: 'scripts/**'
                    dest: './public/'
                    expand: true
                ]
        # Task is run when a watched style is modified.
            styles:
                files: [
                    cwd: './.temp/'
                    src: 'styles/**'
                    dest: './public/'
                    expand: true
                ]
        # Task is run when a watched view is modified.
            views:
                files: [
                    cwd: './.temp/'
                    src: 'views/**'
                    dest: './public/'
                    expand: true
                ]

        jshint: 
            js:  ['./.temp/**/*.js']
      
    # compile templates
        template:
            directives: 
                src: './src/scripts/directives/templates/**/*.template',
                dest: './public/scripts/directives/templates/'
            dev:
                files:
                    './.temp/': './src/*.html'
            prod: 
                src: '<%= template.dev.src %>'
                dest: '<%= template.dev.dest %>'
                ext: '<%= template.dev.ext %>'
                environment: 'prod'

    # Minifiy index.html.
    # Extra white space and comments will be removed.
    # Content within <pre /> tags will be left unchanged.
    # IE conditional comments will be left unchanged.
    # As of this writing, the output is reduced by over 14%.
        minifyHtml:
            prod:
                files:
                    './.temp/index.min.html': './.temp/index.html'
                    './.temp/customviewport.min.html': './.temp/customviewport.html'
                    './.temp/listScroller.min.html': './.temp/listScroller.html'
                    './.temp/tableScroller.min.html': './.temp/tableScroller.html'
                    './.temp/updatableScroller.min.html': './.temp/updatableScroller.html'
                    './.temp/windowviewport.min.html': './.temp/windowviewport.html'

    # This file is then included in the output automatically.  AngularJS will use it instead of going to the file system for the views, saving requests.  Notice that the view content is actually minified.  :)
        ngTemplateCache:
            views:
                files:
                    './.temp/scripts/views.js': './.temp/views/**/*.html'
                options:
                    trim: './.temp/'

        watch: 
            coffee: 
                files: './src/scripts/**/*.coffee'
                tasks: [
                    'copy:scriptSource'
                    'coffee:scripts'
                    'copy:scripts'
                ]
            less: 
                files: './src/styles/**/*.less'
                tasks: [
                    'copy:styleSource'
                    'less:styles'
                    'copy:styles'
                ]
            css: 
                files: './src/styles/**/*.css'
                tasks: [
                    'copy:styleSource'
                    'copy:styles'
                ]
            template: 
                files: '<%= template.dev.src %>'
                tasks: [
                    'template:dev'
                    'copy:views'
                ]

    # Runs tests using karma
        karma:
            unit:
                options:
                    configFile: './karma.conf.js'

        connect:
            app:
                options: 
                    base: './public/'
                    middleware: require('./server/middleware.coffee')
                    port: 5000
                    keepalive: true    

    grunt.loadNpmTasks 'grunt-karma'
    grunt.loadNpmTasks 'grunt-hustler'
    grunt.loadNpmTasks 'grunt-coffeelint'
    grunt.loadNpmTasks 'grunt-contrib-clean'
    grunt.loadNpmTasks 'grunt-contrib-coffee'
    grunt.loadNpmTasks 'grunt-contrib-connect'
    grunt.loadNpmTasks 'grunt-contrib-copy'
    grunt.loadNpmTasks 'grunt-contrib-less'
    grunt.loadNpmTasks 'grunt-contrib-watch'
    grunt.loadNpmTasks 'grunt-contrib-jshint'

    grunt.registerTask 'test', [
        'karma:unit'
    ]
    grunt.registerTask 'server', [
        'default'
        'connect'
        'watch'
    ]
    grunt.registerTask 'core', [
        'clean' 
        #'coffeelint'
        'copy:scriptSource'
        'coffee:scripts'
        #'jshint'
        'copy:styleSource'
        'less:styles'
        'template:dev'
        'copy:img'
        'copy:misc'
        'copy:csslib'
        'copy:fonts'
        'copy:dev'
    ]
    grunt.registerTask 'default', [
        'core'
    ]
    grunt.registerTask 'dev', [
        'default'
        'watch'
    ]
    grunt.registerTask 'prod', [
        'core' 
        'template:directives'
        'ngTemplateCache'
        'template:prod'
    ]
