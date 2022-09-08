package com.biscuit.crm.workbench.service;

import com.biscuit.crm.workbench.entity.Tran;
import com.biscuit.crm.workbench.mapper.TranMapper;

import java.util.List;

public interface TransactionService {

    public List<Tran> queryAllTransaction();

    int saveCreateTran(Tran tran);
}
