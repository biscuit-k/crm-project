package com.biscuit.crm.workbench.service.impl;

import com.biscuit.crm.workbench.entity.TranRemark;
import com.biscuit.crm.workbench.mapper.TranMapper;
import com.biscuit.crm.workbench.mapper.TranRemarkMapper;
import com.biscuit.crm.workbench.service.TransactionRemarkService;
import org.apache.poi.ss.formula.functions.T;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TransactionRemarkServiceImpl implements TransactionRemarkService {


    @Autowired
    private TranRemarkMapper tranRemarkMapper;


    @Override
    public List<TranRemark> queryTransactionRemarkByTranId(String tranId) {
        return tranRemarkMapper.selectTranRemarkByTranId(tranId);
    }

    @Override
    public void saveCreateTransactionRemark(TranRemark tranRemark) {
        tranRemarkMapper.insertTranRemark(tranRemark);
    }
}
