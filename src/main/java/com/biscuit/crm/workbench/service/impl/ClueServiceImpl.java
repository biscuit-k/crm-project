package com.biscuit.crm.workbench.service.impl;

import com.biscuit.crm.commons.contants.Contants;
import com.biscuit.crm.commons.utils.DateUtils;
import com.biscuit.crm.commons.utils.UUIDUtils;
import com.biscuit.crm.settings.entity.User;
import com.biscuit.crm.workbench.entity.*;
import com.biscuit.crm.workbench.mapper.*;
import com.biscuit.crm.workbench.service.ClueService;
import org.apache.poi.ss.formula.functions.T;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

@Service
public class ClueServiceImpl implements ClueService {

    @Autowired
    private ClueMapper clueMapper;

    @Autowired
    private CustomerMapper customerMapper;

    @Autowired
    private ContactsMapper contactsMapper;

    @Autowired
    private ClueRemarkMapper clueRemarkMapper;

    @Autowired
    private ActivityMapper activityMapper;

    @Autowired
    private ContactsRemarkMapper contactsRemarkMapper;

    @Autowired
    private CustomerRemarkMapper customerRemarkMapper;

    @Autowired
    private ContactsActivityRelationMapper contactsActivityRelationMapper;

    @Autowired
    private TranMapper tranMapper;

    @Autowired
    private TranRemarkMapper tranRemarkMapper;

    @Autowired
    private ClueActivityRelationMapper clueActivityRelationMapper;



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

