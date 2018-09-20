<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>七牛云 - JavaScript SDK</title>
    <link href="images/favicon.ico" rel="shortcut icon">
    <link rel="stylesheet" href="bootstrap3/css/bootstrap.min.css">
    <link rel="stylesheet" href="bootstrap3/css/bootstrap-theme.min.css">
    <link rel="stylesheet" href="styles/main.css">
    <link rel="stylesheet" href="styles/highlight.css">
</head>
<body>
    <div class="container" style="padding-top: 30px;">
        <ul class="nav nav-tabs" role="tablist">
            <li role="presentation" class="active">
                <a href="#demo" id="demo-tab" role="tab" data-toggle="tab" aria-controls="demo" aria-expanded="true">示例</a>
            </li>
            <li role="presentation">
                <a href="#log" id="log-tab" role="tab" data-toggle="tab" aria-controls="log">日志</a>
            </li>
        </ul>
        <div class="tab-content">
            <div role="tabpanel" class="tab-pane fade in active" id="demo" aria-labelledby="demo-tab">

                <div class="row" style="margin-top: 20px;">
                    <ul class="tip col-md-12 text-mute">
                        <li>
                            <small>
                                该 Demo 基于七牛 JavaScript SDK 1.x 版开发，依赖 Plupload，可以通过 Html5 或 Flash 等模式上传文件至七牛云存储。
                            </small>
                        </li>
                        <li>
                            <small>本示例限制最大上传文件100M。</small>
                        </li>
                    </ul>
                    <div class="panel-body form-group">
                        <label class="control-label">参数：</label>
                        <div>
                            <input id="params" type="text" class="form-control" style="width: 380px" placeholder="参数格式：xx=xx&xx=xx，如：uid=123&username=abc">
                        </div>
                        <label class="control-label" style="margin-top: 10px">回调地址( 可不填，默认为：http://106.14.113.42:8080/QiniuDemo/callback )：</label>
                        <div>
                            <input id="callbackUrl" type="text" class="form-control" style="width: 500px" placeholder="地址格式：http(s)://xxxxx，如：http://bf091726.ngrok.io/QiniuDemo/callback">
                        </div>
                    </div>
                    <div class="col-md-12">
                        <div id="container">
                            <a class="btn btn-default btn-lg" id="pickfiles" href="#" >
                                <i class="glyphicon glyphicon-plus"></i>
                                <span>选择文件</span>
                            </a>
                        </div>
                    </div>
                    <div style="display:none" id="success" class="col-md-12">
                        <div class="alert-success">
                            队列全部文件处理完毕
                        </div>
                    </div>
                    <div class="col-md-12 ">
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
                    <div class="col-md-12 ">
                        <table class="table table-striped table-hover text-left" style="margin-top:40px;display:none">
                            <thead>
                                <tr>
                                    <th class="col-md-4">Callback Response From Qiniu</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <th id="response-info"></th>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <div role="tabpanel" class="tab-pane fade" id="log" aria-labelledby="log-tab">
                <pre id="qiniu-js-sdk-log"></pre>
            </div>
        </div>
    </div>

    <script src="bootstrap3/js/jquery-1.11.1.min.js"></script>
    <script src="bootstrap3/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="scripts/main.js"></script>
    <script type="text/javascript" src="plupload/moxie.js"></script>
    <script type="text/javascript" src="plupload/plupload.dev.js"></script>
    <script type="text/javascript" src="qiniu/qiniu.min.js"></script>
    <script type="text/javascript" src="qiniu/ui.js"></script>
    <script type="text/javascript" src="qiniu/highlight.js"></script>
    <script type="text/javascript">hljs.initHighlightingOnLoad();</script>
</body>
</html>
