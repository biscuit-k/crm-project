package com.biscuit.crm.workbench.mapper;

import com.biscuit.crm.workbench.entity.DicValue;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface DicValueMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_dic_value
     *
     * @mbggenerated Sun Aug 21 10:48:59 CST 2022
     */
    int deleteByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_dic_value
     *
     * @mbggenerated Sun Aug 21 10:48:59 CST 2022
     */
    int insert(DicValue record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_dic_value
     *
     * @mbggenerated Sun Aug 21 10:48:59 CST 2022
     */
    int insertSelective(DicValue record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_dic_value
     *
     * @mbggenerated Sun Aug 21 10:48:59 CST 2022
     */
    DicValue selectByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_dic_value
     *
     * @mbggenerated Sun Aug 21 10:48:59 CST 2022
     */
    int updateByPrimaryKeySelective(DicValue record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_dic_value
     *
     * @mbggenerated Sun Aug 21 10:48:59 CST 2022
     */
    int updateByPrimaryKey(DicValue record);

    /**
     * 根据数据字段类型，查询对应参数
     * @param typeCode
     * @return
     */
    List<DicValue> selectDicValueByTypeCode(@Param("typeCode") String typeCode);

}