package com.biscuit.crm.commons.utils;

import java.util.UUID;

public class UUIDUtils {
    /**
     * 获取一个 UUID 的字符串
     * @return
     */
    public static String getUUID(){
        String UUIDStr = UUID.randomUUID().toString().replaceAll("-", "");
        return UUIDStr;
    }
}
