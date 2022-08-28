package com.biscuit.crm.commons.entity;

public class ReturnObject {
    private String code; // 处理是否成功的状态  0 是失败，1 是成功

    private String message; // 处理失败的回显信息

    private Object returnData; // 返回的其他数据

    public ReturnObject() {
    }

    public ReturnObject(String code, String message, Object returnData) {
        this.code = code;
        this.message = message;
        this.returnData = returnData;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Object getReturnData() {
        return returnData;
    }

    public void setReturnData(Object returnData) {
        this.returnData = returnData;
    }
}
