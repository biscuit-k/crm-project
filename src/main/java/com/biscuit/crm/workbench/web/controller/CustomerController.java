package com.biscuit.crm.workbench.web.controller;

import com.biscuit.crm.workbench.entity.Customer;
import com.biscuit.crm.workbench.service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import java.util.List;

@Controller
public class CustomerController {

    @Autowired
    private CustomerService customerService;

    @RequestMapping("/workbench/customer/index.do")
    public ModelAndView index(ModelAndView modelAndView){
        List<Customer> customerList = customerService.queryAllCustomer();
        modelAndView.addObject("customerList" , customerList);
        modelAndView.setViewName("workbench/customer/index");
        return modelAndView;
    }

}
