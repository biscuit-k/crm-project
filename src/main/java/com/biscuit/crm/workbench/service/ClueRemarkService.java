package com.biscuit.crm.workbench.service;

import com.biscuit.crm.workbench.entity.ClueRemark;

import java.util.List;

public interface ClueRemarkService {

    public List<ClueRemark> queryAllClueRemarkByClueId(String clueId);

    public int saveCreateClueRemark(ClueRemark clueRemark);

    public int saveDeleteClueRemarkById(String id);

}
