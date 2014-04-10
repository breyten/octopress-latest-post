fs = require 'fs'
Path = require 'path'

module.exports =
  activate: ->
    atom.workspaceView.command "octopress-latest-post:find", => @find()

  find: ->
    dir = atom.project.getRootDirectory()

    if @isOctopressDir(dir)
      latest_post_path = @getLatestPost(dir)
      if latest_post_path
        atom.workspace.open(latest_post_path)
      else
        alert "Uh oh! Could not find any posts in your source/_posts directory. Please add some and try again."
    else
      alert "Uh oh! This doesn't look like a Octopress project. Please open up the root of a Octopress app and try again."

  isOctopressDir: (dir) ->
    expected_rails_files = ['plugins', 'public', 'sass', 'source']
    entries = dir.getEntriesSync()
    matching_dirs = []

    entries.forEach (entry) ->
      if expected_rails_files.indexOf(entry.getBaseName()) > -1
        matching_dirs.push(entry)

    return expected_rails_files.length == matching_dirs.length

  getPostsDir: (dir) ->
    Path.join(dir.getPath(), 'source', '_posts')

  getLatestPost: (dir) ->
    posts_dir = @getPostsDir(dir)
    posts = fs.readdirSync(posts_dir).filter (elem) ->
      stat = fs.statSync(Path.join(posts_dir, elem))
      return stat.isFile()

    if posts.length
      Path.join(posts_dir, posts[posts.length-1])
