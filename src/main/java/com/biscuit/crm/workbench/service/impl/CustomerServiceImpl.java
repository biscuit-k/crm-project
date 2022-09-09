package com.biscuit.crm.workbench.service.impl;

import com.biscuit.crm.workbench.entity.Customer;
import com.biscuit.crm.workbench.mapper.CustomerMapper;
import com.biscuit.crm.workbench.service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CustomerServiceImpl implements CustomerService {

    @Autowired
    private CustomerMapper customerMapper;
    @Override
    public List<Customer> queryAllCustomer() {
        return customerMapper.selectAllCustomer();
    }

    @Override
    public List<String> queryAllCustomerName(String customerName) {
        return customerMapper.selectAllCustomerName(customerName);
    }

    @Override
    public Customer queryCustomerById(String id) {
        return customerMapper.selectCustomerById(id);
    }
}
