package com.biscuit.crm.workbench.web.controller;

import com.biscuit.crm.commons.contants.Contants;
import com.biscuit.crm.commons.entity.ReturnObject;
import com.biscuit.crm.commons.utils.DateUtils;
import com.biscuit.crm.commons.utils.StringUtils;
import com.biscuit.crm.commons.utils.UUIDUtils;
import com.biscuit.crm.settings.entity.User;
import com.biscuit.crm.settings.service.UserService;
import com.biscuit.crm.workbench.entity.*;
import com.biscuit.crm.workbench.service.*;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Controller
public class ClueController {

    @Autowired
    private UserService userService;

    @Autowired
    private ClueService clueService;

    @Autowired
    private DicTypeService dicTypeService;

    @Autowired
    private DicValueService dicValueService;

    @Autowired
    private ClueRemarkService clueRemarkService;

    @Autowired
    private ActivityService activityService;

    @Autowired
    private ClueActivityRelationService carService;



    @RequestMapping("/workbench/clue/index.do")
    public String index(HttpServletRequest request){
        List<User> userList = userService.queryAllUsers();
        request.setAttribute("userReturn" , userList);

        // 称呼字段对应的值
        String typeCodeCall = dicTypeService.queryTypeCodeByName("称呼");
        List<DicValue> dicValueCall = dicValueService.queryDicValueByTypeCode(typeCodeCall);
        request.setAttribute("dicValueCall" ,dicValueCall );

        // 线索来源字段对应的值
        String typeCodeSource = dicTypeService.queryTypeCodeByName("来源");
        List<DicValue> dicValueSource = dicValueService.queryDicValueByTypeCode(typeCodeSource);
        request.setAttribute("dicValueSource" ,dicValueSource );

        // 线索来源字段对应的值
        String typeCodeClueState = dicTypeService.queryTypeCodeByName("线索状态");
        List<DicValue> dicValueClueState = dicValueService.queryDicValueByTypeCode(typeCodeClueState);
        request.setAttribute("dicValueClueState" ,dicValueClueState );

        return "workbench/clue/index";
    }

    @RequestMapping("/workbench/clue/detail.do")
    public String detail(HttpServletRequest request , String id){
        Clue clue = clueService.queryClueByIdFromDetail(id);
        request.setAttribute("clue" , clue);
        return "workbench/clue/detail";
    }

    // 分页查询线索表
    @ResponseBody
    @RequestMapping("/workbench/clue/queryClueCarryPage.do")
    public Object queryClueCarryPage(String pageNo , String totalSize){

        // 设置分页操作
        PageHelper.startPage(Integer.parseInt(pageNo) , Integer.parseInt(totalSize));
        // 查询 clue 线索表数据
        List<Clue> clueList = clueService.queryAllClue();
        // 获取分页查询后详细数据
        PageInfo<Clue> pageInfo = new PageInfo<>(clueList);

        ReturnObject returnObject = new ReturnObject();
        returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
        returnObject.setReturnData(pageInfo);

        return returnObject;
    }

