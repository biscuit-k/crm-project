package com.biscuit.crm.settings.service.impl;

import com.biscuit.crm.settings.entity.User;
import com.biscuit.crm.settings.mapper.UserMapper;
import com.biscuit.crm.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service("UserService")
public class UserServiceImpl implements UserService {

    @Autowired
    private UserMapper userMapper;

    @Override
    public User queryUserBuLoginActAndPwd(Map<String, Object> map) {
        User user = userMapper.selectUserByLoginActAndPwd(map);
        return user;
    }

    @Override
    public List<User> queryAllUsers() {
        List<User> userList = userMapper.selectAllUsers();
        return userList;
    }
}
