package com.biscuit.crm.workbench.web.controller;

import com.biscuit.crm.workbench.entity.DicValue;
import com.biscuit.crm.workbench.entity.Tran;
import com.biscuit.crm.workbench.service.DicTypeService;
import com.biscuit.crm.workbench.service.DicValueService;
import com.biscuit.crm.workbench.service.TransactionService;
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
        modelAndView.setViewName("workbench/transaction/save");
        return modelAndView;
    }

    @RequestMapping("/workbench/transaction/edit.do")
    public ModelAndView edit(ModelAndView modelAndView , String id){
        modelAndView.setViewName("workbench/transaction/edit");
        return modelAndView;
    }


}
