package com.biscuit.crm.workbench.service;

import com.biscuit.crm.workbench.entity.ActivityRemark;

import java.util.List;

public interface ActivityRemarkService {

    public List<ActivityRemark> queryActivityRemarkListByActivityId(String activityId);

    public int saveActivityRemark(ActivityRemark activityRemark);

    public int saveEditActivityRemark(ActivityRemark activityRemark);

    public int saveDeleteActivityRemarkById(String id);

}
