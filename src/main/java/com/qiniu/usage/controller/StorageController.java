/**
 * Project Name: com.qiniu.usage.controller
 * File Name: StorageController.java
 * Package Name: com.qiniu.usage.controller
 * Date Time: 03/03/2018  11:08 PM
 * Copyright (c) 2017, xxx  All Rights Reserved.
 */
package com.qiniu.usage.controller;

import com.alibaba.fastjson.JSON;
import com.qiniu.util.Auth;
import com.qiniu.util.StringMap;
import com.qiniu.util.StringUtils;
import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.PropertySource;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.Map;

/**
 * ClassName: StorageController
 * Description: TODO
 * Date Time: 03/03/2018  11:08 PM
 * @author Nigel Wu  wubinghengajw@outlook.com
 * @version V1.0
 * @since V1.0
 * @jdk 1.7
 * @see
 */
@Controller
@PropertySource(value = { "classpath:qiniuconfig.properties" })
public class StorageController {

    @Autowired
    private Environment environment;

    /**
     * 业务服务器获取 uptoken 方法
     * @param request
     * @return
     */
    @RequestMapping(value = "/uploadToken")
    @ResponseBody
    public String uploadTokenHandler(HttpServletRequest request) {

        String callbackParams = request.getParameter("params");
        String paramUrl = request.getParameter("callbackUrl");
        String callbackUrl = StringUtils.isNullOrEmpty(paramUrl)
                ? "http://106.14.113.42:8080/QiniuDemo/callback" : paramUrl;

        // callbackbody 为 url query string
        String callbackString = StringUtils.isNullOrEmpty(callbackParams) ? "" : "&" + callbackParams;
        String callbackBody = "key=$(fname)&filesize=$(fsize)&hash=$(etag)" + callbackString;
        StringMap putPolicy = new StringMap().put("callbackUrl", callbackUrl)
                .put("callbackBody", callbackBody);

        // callbackbody 为 json
        String callbackJson = StringUtils.isNullOrEmpty(callbackParams) ? "}" :
                ",\"" + callbackParams.replace("=", "\":\"")
                        .replace("&", "\",\"") + "\"}";
        callbackBody = "{\"key\":\"$(fname)\",\"filesize\":\"$(fsize)\",\"hash\":\"$(etag)\"" + callbackJson;
        putPolicy = new StringMap().put("callbackUrl", callbackUrl)
                                             .put("callbackBody", callbackBody)
                                             .put("callbackBodyType", "application/json");

        //设置好账号的ACCESS_KEY和SECRET_KEY
        String ACCESS_KEY = environment.getRequiredProperty("qiniu.access_key");
        String SECRET_KEY = environment.getRequiredProperty("qiniu.secret_key");
        //要上传的空间
        String bucketname = "ts-work";
        Auth auth = Auth.create(ACCESS_KEY, SECRET_KEY);
        String uptoken = auth.uploadToken(bucketname, null, 3600, putPolicy);

        Map<String, String> map = new HashMap<String, String>();
        map.put("uptoken", uptoken);

        return JSON.toJSONString(map);
    }

    /**
     * 业务服务器上传回调方法
     * @param request
     * @return
     */
    @RequestMapping(value = "/callback", method = RequestMethod.POST)
    @ResponseBody
    public String callbackHandler(HttpServletRequest request) {
        InputStream is = null;
        String callbackBody = "";

        try {
            is = request.getInputStream();
            callbackBody = IOUtils.toString(is, "utf-8");
        } catch (IOException e) {
            e.printStackTrace();
        }

        String contentType = request.getContentType();
        String authorization = request.getHeader("Authorization");
        String callbackUrl = request.getRequestURL().toString();

        String ACCESS_KEY = environment.getRequiredProperty("qiniu.access_key");
        String SECRET_KEY = environment.getRequiredProperty("qiniu.secret_key");
        Auth auth = Auth.create(ACCESS_KEY, SECRET_KEY);

        System.out.println(contentType);
        System.out.println(authorization);
        System.out.println(callbackUrl);
        System.out.println(callbackBody);

        // 验证回调请求是否属于七牛
        Boolean valid = auth.isValidCallback(authorization, callbackUrl, callbackBody.getBytes(), contentType);

        if (valid) {
            System.out.println("It is callback really from Qiniu!");
        }

        Map<String, String> map = new HashMap<String, String>();

        if ("application/x-www-form-urlencoded".equals(contentType)) {
            String[] callbackParams = callbackBody.split("&");

            for (String param : callbackParams) {
                map.put(param.split("=")[0],
                        param.split("=").length == 2 ?
                                param.split("=")[1] : "");
            }

            System.out.println("callbackBody:" + JSON.toJSONString(map));
            return JSON.toJSONString(map);
        }

        System.out.println("callbackBody:" + callbackBody);
        return callbackBody;

    }

    @RequestMapping(value = "/")
    public String indexHandler(HttpServletRequest request) {

        return "main";
    }
}
