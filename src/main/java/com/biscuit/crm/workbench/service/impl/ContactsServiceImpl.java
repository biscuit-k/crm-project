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
        return contactsMapper.selectAllContacts();
    }

    @Override
    public List<Contacts> queryContactsForTranSave() {
        return contactsMapper.selectContactsForTranSave();
    }

    @Override
    public List<Contacts> queryContactsForTranSaveLikeFullName(String fullName) {
        return contactsMapper.selectContactsForTranSaveLikeFullName(fullName);
    }

    @Override
    public Contacts queryContactsById(String id) {
        return contactsMapper.selectContactsById(id);
    }
}
