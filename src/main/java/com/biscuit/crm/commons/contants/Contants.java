package com.biscuit.crm.commons.contants;

public class Contants {

    // 保存 ReturnObject 类中的 Code 值
    /**
     * 请求成功
     */
    public static final String RETURN_OBJECT_CODE_SUCCESS = "1"; // 成功
    /**
     * 请求失败
     */
    public static final String RETURN_OBJECT_CODE_FAIL = "0"; // 失败
    /**
     * 登录成功后，Session 作用域中存储的 User 对象的 key 值
     */
    public static final String SESSION_USER = "sessionUser";

    /**
     * 请求失败后的通用回显错误信息
     */
    public static final String RETURN_OBJECT_ERROR_MESSAGE_CURRENCY = "系统正忙，请稍后重试...";
}
