/*global Qiniu */
/*global plupload */
/*global FileProgress */
/*global hljs */

$(function() {
    var uploader = Qiniu.uploader({
        runtimes: 'html5,flash,html4',
        browse_button: 'pickfiles',
        container: 'container',
        drop_element: 'container',
        max_file_size: '100mb',
        flash_swf_url: 'plupload/Moxie.swf',
        dragdrop: true,
        chunk_size: '4mb',
        // uptoken: 'asdkjhgsdjk',
        // uptoken_url: 'uploadToken',
        uptoken_func: function() {
            var resultJson = "";
            $.ajaxSettings.async = false;
            $.get("uploadToken",{params:$('#params').val(),b:'c',a:'b'},
                function(result){
                    resultJson = eval('('+result+')');
                }
            );

            console.log(resultJson)
            var uploadToken = resultJson.uptoken;
            return uploadToken;
        },
        get_new_uptoken: true,
        domain: 'http://www.baidu.com/', //实际为空间绑定的域名
        auto_start: false,
        init: {
            'FilesAdded': function (up, files) {
                $('table').show();
                $('#success').hide();
                plupload.each(files, function (file) {
                    var progress = new FileProgress(file, 'fsUploadProgress');
                    progress.setStatus("等待...");
                });
            },
            'BeforeUpload': function (up, file) {
                var progress = new FileProgress(file, 'fsUploadProgress');
                var chunk_size = plupload.parseSize(this.getOption('chunk_size'));
                if (up.runtime === 'html5' && chunk_size) {
                    progress.setChunkProgess(chunk_size);
                }
            },
            'UploadProgress': function (up, file) {
                var progress = new FileProgress(file, 'fsUploadProgress');
                var chunk_size = plupload.parseSize(this.getOption('chunk_size'));
                progress.setProgress(file.percent + "%", file.speed, chunk_size);
            },
            'UploadComplete': function () {
                $('#success').show();
            },
            'FileUploaded': function (up, file, info) {
                var progress = new FileProgress(file, 'fsUploadProgress');
                progress.setComplete(up, info);
            },
            'Error': function (up, err, errTip) {
                $('table').show();
                var progress = new FileProgress(err.file, 'fsUploadProgress');
                progress.setError();
                progress.setStatus(errTip);
            }
        }
    });

    uploader.init();
    uploader.bind('FileUploaded', function() {
        console.log('hello man,a file is uploaded');
    });
    $('#up_load').on('click', function() {
        uploader.start();
    });
    $('#stop_load').on('click', function() {
        uploader.stop();
    });
});