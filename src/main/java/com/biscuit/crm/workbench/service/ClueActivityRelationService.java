package com.biscuit.crm.workbench.service;

import com.biscuit.crm.workbench.entity.ClueActivityRelation;

import java.util.List;

public interface ClueActivityRelationService {

    public int saveCreateClueActivityRelation(List<ClueActivityRelation> carList);

    int saveDeleteClueActivityRelationByActivityIdAndClueId(String activity , String clueId);
}
