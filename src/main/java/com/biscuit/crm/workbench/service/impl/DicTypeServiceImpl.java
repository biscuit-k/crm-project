package com.biscuit.crm.workbench.service.impl;

import com.biscuit.crm.workbench.mapper.DicTypeMapper;
import com.biscuit.crm.workbench.service.DicTypeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class DicTypeServiceImpl implements DicTypeService {

    @Autowired
    private DicTypeMapper dicTypeMapper;

    @Override
    public String queryTypeCodeByName(String name) {
        return dicTypeMapper.selectTypeCodeByName(name);
    }
}