    // 新增线索
    @ResponseBody
    @RequestMapping("/workbench/clue/saveCreateClue.do")
    public Object saveCreateClue(HttpSession session , Clue clue){
        ReturnObject returnObject = new ReturnObject();
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        // 完善全新增所需数据
        clue.setCreateBy(user.getId());
        clue.setCreateTime(DateUtils.formateDateTime(new Date()));
        clue.setId(UUIDUtils.getUUID());
        try {
            int row = clueService.saveCreateClue(clue);
            if(row > 0){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            }else{returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage(Contants.RETURN_OBJECT_ERROR_MESSAGE_CURRENCY);
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage(Contants.RETURN_OBJECT_ERROR_MESSAGE_CURRENCY);
        }
        return returnObject;
    }


    // 删除多条线索
    @ResponseBody
    @RequestMapping("/workbench/clue/saveDeleteClueById.do")
    public Object saveDeleteClueById(String[] id){
        ReturnObject returnObject = new ReturnObject();
        try {
            int row = clueService.saveDeleteClueById(id);
            if(row > 0){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            }else{returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage(Contants.RETURN_OBJECT_ERROR_MESSAGE_CURRENCY);
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage(Contants.RETURN_OBJECT_ERROR_MESSAGE_CURRENCY);
        }
        return returnObject;
    }

    // 实现修改功能，查询当前选中的线索详细信息，根据 id
    @ResponseBody
    @RequestMapping("/workbench/clue/queryClueByIdFromEdit.do")
    public Object queryClueByIdFromEdit(String id){
        ReturnObject returnObject = new ReturnObject();
        if (StringUtils.strNotNull(id)){
            Clue clue = clueService.queryClueByIdFromEdit(id);
            if(clue != null){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setReturnData(clue);
            }else{
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage(Contants.RETURN_OBJECT_ERROR_MESSAGE_CURRENCY);
            }
        } else{
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage(Contants.RETURN_OBJECT_ERROR_MESSAGE_CURRENCY);
        }
        return returnObject;
    }


    // 修改线索
    @ResponseBody
    @RequestMapping("/workbench/clue/saveUpdateClue.do")
    public Object saveUpdateClue(Clue clue , HttpSession session){
        ReturnObject returnObject = new ReturnObject();
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        // 完善所需要数据
        clue.setEditBy(user.getId());
        clue.setEditTime(DateUtils.formateDateTime(new Date()));
        try {
            int row = clueService.saveUpdateClue(clue);
            if(row > 0){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            }else{returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage(Contants.RETURN_OBJECT_ERROR_MESSAGE_CURRENCY);
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage(Contants.RETURN_OBJECT_ERROR_MESSAGE_CURRENCY);
        }
        return returnObject;
    }


    // 获取当前线索的备注
    @ResponseBody
    @RequestMapping("/workbench/clue/queryAllClueRemarkByClueId.do")
    public Object queryAllClueRemarkByClueId(String clueId){
        ReturnObject returnObject = new ReturnObject();

        returnObject.setReturnData(clueRemarkService.queryAllClueRemarkByClueId(clueId));

        return returnObject;
    }

    // 查询当前线索关联的市场活动信息
    @ResponseBody
    @RequestMapping("/workbench/clue/queryMoreActivityForClueDetailByClueId.do")
    public Object queryMoreActivityForClueDetailByClueId(String clueId){
        ReturnObject returnObject = new ReturnObject();


        List<Activity> activityList = activityService.queryMoreActivityForClueDetailByClueId(clueId);

        returnObject.setReturnData(activityList);

        return returnObject;
    }


    // 根据线索 id 查询，所有未与该线索管理的市场活动信息
    @ResponseBody
    @RequestMapping("/workbench/clue/queryMoreActivityForClueDetailNotActivityId.do")
    public Object queryMoreActivityForClueDetailNotActivityId(String clueId , String name){
        ReturnObject returnObject = new ReturnObject();
        List<Activity> yes = activityService.queryMoreActivityForClueDetailNotClueId(clueId , name);
        returnObject.setReturnData(yes);
        return returnObject;
    }

    // 为线索绑定一个或多个市场活动
    @ResponseBody
    @RequestMapping("/workbench/clue/saveCreateClueActivityRelation.do")
    public Object saveCreateClueActivityRelation(String clueId , String[] activityIds){
        ReturnObject returnObject = new ReturnObject();

        List<ClueActivityRelation> carList = new ArrayList<>();
        ClueActivityRelation car = null;
        for (String activityId : activityIds) {
            car = new ClueActivityRelation();
            car.setId(UUIDUtils.getUUID());
            car.setClueId(clueId);
            car.setActivityId(activityId);
            carList.add(car);
        }
        if(carList.size() > 0){
            try {
                int row = carService.saveCreateClueActivityRelation(carList);
                if( row > 0 ){
                    returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                }else {
                    returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                    returnObject.setCode(Contants.RETURN_OBJECT_ERROR_MESSAGE_CURRENCY);
                }
            } catch(Exception e){
                e.printStackTrace();
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setCode(Contants.RETURN_OBJECT_ERROR_MESSAGE_CURRENCY);
            }
        }else{
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setCode(Contants.RETURN_OBJECT_ERROR_MESSAGE_CURRENCY);
        }

        return returnObject;
    }


    // 解除一条市场活动与线索的关联
    @ResponseBody
    @RequestMapping("/workbench/clue/saveDeleteClueActivityRelationByActivityIdAndClueId.do")
    public Object saveDeleteClueActivityRelationByActivityIdAndClueId(String activityId, String clueId){
        ReturnObject returnObject = new ReturnObject();

        if(StringUtils.strNotNull(activityId) && StringUtils.strNotNull(clueId)){
            try {
                int row = carService.saveDeleteClueActivityRelationByActivityIdAndClueId(activityId , clueId);
                if( row > 0 ){
                    returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                }else {
                    returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                    returnObject.setCode(Contants.RETURN_OBJECT_ERROR_MESSAGE_CURRENCY);
                }
            } catch(Exception e){
                e.printStackTrace();
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setCode(Contants.RETURN_OBJECT_ERROR_MESSAGE_CURRENCY);
            }
        }else{
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setCode(Contants.RETURN_OBJECT_ERROR_MESSAGE_CURRENCY);
        }

        return returnObject;
    }

    // 删除一条线索备注
    @ResponseBody
    @RequestMapping("/workbench/clue/saveDeleteClueRemarkById.do")
    public Object saveDeleteClueRemarkById(String id){
        ReturnObject returnObject = new ReturnObject();

        if(StringUtils.strNotNull(id)){
            try {
                int row = clueRemarkService.saveDeleteClueRemarkById(id);
                if( row > 0 ){
                    returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                }else {
                    returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                    returnObject.setCode(Contants.RETURN_OBJECT_ERROR_MESSAGE_CURRENCY);
                }
            } catch(Exception e){
                e.printStackTrace();
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setCode(Contants.RETURN_OBJECT_ERROR_MESSAGE_CURRENCY);
            }
        }else{
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setCode(Contants.RETURN_OBJECT_ERROR_MESSAGE_CURRENCY);
        }

        return returnObject;
    }

    // 新增一条线索备注
    @ResponseBody
    @RequestMapping("/workbench/clue/saveCreateClueRemark.do")
    public Object saveCreateClueRemark(ClueRemark clueRemark , HttpSession session){
        ReturnObject returnObject = new ReturnObject();
        User user = (User) session.getAttribute(Contants.SESSION_USER);

            try {
                clueRemark.setCreateBy(user.getId());
                clueRemark.setId(UUIDUtils.getUUID());
                clueRemark.setCreateTime(DateUtils.formateDateTime(new Date()));
                clueRemark.setEditFlag("0");
                int row = clueRemarkService.saveCreateClueRemark(clueRemark);
                if( row > 0 ){
                    returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                }else {
                    returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                    returnObject.setCode(Contants.RETURN_OBJECT_ERROR_MESSAGE_CURRENCY);
                }
            } catch(Exception e){
                e.printStackTrace();
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setCode(Contants.RETURN_OBJECT_ERROR_MESSAGE_CURRENCY);
            }

        return returnObject;
    }


    // 线索转换为客户
    @RequestMapping("/workbench/clue/convert.do")
    public String convert(String id , Model model){

        // 根据 id 查询 convert 线索转换页码所需要的线索明细信息
        Clue clue = clueService.queryClueByIdFromDetail(id);

        // 向数据字典中查询当前页码下拉框所需数据
        String typeCode = dicTypeService.queryTypeCodeByName("阶段");
        List<DicValue> dicValues = dicValueService.queryDicValueByTypeCode(typeCode);

        model.addAttribute("clue" , clue);
        model.addAttribute("stageList" , dicValues);
        return "workbench/clue/convert";
    }


    // 查询当前先算已关联的市场活动信息，并且支持根据市场活动名称模糊查询
    @ResponseBody
    @RequestMapping("/workbench/clue/queryClueBindActivityByClueIdAndLikeActivityName.do")
    public Object queryClueBindActivityByClueIdAndLikeActivityName(String clueId , String activityName){
        ReturnObject returnObject = new ReturnObject();

        if(StringUtils.strNotNull(clueId)){
            List<Activity> activityList = activityService.queryClueBindActivityByClueIdAndLikeActivityName(clueId, activityName);
            if(activityList != null && activityList.size() > 0){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setReturnData(activityList);
            }else{
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                System.out.println("OK");
            }
        }else{
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
        }

        return returnObject;
    }


}
