package com.biscuit.crm.settings.service;

import com.biscuit.crm.settings.entity.User;

import java.util.List;
import java.util.Map;

public interface UserService {

    /**
     * 根账号密码查询一个用户信息
     * @param map
     * @return
     */
    User queryUserBuLoginActAndPwd(Map<String , Object> map);

    List<User> queryAllUsers();
}
