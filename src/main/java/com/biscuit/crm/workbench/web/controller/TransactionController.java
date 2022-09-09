package com.biscuit.crm.workbench.web.controller;

import com.biscuit.crm.commons.contants.Contants;
import com.biscuit.crm.commons.entity.ReturnObject;
import com.biscuit.crm.commons.utils.DateUtils;
import com.biscuit.crm.commons.utils.UUIDUtils;
import com.biscuit.crm.settings.entity.User;
import com.biscuit.crm.settings.service.UserService;
import com.biscuit.crm.workbench.entity.*;
import com.biscuit.crm.workbench.service.*;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.print.DocFlavor;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.ResourceBundle;

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


    @Autowired
    private CustomerService customerService;
    
    @Autowired
    private TransactionRemarkService transactionRemarkService;



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

        Tran tran = transactionService.queryTransactionByIdForDetail(id);

        // 获取可行性
        ResourceBundle bundle = ResourceBundle.getBundle("possibility");
        String possibility = bundle.getString(tran.getStage());



        String typeCodeStage = dicTypeService.queryTypeCodeByName("阶段");
        List<DicValue> stageList = dicValueService.queryDicValueByTypeCode(typeCodeStage);
        modelAndView.addObject("stageList" ,stageList );

        modelAndView.addObject("tran" , tran);
        modelAndView.addObject("possibility" , possibility);
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




    // 保存一条交易信息
    @RequestMapping("/workbench/transaction/saveCreateTran.do")
    @ResponseBody
    public Object saveCreateTran(Tran tran , HttpSession session){
        ReturnObject returnObject = new ReturnObject();
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        tran.setCreateBy(user.getId());
        tran.setCreateTime(DateUtils.formateDateTime(new Date()));
        tran.setId(UUIDUtils.getUUID());
        try {
            int row = transactionService.saveCreateTran(tran);
            if(row > 0){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            }else{
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setCode(Contants.RETURN_OBJECT_ERROR_MESSAGE_CURRENCY);
            }
        } catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setCode(Contants.RETURN_OBJECT_ERROR_MESSAGE_CURRENCY);
        }
        return returnObject;
    }

    @RequestMapping("/workbench/transaction/getPossibilityByStage.do")
    @ResponseBody
    public Object getPossibilityByStage(String stageValue){
        // 解析可能性配置文件
        ResourceBundle bundle = ResourceBundle.getBundle("possibility");
        String possibility = bundle.getString(stageValue);
        return possibility;
    }

    @RequestMapping("/workbench/transaction/queryAllCustomerName.do")
    @ResponseBody
    public Object queryAllCustomerName(String customerName){

        List<String> customerNameList = customerService.queryAllCustomerName(customerName);


        return customerNameList;
    }


    // 查询当前交易的所有备注信息
    @RequestMapping("/workbench/transaction/queryTranRemarkByTranId.do")
    @ResponseBody
    public Object queryTranRemarkByTranId(String tranId){
        List<TranRemark> tranRemarkList = transactionRemarkService.queryTransactionRemarkByTranId(tranId);
        return tranRemarkList;
    }

    // 保存一条交易备注信息
    @RequestMapping("/workbench/transaction/saveCreateTransactionRemark.do")
    @ResponseBody
    public Object saveCreateTransactionRemark(String tranId , String noteContent , HttpSession session){
        ReturnObject returnObject = new ReturnObject();

        TranRemark tranRemark = new TranRemark();
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        tranRemark.setId(UUIDUtils.getUUID());
        tranRemark.setCreateBy(user.getId());
        tranRemark.setCreateTime(DateUtils.formateDateTime(new Date()));
        tranRemark.setEditFlag("0");
        tranRemark.setNoteContent(noteContent);
        tranRemark.setTranId(tranId);

        try {
            transactionRemarkService.saveCreateTransactionRemark(tranRemark);
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
        } catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage(Contants.RETURN_OBJECT_ERROR_MESSAGE_CURRENCY);
        }

        return returnObject;
    }



    @RequestMapping("/workbench/transaction/edit.do")
    public ModelAndView edit(ModelAndView modelAndView , String id){

        Tran tran = transactionService.queryTransactionById(id);
        modelAndView.addObject("tran" , tran);

        String typeCodeStage = dicTypeService.queryTypeCodeByName("阶段");
        List<DicValue> dicValueStage = dicValueService.queryDicValueByTypeCode(typeCodeStage);
        modelAndView.addObject("dicValueStage" ,dicValueStage );

        String typeCodeTransactionType = dicTypeService.queryTypeCodeByName("交易类型");
        List<DicValue> dicValueTransactionType = dicValueService.queryDicValueByTypeCode(typeCodeTransactionType);
        modelAndView.addObject("dicValueTransactionType" ,dicValueTransactionType );

        String typeCodeSource = dicTypeService.queryTypeCodeByName("来源");
        List<DicValue> dicValueSource = dicValueService.queryDicValueByTypeCode(typeCodeSource);
        modelAndView.addObject("dicValueSource" ,dicValueSource );

        List<User> userList = userService.queryAllUsers();
        modelAndView.addObject("userList" , userList);

        // 查询可行性
        ResourceBundle bundle = ResourceBundle.getBundle("possibility");
        for (DicValue dicValue : dicValueStage) {
            if(tran.getStage().equals(dicValue.getId())){
                String possibility = bundle.getString(dicValue.getValue());
                modelAndView.addObject("possibility" , possibility);
            }
        }

        // 查询当前市场活动信息
        Activity activity = activityService.queryActivityById(tran.getActivityId());
        // 查询当前联系人信息
        Contacts contacts = contactsService.queryContactsById(tran.getContactsId());
        // 查询客户信息
        Customer customer = customerService.queryCustomerById(tran.getCustomerId());

        modelAndView.addObject("contacts" , contacts);
        modelAndView.addObject("customer" , customer);
        modelAndView.addObject("activity" , activity);

        modelAndView.setViewName("workbench/transaction/edit");
        return modelAndView;
    }


    // 查询所有市场活动信息，但排除一个之定id的市场活动
    @RequestMapping("/workbench/transaction/queryActivityNotActivityId.do")
    @ResponseBody
    public Object queryActivityNotActivityId(String activityId){
        ReturnObject returnObject = new ReturnObject();
        List<Activity> activityList = activityService.queryAllActivity();
        for (Activity activity : activityList) {
            if(activity.getId().equals(activityId)){
                activityList.remove(activity);
                break;
            }
        }
        if(activityList != null && activityList.size() > 0){
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            returnObject.setReturnData(activityList);
        }else{
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage(Contants.RETURN_OBJECT_ERROR_MESSAGE_CURRENCY);
        }
        return returnObject;
    }

    // 查询所有联系人信息，但排除一个之定id的联系人信息
    @RequestMapping("/workbench/transaction/queryContactsNotContactsId.do")
    @ResponseBody
    public Object queryContactsNotContactsId(String contactsId){
        ReturnObject returnObject = new ReturnObject();
        List<Contacts> contactsList = contactsService.queryAllContacts();
        for (Contacts contacts : contactsList) {
            if(contacts.getId().equals(contactsId)){
                contactsList.remove(contacts);
                break;
            }
        }
        if(contactsList != null && contactsList.size() > 0){
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            returnObject.setReturnData(contactsList);
        }else{
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage(Contants.RETURN_OBJECT_ERROR_MESSAGE_CURRENCY);
        }
        return returnObject;
    }



}
