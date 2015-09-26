DogeView = require './doge-view'
{CompositeDisposable} = require 'atom'

module.exports = Doge =
  dogeView: null
  dogeDecoration: null
  subscriptions: null

  activate: (state) ->
    @dogeView = new DogeView(state.dogeViewState)
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'doge:wow me': => @wow_me()

    atom.workspace.observeTextEditors (editor) ->
      editor.observeCursors (cursor) ->
        cursor.onDidChangePosition (event) ->
          if event.cursor.isInsideWord({ wordRegex: "[dD]oge" })
            Doge.dogeDecoration = editor.decorateMarker(event.cursor.getMarker(), {type: 'overlay', class: 'my-line-class', item:Doge.dogeView})
          else
            Doge.dogeDecoration.destroy() if Doge.dogeDecoration

  deactivate: ->
    @dogeDecoration.destroy()
    @subscriptions.dispose()
    @dogeView.destroy()

  serialize: ->
    dogeViewState: @dogeView.serialize()

  wow_me: ->
    console.log 'wow'
