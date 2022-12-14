package com.biscuit.crm.workbench.mapper;

import com.biscuit.crm.workbench.entity.ContactsActivityRelation;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface ContactsActivityRelationMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_contacts_activity_relation
     *
     * @mbggenerated Tue Sep 06 09:52:48 CST 2022
     */
    int deleteByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_contacts_activity_relation
     *
     * @mbggenerated Tue Sep 06 09:52:48 CST 2022
     */
    int insert(ContactsActivityRelation record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_contacts_activity_relation
     *
     * @mbggenerated Tue Sep 06 09:52:48 CST 2022
     */
    int insertSelective(ContactsActivityRelation record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_contacts_activity_relation
     *
     * @mbggenerated Tue Sep 06 09:52:48 CST 2022
     */
    ContactsActivityRelation selectByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_contacts_activity_relation
     *
     * @mbggenerated Tue Sep 06 09:52:48 CST 2022
     */
    int updateByPrimaryKeySelective(ContactsActivityRelation record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_contacts_activity_relation
     *
     * @mbggenerated Tue Sep 06 09:52:48 CST 2022
     */
    int updateByPrimaryKey(ContactsActivityRelation record);


    /**
     * 插入多条市场活动与联系人的关系
     * @param contactsActivityRelationList
     * @return
     */
    int insertManyContactsActivityRelation(@Param("contactsActivityRelationList") List<ContactsActivityRelation> contactsActivityRelationList);

}