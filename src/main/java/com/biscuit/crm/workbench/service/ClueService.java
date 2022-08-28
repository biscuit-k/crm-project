package com.biscuit.crm.workbench.service;

import com.biscuit.crm.workbench.entity.Clue;

import java.util.List;

public interface ClueService {


    public int saveCreateClue(Clue clue);

    public List<Clue> queryAllClue();

    public int saveDeleteClueById(String[] id);

    public Clue queryClueByIdFromDetail(String id);

    public Clue queryClueByIdFromEdit(String id);

    public int saveUpdateClue(Clue clue);

}
