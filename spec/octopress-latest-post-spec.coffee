OctopressLatestPost = require '../lib/octopress-latest-post'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "OctopressLatestPost", ->
  activationPromise = null

  beforeEach ->
    atom.workspaceView = new WorkspaceView
    activationPromise = atom.packages.activatePackage('octopressLatestPost')

  describe "when the octopress-latest-post:toggle event is triggered", ->
    it "attaches and then detaches the view", ->
      expect(atom.workspaceView.find('.octopress-latest-post')).not.toExist()

      # This is an activation event, triggering it will cause the package to be
      # activated.
      atom.workspaceView.trigger 'octopress-latest-post:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        expect(atom.workspaceView.find('.octopress-latest-post')).toExist()
        atom.workspaceView.trigger 'octopress-latest-post:toggle'
        expect(atom.workspaceView.find('.octopress-latest-post')).not.toExist()
