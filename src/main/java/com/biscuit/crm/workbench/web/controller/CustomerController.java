package com.biscuit.crm.workbench.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class CustomerController {

    @RequestMapping("/workbench/customer/index.do")
    public String index(){
        return "workbench/customer/index";
    }

}
