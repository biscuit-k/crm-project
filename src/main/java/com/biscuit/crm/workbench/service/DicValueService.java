package com.biscuit.crm.workbench.service;

import com.biscuit.crm.workbench.entity.DicValue;

import java.util.List;

public interface DicValueService {
    public List<DicValue> queryDicValueByTypeCode(String typeCode);
}
