package com.biscuit.crm.workbench.mapper;

import com.biscuit.crm.workbench.entity.Customer;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface CustomerMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_customer
     *
     * @mbggenerated Mon Sep 05 10:30:51 CST 2022
     */
    int deleteByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_customer
     *
     * @mbggenerated Mon Sep 05 10:30:51 CST 2022
     */
    int insert(Customer record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_customer
     *
     * @mbggenerated Mon Sep 05 10:30:51 CST 2022
     */
    int insertSelective(Customer record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_customer
     *
     * @mbggenerated Mon Sep 05 10:30:51 CST 2022
     */
    Customer selectByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_customer
     *
     * @mbggenerated Mon Sep 05 10:30:51 CST 2022
     */
    int updateByPrimaryKeySelective(Customer record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_customer
     *
     * @mbggenerated Mon Sep 05 10:30:51 CST 2022
     */
    int updateByPrimaryKey(Customer record);


    /**
     * 保存一条客户信息
     * @param customer
     * @return
     */
    int insertCustomer(@Param("customer") Customer customer);


    /**
     * 查询所有客户信息
     * @return
     */
    List<Customer> selectAllCustomer();

    /**
     * 查询所有客户名称
     * @param
     * @return
     */
    List<String> selectAllCustomerName(@Param("name") String customerName);


    /**
     * 根据客户名称查询客户Id
     * @param name
     * @return
     */
    String selectCustomerIdByName(@Param("name") String name);

}