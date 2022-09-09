package com.biscuit.crm.workbench.service;

import com.biscuit.crm.workbench.entity.TranRemark;

import java.util.List;

public interface TransactionRemarkService {

    public List<TranRemark> queryTransactionRemarkByTranId(String tranId);

    public void saveCreateTransactionRemark(TranRemark tranRemark);

}