    @Override
    public void saveConvert(Map<String, Object> map) {

        User user = (User) map.get(Contants.SESSION_USER);
        String clueId = map.get("clueId").toString();
        boolean isCreateTransaction = (boolean) map.get("isCreateTransaction");

        // 1. ?????? id ??????????????????
        Clue clue = clueMapper.selectClueById(clueId);

        // 2. ???????????????????????????????????????????????????????????????
        Customer customer = new Customer();
        customer.setId(UUIDUtils.getUUID());
        customer.setPhone(clue.getPhone());
        customer.setAddress(clue.getAddress());
        customer.setWebsite(clue.getWebsite());
        customer.setContactSummary(clue.getContactSummary());
        customer.setCreateBy(user.getId());
        customer.setCreateTime(DateUtils.formateDateTime(new Date()));
        customer.setName(clue.getCompany());
        customer.setNextContactTime(clue.getNextContactTime());
        customer.setOwner(user.getId());
        customer.setDescription(clue.getDescription());

        customerMapper.insertCustomer(customer);

        // 3. ??????????????????????????????????????????????????????????????????
        Contacts contacts = new Contacts();
        contacts.setContactSummary(clue.getContactSummary());
        contacts.setAddress(clue.getAddress());
        contacts.setCreateBy(user.getId());
        contacts.setCreateTime(DateUtils.formateDateTime(new Date()));
        contacts.setDescription(clue.getDescription());
        contacts.setFullname(clue.getFullname());
        contacts.setJob(clue.getJob());
        contacts.setEmail(clue.getEmail());
        contacts.setNextContactTime(clue.getNextContactTime());
        contacts.setId(UUIDUtils.getUUID());
        contacts.setAppellation(clue.getAppellation());
        contacts.setOwner(user.getId());
        contacts.setMphone(clue.getMphone());
        contacts.setCustomerId(customer.getId());
        contacts.setSource(clue.getSource());

        contactsMapper.insertContacts(contacts);

        // 4. ???????????? id????????????????????????????????????
        List<ClueRemark> clueRemarkList = clueRemarkMapper.selectClueRemarkByClueId(clueId);


        if(clueRemarkList != null && clueRemarkList.size() > 0){
            List<ContactsRemark> contactsRemarkList = new ArrayList<>();
            List<CustomerRemark> customerRemarkList = new ArrayList<>();
            for (ClueRemark clueRemark : clueRemarkList) {
                ContactsRemark contactsRemark = new ContactsRemark();
                CustomerRemark customerRemark = new CustomerRemark();

                contactsRemark.setId(UUIDUtils.getUUID());
                contactsRemark.setContactsId(contacts.getId());
                contactsRemark.setCreateBy(clueRemark.getCreateBy());
                contactsRemark.setCreateTime(clueRemark.getCreateTime());
                contactsRemark.setEditBy(clueRemark.getEditBy());
                contactsRemark.setEditTime(clueRemark.getEditTime());
                contactsRemark.setEditFlag(clueRemark.getEditFlag());
                contactsRemark.setNoteContent(clueRemark.getNoteContent());
                contactsRemarkList.add(contactsRemark);

                customerRemark.setId(UUIDUtils.getUUID());
                customerRemark.setCustomerId(customer.getId());
                customerRemark.setCreateBy(clueRemark.getCreateBy());
                customerRemark.setCreateTime(clueRemark.getCreateTime());
                customerRemark.setEditBy(clueRemark.getEditBy());
                customerRemark.setEditTime(clueRemark.getEditTime());
                customerRemark.setEditFlag(clueRemark.getEditFlag());
                customerRemark.setNoteContent(clueRemark.getNoteContent());
                customerRemarkList.add(customerRemark);
            }

            // 5. ???????????????????????????????????????????????????????????????
            contactsRemarkMapper.saveManyContactsRemark(contactsRemarkList);

            // 6. ??????????????????????????????????????????????????????????????????
            customerRemarkMapper.saveManyCustomerRemark(customerRemarkList);

        }


        // 7. ???????????? id???????????????????????????????????????id
        List<Activity> activityList = activityMapper.selectClueBindActivityByClueId(clueId);


        if (activityList != null && activityList.size() > 0){
            List<ContactsActivityRelation> contactsActivityRelationList = new ArrayList<>();
            for (Activity activity : activityList) {
                ContactsActivityRelation contactsActivityRelation = new ContactsActivityRelation();
                contactsActivityRelation.setId(UUIDUtils.getUUID());
                contactsActivityRelation.setActivityId(activity.getId());
                contactsActivityRelation.setContactsId(contacts.getId());
                contactsActivityRelationList.add(contactsActivityRelation);
            }

            // 8. ???????????????????????????????????????????????????????????????????????????????????????
            contactsActivityRelationMapper.insertManyContactsActivityRelation(contactsActivityRelationList);
        }

        // 9. ???????????????????????????????????????????????????????????????
        if(isCreateTransaction){
            Tran tran = (Tran) map.get("tran");
            tran.setId(UUIDUtils.getUUID());
            tran.setCreateBy(user.getId());
            tran.setCreateTime(DateUtils.formateDateTime(new Date()));
            tran.setContactsId(contacts.getId());
            tran.setCustomerId(customer.getId());
            tran.setOwner(user.getId());

            tranMapper.insertTran(tran);

            // 10. ?????????????????????????????????????????????
            if(clueRemarkList != null && clueRemarkList.size() > 0){
                List<TranRemark> tranRemarkList = new ArrayList<>();
                for (ClueRemark clueRemark : clueRemarkList) {
                    TranRemark tranRemark = new TranRemark();

                    tranRemark.setId(UUIDUtils.getUUID());
                    tranRemark.setTranId(tran.getId());
                    tranRemark.setCreateBy(clueRemark.getCreateBy());
                    tranRemark.setCreateTime(clueRemark.getCreateTime());
                    tranRemark.setEditBy(clueRemark.getEditBy());
                    tranRemark.setEditTime(clueRemark.getEditTime());
                    tranRemark.setEditFlag(clueRemark.getEditFlag());
                    tranRemark.setNoteContent(clueRemark.getNoteContent());
                    tranRemarkList.add(tranRemark);
                }
                tranRemarkMapper.insertManyTranRemark(tranRemarkList);

            }
        }

        // 11. ???????????????????????????????????????
        clueRemarkMapper.deleteManyClueRemarkByClueId(clueId);

        // 12. ??????????????????????????????????????????
        clueActivityRelationMapper.deleteManyClueActivityRelationByClueId(clueId);

        // 13. ???????????????
        clueMapper.deleteSingleClueById(clueId);

    }
}
