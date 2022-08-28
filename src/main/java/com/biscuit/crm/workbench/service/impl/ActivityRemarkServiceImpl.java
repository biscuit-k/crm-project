package com.biscuit.crm.workbench.service.impl;

import com.biscuit.crm.workbench.entity.ActivityRemark;
import com.biscuit.crm.workbench.mapper.ActivityMapper;
import com.biscuit.crm.workbench.mapper.ActivityRemarkMapper;
import com.biscuit.crm.workbench.service.ActivityRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ActivityRemarkServiceImpl implements ActivityRemarkService {

    @Autowired
    private ActivityRemarkMapper activityRemarkMapper;

    @Override
    public List<ActivityRemark> queryActivityRemarkListByActivityId(String activityId) {
        return activityRemarkMapper.selectActivityRemarkListByActivityId(activityId);
    }

    @Override
    public int saveActivityRemark(ActivityRemark activityRemark) {
        return activityRemarkMapper.insertActivityRemark(activityRemark);
    }

    @Override
    public int saveEditActivityRemark(ActivityRemark activityRemark) {
        return activityRemarkMapper.updateActivityRemark(activityRemark);
    }

    @Override
    public int saveDeleteActivityRemarkById(String id) {
        return activityRemarkMapper.deleteActivityRemarkById(id);
    }
}
