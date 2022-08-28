package com.biscuit.crm.workbench.service.impl;

import com.biscuit.crm.workbench.entity.Activity;
import com.biscuit.crm.workbench.mapper.ActivityMapper;
import com.biscuit.crm.workbench.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class ActivityServiceImpl implements ActivityService {

    @Autowired
    private ActivityMapper activityMapper;


    @Override
    public int saveCreateActivity(Activity activity) {
        return activityMapper.insertActivity(activity);
    }

    @Override
    public List<Activity> queryActivityByConditionForPage(Map<String, Object> map) {
        return activityMapper.selectActivityByConditionForPage(map);
    }

    @Override
    public int queryCountOfActivityByCondition(Map<String, Object> map) {
        return activityMapper.selectCountOfActivityByCondition(map);
    }

    @Override
    public int deleteActivityByIds(String[] ids) {
        return activityMapper.deleteActivityByIds(ids);
    }

    @Override
    public Activity queryActivityById(String id) {
        return activityMapper.selectActivityById(id);
    }

    @Override
    public int saveEditActivity(Activity activity) {
        return activityMapper.updateActivity(activity);
    }

    @Override
    public List<Activity> queryAllActivity() {
        return activityMapper.selectAllActivity();
    }

    @Override
    public List<Activity> queryActivityByIds(String[] ids) {
        return activityMapper.selectActivityByIds(ids);
    }

    @Override
    public int saveMoreActivityByList(List<Activity> activityList) {
        return activityMapper.insertMoreActivityByList(activityList);
    }

    @Override
    public Activity queryActivityByIdForDetail(String id) {
        return activityMapper.selectActivityByIdForDetail(id);
    }

    @Override
    public List<Activity> queryMoreActivityForClueDetailByClueId(String clueId) {
        return activityMapper.selectMoreActivityForDetailByClueId(clueId);
    }

    @Override
    public List<Activity> queryMoreActivityForClueDetailNotClueId(String clueId , String name) {
        return activityMapper.selectMoreActivityForClueDetailNotClueId(clueId , name);
    }

    @Override
    public List<Activity> queryClueBindActivityByClueIdAndLikeActivityName(String clueId, String activityName) {
        return activityMapper.selectClueBindActivityByClueIdAndLikeActivityName(clueId , activityName);
    }
}
