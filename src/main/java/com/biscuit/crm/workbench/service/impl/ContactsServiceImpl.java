package com.biscuit.crm.workbench.service.impl;

import com.biscuit.crm.workbench.entity.Contacts;
import com.biscuit.crm.workbench.mapper.ContactsMapper;
import com.biscuit.crm.workbench.service.ContactsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ContactsServiceImpl implements ContactsService {

    @Autowired
    private ContactsMapper contactsMapper;

    @Override
    public List<Contacts> queryAllContacts() {
        return null;
    }
}
