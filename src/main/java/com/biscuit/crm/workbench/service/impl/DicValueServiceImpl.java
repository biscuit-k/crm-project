package com.biscuit.crm.workbench.service.impl;

import com.biscuit.crm.workbench.entity.DicValue;
import com.biscuit.crm.workbench.mapper.DicValueMapper;
import com.biscuit.crm.workbench.service.DicValueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class DicValueServiceImpl implements DicValueService {

    @Autowired
    private DicValueMapper dicValueMapper;

    @Override
    public List<DicValue> queryDicValueByTypeCode(String typeCode) {
        return dicValueMapper.selectDicValueByTypeCode(typeCode);
    }
}
