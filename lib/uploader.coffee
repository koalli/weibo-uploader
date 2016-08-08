{ nativeImage, BrowserWindow } = require('electron').remote

module.exports = class Uploader

    constructor: ( watermark ) ->
        @watermark = watermark

    upload: (buffer, ext, callback) ->

        openWeiboLoginPage = ( callback ) ->
            win = new BrowserWindow({width: 800, height: 600})
            onCloseCallback = ()=>
                win = null
                if typeof callback is 'function'
                    callback()
            win.on('closed', onCloseCallback )
            win.loadURL('http://weibo.com/?topnav=1&mod=logo')
            win.focus()
            win.setAlwaysOnTop(true)

        image = nativeImage.createFromBuffer( buffer );
        utils = require('./utils');
        dataUrl = image.toDataURL();

        uploadCallback = ( success, ret )->
            if success is true
                callback(null, {ret: true, url: ret});
                openWeiboLoginPage( null );
            else if ret is 1
                # 未登录
                onLoginCallback = ()->
                    utils.uploadWeiboImg( dataUrl, @watermark, uploadCallback )

                openWeiboLoginPage( onLoginCallback );
                callback( true )
            else if ret is 2
                alert("图片上传失败...");
                callback( true )

        utils.uploadWeiboImg( dataUrl, @watermark, uploadCallback )
