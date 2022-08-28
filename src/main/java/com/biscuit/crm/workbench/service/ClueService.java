package com.biscuit.crm.workbench.service;

import com.biscuit.crm.workbench.entity.Clue;

import java.util.List;
import java.util.Map;

public interface ClueService {


    public int saveCreateClue(Clue clue);

    public List<Clue> queryAllClue();

    public int saveDeleteClueById(String[] id);

    public Clue queryClueByIdFromDetail(String id);

    public Clue queryClueByIdFromEdit(String id);

    public int saveUpdateClue(Clue clue);

    /**
     * 保持转换
     * @param map
     */
    public void saveConvert(Map<String , Object> map);

}
