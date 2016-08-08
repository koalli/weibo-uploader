Uploader = require('./uploader');

{CompositeDisposable} = require 'atom'

module.exports =
  config:
    watermark:
      title: "Watermark"
      type: "string"
      description: "Add watermark to picture"
      default: ""

  activate: (state) ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace', 'weibo-uploader:toggle': => @toggle()

  deactivate: ->
    @subscriptions.dispose()

  # `instance`:
  # API for markdown-assistant.
  # should return an uploader instance which has upload API
  #
  # usage:
  #   instance().upload(imagebuffer, '.png', (err, retData)->)
  #   * retData.url should be the online url
  instance: ->
    watermark = atom.config.get("weibo-uploader.watermark")
    return new Uploader( watermark )
