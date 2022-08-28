package com.biscuit.crm.workbench.service.impl;

import com.biscuit.crm.commons.contants.Contants;
import com.biscuit.crm.commons.utils.DateUtils;
import com.biscuit.crm.commons.utils.UUIDUtils;
import com.biscuit.crm.settings.entity.User;
import com.biscuit.crm.workbench.entity.Clue;
import com.biscuit.crm.workbench.entity.Customer;
import com.biscuit.crm.workbench.mapper.ClueMapper;
import com.biscuit.crm.workbench.mapper.CustomerMapper;
import com.biscuit.crm.workbench.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.Map;

@Service
public class ClueServiceImpl implements ClueService {

    @Autowired
    private ClueMapper clueMapper;

    @Autowired
    private CustomerMapper customerMapper;

    @Override
    public int saveCreateClue(Clue clue) {
        return clueMapper.insertClue(clue);
    }

    @Override
    public List<Clue> queryAllClue() {
        return clueMapper.selectAllClue();
    }

    @Override
    public int saveDeleteClueById(String[] id) {
        return clueMapper.deleteClueById(id);
    }

    @Override
    public Clue queryClueByIdFromDetail(String id) {
        return clueMapper.selectClueByIdFromDetail(id);
    }

    @Override
    public Clue queryClueByIdFromEdit(String id) {
        return clueMapper.selectClueByIdFromEdit(id);
    }

    @Override
    public int saveUpdateClue(Clue clue) {
        return clueMapper.updateClue(clue);
    }

    @Override
    public void saveConvert(Map<String, Object> map) {

            User user = (User) map.get(Contants.SESSION_USER);

            // 1. 根据 id 查询线索信息
            Clue clue = clueMapper.selectClueById(map.get("clueId").toString());

            // 2. 将线索信息中，关于公司的信息转换到客户表中
            Customer customer = new Customer();
            customer.setId(UUIDUtils.getUUID());
            customer.setPhone(clue.getPhone());
            customer.setAddress(clue.getAddress());
            customer.setWebsite(clue.getWebsite());
            customer.setContactSummary(clue.getContactSummary());
            customer.setCreateBy(user.getId());
            customer.setCreateTime(DateUtils.formateDateTime(new Date()));
            customer.setName(clue.getCompany());
            customer.setNextContactTime(clue.getNextContactTime());
            customer.setOwner(user.getId());
            customer.setDescription(clue.getDescription());

            customerMapper.insertCustomer(customer);


    }
}
