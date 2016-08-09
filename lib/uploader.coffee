{ nativeImage, BrowserWindow, dialog } = require('electron').remote

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

            onTitleUpdate = (event)=>
                title = win.getTitle()
                if title.indexOf('我的首页') isnt -1
                    # 登录成功，关闭窗口
                    win.close()

            win.on('closed', onCloseCallback )
            win.on('page-title-updated', onTitleUpdate )
            win.loadURL('http://weibo.com/?topnav=1&mod=logo')
            win.focus()
            win.setAlwaysOnTop(true)
            win.setMenuBarVisibility(false)

        image = nativeImage.createFromBuffer( buffer );
        utils = require('./utils');
        dataUrl = image.toDataURL();

        uploadCallback = ( success, ret )->
            if success is true
                callback(null, {ret: true, url: ret});
                # openWeiboLoginPage( null );
            else if ret is 1
                # 未登录
                onLoginCallback = ()=>
                    utils.uploadWeiboImg( dataUrl, @watermark, uploadCallback )

                onDialogCallback = (retCode)=>
                    if retCode is 0
                        openWeiboLoginPage( onLoginCallback );

                title = "上传失败"
                msg = "上传失败，请先登录微博，点击确定登录。"
                options = { type:"error", title: title, buttons: ["Yes", "Cancel"], defaultId: 0, message: msg , cancelId: 1 }
                dialog.showMessageBox( options, onDialogCallback )
                callback( true )
            else if ret is 2
                alert("图片上传失败...");
                callback( true )

        utils.uploadWeiboImg( dataUrl, @watermark, uploadCallback )
