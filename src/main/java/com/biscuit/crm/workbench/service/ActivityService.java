package com.biscuit.crm.workbench.service;

import com.biscuit.crm.workbench.entity.Activity;

import java.util.List;
import java.util.Map;

public interface ActivityService {

    /**
     * 新增一条市场活动记录
     * @param activity
     * @return
     */
    public int saveCreateActivity(Activity activity);


    public List<Activity> queryActivityByConditionForPage(Map<String , Object> map);

    public int queryCountOfActivityByCondition(Map<String , Object> map);

    public int deleteActivityByIds(String[] ids);

    public Activity queryActivityById(String id);

    public int saveEditActivity(Activity activity);

    public List<Activity> queryAllActivity();

    public List<Activity> queryActivityByIds(String[] ids);

    public int saveMoreActivityByList(List<Activity> activityList);

    public Activity queryActivityByIdForDetail(String id);

    public List<Activity> queryMoreActivityForClueDetailByClueId(String clueId);

    public List<Activity> queryMoreActivityForClueDetailNotClueId(String clueId , String name);

    public List<Activity> queryClueBindActivityByClueIdAndLikeActivityName(String clueId, String activityName);

}
