package com.biscuit.crm.workbench.web.controller;

import com.biscuit.crm.commons.contants.Contants;
import com.biscuit.crm.commons.entity.ReturnObject;
import com.biscuit.crm.settings.entity.User;
import com.biscuit.crm.settings.service.UserService;
import com.biscuit.crm.workbench.entity.Activity;
import com.biscuit.crm.workbench.entity.Contacts;
import com.biscuit.crm.workbench.entity.DicValue;
import com.biscuit.crm.workbench.entity.Tran;
import com.biscuit.crm.workbench.service.*;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import java.util.List;

@Controller
public class TransactionController {

    @Autowired
    private DicTypeService dicTypeService;

    @Autowired
    private DicValueService dicValueService;

    @Autowired
    private TransactionService transactionService;

    @Autowired
    private UserService userService;

    @Autowired
    private ContactsService contactsService;

    @Autowired
    private ActivityService activityService;

    @RequestMapping("/workbench/transaction/index.do")
    public ModelAndView index(ModelAndView modelAndView){

        // 称呼字段对应的值
        String typeCodeCall = dicTypeService.queryTypeCodeByName("称呼");
        List<DicValue> dicValueCall = dicValueService.queryDicValueByTypeCode(typeCodeCall);
        modelAndView.addObject("dicValueCall" ,dicValueCall );

        // 线索来源字段对应的值
        String typeCodeSource = dicTypeService.queryTypeCodeByName("来源");
        List<DicValue> dicValueSource = dicValueService.queryDicValueByTypeCode(typeCodeSource);
        modelAndView.addObject("dicValueSource" ,dicValueSource );

        // 线索来源字段对应的值
        String typeCodeClueState = dicTypeService.queryTypeCodeByName("线索状态");
        List<DicValue> dicValueClueState = dicValueService.queryDicValueByTypeCode(typeCodeClueState);
        modelAndView.addObject("dicValueClueState" ,dicValueClueState );

        // 线索来源字段对应的值
        String typeCodeStage = dicTypeService.queryTypeCodeByName("阶段");
        List<DicValue> dicValueStage = dicValueService.queryDicValueByTypeCode(typeCodeStage);
        modelAndView.addObject("dicValueStage" ,dicValueStage );

        String typeCodeTransactionType = dicTypeService.queryTypeCodeByName("交易类型");
        List<DicValue> dicValueTransactionType = dicValueService.queryDicValueByTypeCode(typeCodeTransactionType);
        modelAndView.addObject("dicValueTransactionType" ,dicValueTransactionType );

        modelAndView.setViewName("workbench/transaction/index");
        return modelAndView;
    }


    @RequestMapping("/workbench/transaction/queryTransactionForPage.do")
    @ResponseBody
    public Object queryTransactionForPage(Integer pageNo , Integer pageSize){
        PageHelper.startPage(pageNo , pageSize);
        List<Tran> transactionList = transactionService.queryAllTransaction();
        PageInfo<Tran> pageInfo  = new PageInfo<>(transactionList);
        return pageInfo;
    }


    @RequestMapping("/workbench/transaction/detail.do")
    public ModelAndView detail(ModelAndView modelAndView , String id){
        modelAndView.setViewName("workbench/transaction/detail");
        return modelAndView;
    }


    @RequestMapping("/workbench/transaction/save.do")
    public ModelAndView save(ModelAndView modelAndView){

        List<User> ownerList = userService.queryAllUsers();
        modelAndView.addObject("ownerList" , ownerList);

        String typeCodeStage = dicTypeService.queryTypeCodeByName("阶段");
        List<DicValue> dicValueStage = dicValueService.queryDicValueByTypeCode(typeCodeStage);
        modelAndView.addObject("dicValueStage" ,dicValueStage );

        String typeCodeTransactionType = dicTypeService.queryTypeCodeByName("交易类型");
        List<DicValue> dicValueTransactionType = dicValueService.queryDicValueByTypeCode(typeCodeTransactionType);
        modelAndView.addObject("dicValueTransactionType" ,dicValueTransactionType );

        String typeCodeSource = dicTypeService.queryTypeCodeByName("来源");
        List<DicValue> dicValueSource = dicValueService.queryDicValueByTypeCode(typeCodeSource);
        modelAndView.addObject("dicValueSource" ,dicValueSource );

        modelAndView.setViewName("workbench/transaction/save");
        return modelAndView;
    }

    @RequestMapping("/workbench/transaction/queryContactsForTranSave.do")
    @ResponseBody
    public Object queryContactsForTranSave(){
        ReturnObject returnObject = new ReturnObject();
        List<Contacts> contactsList = contactsService.queryContactsForTranSave();
        if(contactsList != null && contactsList.size() > 0){
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            returnObject.setReturnData(contactsList);
        }else{
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage(Contants.RETURN_OBJECT_ERROR_MESSAGE_CURRENCY);
        }
        return returnObject;
    }


    @RequestMapping("/workbench/transaction/queryContactsForTranSaveLikeFullName.do")
    @ResponseBody
    public Object queryContactsForTranSaveLikeFullName(String fullName){

        List<Contacts> contactsList = contactsService.queryContactsForTranSaveLikeFullName(fullName);

        return contactsList;
    }

    @RequestMapping("/workbench/transaction/queryActivityForTranSave.do")
    @ResponseBody
    public Object queryActivityForTranSave(){
        ReturnObject returnObject = new ReturnObject();

        List<Activity> activityList = activityService.queryActivityForTranSave();
        if(activityList != null && activityList.size() > 0){
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            returnObject.setReturnData(activityList);
        }else{
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage(Contants.RETURN_OBJECT_ERROR_MESSAGE_CURRENCY);
        }

        return returnObject;
    }

    @RequestMapping("/workbench/transaction/queryActivityForTranSaveLikeName.do")
    @ResponseBody
    public Object queryActivityForTranSaveLikeName(String name){

        List<Activity> activityList = activityService.queryActivityForTranSaveLikeName(name);


        return activityList;
    }


    @RequestMapping("/workbench/transaction/edit.do")
    public ModelAndView edit(ModelAndView modelAndView , String id){
        modelAndView.setViewName("workbench/transaction/edit");
        return modelAndView;
    }



}
