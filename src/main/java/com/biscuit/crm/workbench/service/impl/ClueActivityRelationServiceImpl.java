package com.biscuit.crm.workbench.service.impl;

import com.biscuit.crm.workbench.entity.ClueActivityRelation;
import com.biscuit.crm.workbench.mapper.ClueActivityRelationMapper;
import com.biscuit.crm.workbench.service.ClueActivityRelationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ClueActivityRelationServiceImpl implements ClueActivityRelationService {

    @Autowired
    private ClueActivityRelationMapper carMapping;

    @Override
    public int saveCreateClueActivityRelation(List<ClueActivityRelation> carList) {
        return carMapping.insertClueActivityRelation(carList);
    }

    @Override
    public int saveDeleteClueActivityRelationByActivityIdAndClueId(String activityId , String clueId) {
        return carMapping.deleteClueActivityRelationByActivityIdAndClueId(activityId , clueId);
    }
}
