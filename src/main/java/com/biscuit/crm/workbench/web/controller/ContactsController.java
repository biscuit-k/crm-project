package com.biscuit.crm.workbench.web.controller;

import com.biscuit.crm.workbench.entity.Contacts;
import com.biscuit.crm.workbench.service.ContactsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import java.util.List;

@Controller
public class ContactsController {


    @Autowired
    private ContactsService contactsService;

    @RequestMapping("/workbench/contacts/index.do")
    public ModelAndView index(ModelAndView modelAndView){
        List<Contacts> contactsList = contactsService.queryAllContacts();
        modelAndView.addObject("contactsList" , contactsList);
        modelAndView.setViewName("workbench/contacts/index");
        return modelAndView;
    }

}
