<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
    <head>
        <link rel="stylesheet" href="bootstrap3/css/bootstrap.min.css">
        <link rel="stylesheet" href="bootstrap3/css/bootstrap-theme.min.css">
        <script src="bootstrap3/js/jquery-1.11.1.min.js"></script>
        <script src="bootstrap3/js/bootstrap.min.js"></script>
        <script type="text/javascript" src="js/main.js"></script>
        <script type="text/javascript" src="plupload/moxie.js"></script>
        <script type="text/javascript" src="plupload/plupload.dev.js"></script>
        <script type="text/javascript" src="qiniu/qiniu.min.js"></script>
        <script type="text/javascript" src="qiniu/ui.js"></script>
        <script type="text/javascript" src="qiniu/highlight.js"></script>
        <script type="text/javascript">
            function loadFile(value){
                console.log(value)
                $("#filename").html("asdfkjhs");
            }
        </script>
    </head>

    <body>
        <div id="container" class="form-horizontal">
            <div class="panel-body form-group">
                <label class="col-sm-2 control-label">参数：</label>
                <div class="col-sm-10">
                    <input id="params" type="text" class="form-control" style="width: 380px" placeholder="参数格式：xx=xx&xx=xx，如：uid=123&username=abc">
                </div>
            </div>
            <div class="panel-body col-sm-offset-2">
                <div id="pickfiles" style="display:inline-block;position:relative;vertical-align:middle">
                    <button class="btn btn-success glyphicon glyphicon-plus" type="button">选择文件</button>
                    <input type="file" onchange="loadFile(this.value)" style="position:absolute;top:0;left: 0;font-size: 34px;height: 36px;width: 96px;opacity: 0">
                </div>
                <span id="filename" style="vertical-align: middle">未上传文件</span>
                <div id="up_load" style="display:inline-block;position:relative;vertical-align:middle">
                    <button class="btn btn-success fileinput-button" type="button">确认上传</button>
                </div>
                <div id="stop_load" style="display:inline-block;position:relative;vertical-align:middle">
                    <button class="btn btn-success fileinput-button" type="button">暂停上传</button>
                </div>
            </div>
            <div style="display:none" id="success" class="col-md-8">
                <div class="alert-success">
                    队列全部文件处理完毕
                </div>
            </div>
            <div class="col-md-8">
                <table class="table table-striped table-hover text-left" style="margin-top:40px;display:none">
                    <thead>
                    <tr>
                        <th class="col-md-4">Filename</th>
                        <th class="col-md-2">Size</th>
                        <th class="col-md-6">Detail</th>
                    </tr>
                    </thead>
                    <tbody id="fsUploadProgress">
                    </tbody>
                </table>
            </div>
        </div>
    </body>
</html>