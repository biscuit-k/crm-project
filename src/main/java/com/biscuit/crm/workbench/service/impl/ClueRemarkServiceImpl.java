package com.biscuit.crm.workbench.service.impl;

import com.biscuit.crm.workbench.entity.ClueRemark;
import com.biscuit.crm.workbench.mapper.ClueRemarkMapper;
import com.biscuit.crm.workbench.service.ClueRemarkService;
import com.biscuit.crm.workbench.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ClueRemarkServiceImpl implements ClueRemarkService {

    @Autowired
    private ClueRemarkMapper clueRemarkMapper;

    @Override
    public List<ClueRemark> queryAllClueRemarkByClueId(String clueId) {
        return clueRemarkMapper.selectAllClueRemarkByClueId(clueId);
    }

    @Override
    public int saveCreateClueRemark(ClueRemark clueRemark) {
        return clueRemarkMapper.insertClueRemark(clueRemark);
    }

    @Override
    public int saveDeleteClueRemarkById(String id) {
        return clueRemarkMapper.deleteClueRemarkById(id);

    }
}
