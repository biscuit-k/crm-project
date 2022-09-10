package com.biscuit.crm.workbench.service.impl;

import com.biscuit.crm.commons.utils.DateUtils;
import com.biscuit.crm.commons.utils.StringUtils;
import com.biscuit.crm.commons.utils.UUIDUtils;
import com.biscuit.crm.workbench.entity.Customer;
import com.biscuit.crm.workbench.entity.FunnelVO;
import com.biscuit.crm.workbench.entity.Tran;
import com.biscuit.crm.workbench.mapper.CustomerMapper;
import com.biscuit.crm.workbench.mapper.TranMapper;
import com.biscuit.crm.workbench.service.TransactionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

@Service
public class TransactionServiceImpl implements TransactionService {

    @Autowired
    private TranMapper tranMapper;

    @Autowired
    private CustomerMapper customerMapper;

    @Override
    public List<Tran> queryAllTransaction() {
        return tranMapper.selectAllTran();
    }

    @Override
    public int saveCreateTran(Tran tran) {
        String customerName = tran.getCustomerId();

        // 判断当前客户是否存在
        String customerId = customerMapper.selectCustomerIdByName(customerName);

        if(!StringUtils.strNotNull(customerId)){
            // 不存在则创建一条客户信息
            Customer customer = new Customer();
            customer.setId(UUIDUtils.getUUID());
            customer.setCreateTime(DateUtils.formateDateTime(new Date()));
            customer.setCreateBy(tran.getCreateBy());
            customer.setOwner(tran.getCreateBy());
            customer.setName(customerId);
            customerMapper.insertCustomer(customer);
            customerId = customer.getId();
        }
        tran.setCustomerId(customerId);


        int row = tranMapper.insertTran(tran);


        return row;
    }

    @Override
    public Tran queryTransactionByIdForDetail(String id) {
        return tranMapper.selectTranByIdForDetail(id);
    }

    @Override
    public Tran queryTransactionById(String id) {
        return tranMapper.selectTranById(id);
    }

    @Override
    public List<FunnelVO> queryCountOfTranGroupByStage() {
        return tranMapper.selectCountOfTranGroupByStage();
    }
}
