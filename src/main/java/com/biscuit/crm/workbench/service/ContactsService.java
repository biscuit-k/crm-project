package com.biscuit.crm.workbench.service;

import com.biscuit.crm.workbench.entity.Contacts;

import java.util.List;

public interface ContactsService {

    public List<Contacts> queryAllContacts();


    public List<Contacts> queryContactsForTranSave();

    public List<Contacts> queryContactsForTranSaveLikeFullName(String fullName);

}
