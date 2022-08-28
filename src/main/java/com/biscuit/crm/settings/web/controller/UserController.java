package com.biscuit.crm.settings.web.controller;

import com.biscuit.crm.commons.contants.Contants;
import com.biscuit.crm.commons.entity.ReturnObject;
import com.biscuit.crm.commons.utils.DateUtils;
import com.biscuit.crm.settings.entity.User;
import com.biscuit.crm.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Controller
public class UserController {

    @Autowired
    private UserService userService;

    /*
    *   url 要和当前的方法处理完请求之后，响应信息返回的页面资源目录保持一致
    */
    @RequestMapping("/settings/qx/user/toLogin.do")
    public String toLogin(){
        return "settings/qx/user/login";
    }

    /**
     * 验证登录
     * @param loginAct
     * @param loginPwd
     * @param isRemPwd
     * @param request
     * @param response
     * @param session
     * @return
     */
    @RequestMapping("/settings/qx/user/login.do")
    @ResponseBody
    public Object login(String loginAct , String loginPwd , String isRemPwd , HttpServletRequest request , HttpServletResponse response, HttpSession session){
        // 封装请求参数
        Map<String , Object> map = new HashMap<>();
        map.put("loginAct" , loginAct);
        map.put("loginPwd" , loginPwd);

        // 调用 service 层方法，进行登录验证
        User user = userService.queryUserBuLoginActAndPwd(map);
        // 根据查询结果生成响应信息
        ReturnObject returnObject = new ReturnObject();
        if (user == null) {
            // 登录失败，用户名或密码错误
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("账号或密码错误");
        } else {  // 登录成功，根据查询结果进行状态验证

            // 判断账号可用时间
            String nowStr = DateUtils.formateDateTime(new Date()); // 当前时间的字符串格式

            // 使用当前时间的字符串和数据库中该账户的有效期时间字符串进行对象
                // 前面大 返回值 大于 0 ，那么当前账号已过期
                // 后面大 返回值 小于 0 ，那么当前账号未过期
            if ( nowStr.compareTo(user.getExpireTime())  > 0 ){ // 验证当前账号是否已过期
                // 登录失败，账号已过期
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("账号已经过期");
            } else if ( user.getLockState().equals(Contants.RETURN_OBJECT_CODE_FAIL) ) { // 验证当前账号状态信息是否为锁定状态 数据库中 0 标识锁定  1 标识未锁定
                // 登录失败，账号已锁定
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("账号状态被锁定");
            } else if ( !user.getAllowIps().contains(request.getRemoteAddr()) ) { // 验证当前账号登录所使用的 ip 地址，是否为登录的 ip 地址
                /*
                    request.getRemoteAddr() 获取当前请求的 ip 地址
                    contains(String) 该方法为 String 的方法，用于查询当前字符串中是否包含另一个字符串
                */
                // 取反，字符串包含方法不包含则返回 true，表示登录失败，当前 IP 登录受限
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("登录IP受限");
            } else {
                // 登录成功
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                session.setAttribute(Contants.SESSION_USER , user);
                if( isRemPwd.equals("true") ){
                    // 是否进行十天内免登录，往外写 cookie
                    Cookie cookieAct = new Cookie("loginAct", user.getLoginAct());
                    Cookie cookiePwd = new Cookie("loginPwd", user.getLoginPwd());
                    // 设置有效期为 十天，即为设置 cookie 最大生命周期
                    cookieAct.setMaxAge(60 * 60 * 24 * 10);
                    cookiePwd.setMaxAge(60 * 60 * 24 * 10);

                    // 将 Cookie 写出
                    response.addCookie(cookieAct);
                    response.addCookie(cookiePwd);

                }else{
                    // 如果未选中免登录，则将已经存在的 Cookie 销毁
                    // Cooke 在用户本机中存储，不能通过后台进行删除，只能通过写相同 key 的 Cookie 进行覆盖
                    // 同时设置最大生命周期为 0 ，就是覆盖后直接销毁
                    Cookie cookieAct = new Cookie("loginAct","0");
                    Cookie cookiePwd = new Cookie("loginPwd","0");
                    cookieAct.setMaxAge(0);
                    cookiePwd.setMaxAge(0);
                    response.addCookie(cookieAct);
                    response.addCookie(cookiePwd);
                }
            }

        }

        return returnObject;
    }

    /**
     * 注销登录
     * @param request
     * @param response
     * @param session
     * @return
     */
    @RequestMapping("/settings/qx/user/logout.do")
    public String logout(HttpServletRequest request , HttpServletResponse response , HttpSession session){
        // 销毁 Session 对象
        session.invalidate();
        // 销毁可能记住密码的创建的 Cookie 对象
        Cookie cookieAct = new Cookie("loginAct", "0");
        Cookie cookiePwd = new Cookie("loginPwd", "0");
        cookieAct.setMaxAge(0);
        cookiePwd.setMaxAge(0);
        response.addCookie(cookieAct);
        response.addCookie(cookiePwd);
        ReturnObject returnObject = new ReturnObject();
        returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
        return "redirect:/";
    }


}
