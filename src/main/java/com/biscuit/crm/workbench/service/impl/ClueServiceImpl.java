package com.biscuit.crm.workbench.service.impl;

import com.biscuit.crm.workbench.entity.Clue;
import com.biscuit.crm.workbench.mapper.ClueMapper;
import com.biscuit.crm.workbench.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ClueServiceImpl implements ClueService {

    @Autowired
    private ClueMapper clueMapper;

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
}
