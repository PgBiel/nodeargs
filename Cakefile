fs = require "fs"
exec = require("child_process").exec

### config =

  # You can define the order of the files here.
  # Files located in directories you specify here, but not already in the files array, will be included too.
  # 
  # This example adds all ".coffee" files in "app" and it's subdirectories, except for "app/models/todo.coffee", because it already here.
  files:  ['lib-coffee/index.coffee', 'lib-coffee']

  _files: (dir) ->
    unless dir?
      while (config._files(file) for file in @files when fs.lstatSync(file).isDirectory()).length > 0 then
      file for file in @files when file.match(/\.coffee$/)
    else
      @files.remove(dir)
      @files.push(file) for file in fs.readdirSync(dir) when (file = "#{dir}/#{file}") and not @files.includes(file)
###
console.log "Testing"

task "sbuild", "Compile ze files.", ->
  # files = config._files().join(' ')
  mathing = exec("coffee -b -co lib/ lib-coffee/")
  mathing.stdout.on 'data', (data) ->
    process.stdout.write(data)
  mathing.stderr.on 'data', (data) ->
    process.stderr.write(data)
