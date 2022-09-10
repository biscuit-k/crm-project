package com.biscuit.crm.workbench.web.controller;

import com.biscuit.crm.workbench.entity.FunnelVO;
import com.biscuit.crm.workbench.service.TransactionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
public class ChartController {

    @Autowired
    private TransactionService transactionService;

    @RequestMapping("/workbench/chart/transaction/transactionIndex.do")
    public String transactionIndex(){
        return "workbench/chart/transaction/index";
    }


    @RequestMapping("/workbench/chart/transaction/queryCountOfTranGroupByStage.do")
    @ResponseBody
    public Object queryCountOfTranGroupByStage(){
        List<FunnelVO> funnelVOList = transactionService.queryCountOfTranGroupByStage();
        return funnelVOList;
    }


}
