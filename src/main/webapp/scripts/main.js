/*global Qiniu */
/*global plupload */
/*global FileProgress */
/*global hljs */

$(function() {
  var uploader = Qiniu.uploader({
    disable_statistics_report: false,
    runtimes: 'html5,flash,html4',
    browse_button: 'pickfiles',
    container: 'container',
    drop_element: 'container',
    max_file_size: '100mb',
    flash_swf_url: '/plupload/Moxie.swf',
    dragdrop: true,
    chunk_size: '4mb',
    multi_selection: !(moxie.core.utils.Env.OS.toLowerCase() === "ios"),
    // uptoken_url: 'uploadToken',
    uptoken_func: function() {
        var resultJson = "";
        $.ajaxSettings.async = false;
        $.get("uploadToken",{params:$('#params').val(), callbackUrl:$('#callbackUrl').val()},
            function(result){
                resultJson = eval('('+result+')');
            }
        );

        var uploadToken = resultJson.uptoken;
        return uploadToken;
    //     var ajax = new XMLHttpRequest();
    //     ajax.open('GET', $('#uptoken_url').val(), false);
    //     ajax.setRequestHeader("If-Modified-Since", "0");
    //     ajax.send();
    //     if (ajax.status === 200) {
    //         var res = JSON.parse(ajax.responseText);
    //         console.log('custom uptoken_func:' + res.uptoken);
    //         return res.uptoken;
    //     } else {
    //         console.log('custom uptoken_func err');
    //         return '';
    //     }
    },
    get_new_uptoken: true,
    domain: 'http://nigel.qiniuts.com/',
    //downtoken_url: '/downtoken',
    // unique_names: true,
    // save_key: true,
    // x_vars: {
    //     'id': '1234',
    //     'time': function(up, file) {
    //         var time = (new Date()).getTime();
    //         // do something with 'time'
    //         return time;
    //     },
    // },
    auto_start: true,
    log_level: 5,
    init: {
      'BeforeChunkUpload': function(up, file) {
        console.log("before chunk upload:", file.name);
      },
      'FilesAdded': function(up, files) {
        $('table').show();
        $('#success').hide();
        plupload.each(files, function(file) {
          var progress = new FileProgress(file,
            'fsUploadProgress');
          progress.setStatus("等待...");
          progress.bindUploadCancel(up);
        });
      },
      'BeforeUpload': function(up, file) {
        console.log("this is a beforeupload function from init");
        var progress = new FileProgress(file, 'fsUploadProgress');
        var chunk_size = plupload.parseSize(this.getOption(
          'chunk_size'));
        if (up.runtime === 'html5' && chunk_size) {
          progress.setChunkProgess(chunk_size);
        }
      },
      'UploadProgress': function(up, file) {
        var progress = new FileProgress(file, 'fsUploadProgress');
        var chunk_size = plupload.parseSize(this.getOption(
          'chunk_size'));
        progress.setProgress(file.percent + "%", file.speed,
          chunk_size);
      },
      'UploadComplete': function() {
        $('#success').show();
      },
      'FileUploaded': function(up, file, info) {
        var progress = new FileProgress(file, 'fsUploadProgress');
        console.log("response:", info.response);
        $('#response-info').html(info.response);
        progress.setComplete(up, info.response);
      },
      'Error': function(up, err, errTip) {
          $('table').show();
          var progress = new FileProgress(err.file, 'fsUploadProgress');
          progress.setError();
          progress.setStatus(errTip);
        }
        // ,
        // 'Key': function(up, file) {
        //     var key = "";
        //     // do something with key
        //     return key
        // }
    }
  });
  //uploader.init();
  uploader.bind('BeforeUpload', function() {
    console.log("hello man, i am going to upload a file");
  });
  uploader.bind('FileUploaded', function() {
    console.log('hello man,a file is uploaded');
  });
  $('#container').on(
    'dragenter',
    function(e) {
      e.preventDefault();
      $('#container').addClass('draging');
      e.stopPropagation();
    }
  ).on('drop', function(e) {
    e.preventDefault();
    $('#container').removeClass('draging');
    e.stopPropagation();
  }).on('dragleave', function(e) {
    e.preventDefault();
    $('#container').removeClass('draging');
    e.stopPropagation();
  }).on('dragover', function(e) {
    e.preventDefault();
    $('#container').addClass('draging');
    e.stopPropagation();
  });

  $('body').on('click', 'table button.btn', function() {
    $(this).parents('tr').next().toggle();
  });

  var getRotate = function(url) {
    if (!url) {
      return 0;
    }
    var arr = url.split('/');
    for (var i = 0, len = arr.length; i < len; i++) {
      if (arr[i] === 'rotate') {
        return parseInt(arr[i + 1], 10);
      }
    }
    return 0;
  };
});