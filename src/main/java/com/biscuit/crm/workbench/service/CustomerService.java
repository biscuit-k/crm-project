package com.biscuit.crm.workbench.service;

import com.biscuit.crm.workbench.entity.Customer;

import java.util.List;

public interface CustomerService {

    public List<Customer> queryAllCustomer();


    public List<String> queryAllCustomerName(String customerName);

}
