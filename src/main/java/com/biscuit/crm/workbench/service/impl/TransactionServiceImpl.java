package com.biscuit.crm.workbench.service.impl;

import com.biscuit.crm.workbench.entity.Tran;
import com.biscuit.crm.workbench.mapper.TranMapper;
import com.biscuit.crm.workbench.service.TransactionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TransactionServiceImpl implements TransactionService {

    @Autowired
    private TranMapper tranMapper;

    @Override
    public List<Tran> queryAllTransaction() {
        return tranMapper.selectAllTran();
    }
}
