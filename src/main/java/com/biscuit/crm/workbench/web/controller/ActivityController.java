package com.biscuit.crm.workbench.web.controller;

import com.biscuit.crm.commons.contants.Contants;
import com.biscuit.crm.commons.entity.ReturnObject;
import com.biscuit.crm.commons.utils.StringUtils;
import com.biscuit.crm.commons.utils.DateUtils;
import com.biscuit.crm.commons.utils.HSSFUtils;
import com.biscuit.crm.commons.utils.UUIDUtils;
import com.biscuit.crm.settings.entity.User;
import com.biscuit.crm.settings.service.UserService;
import com.biscuit.crm.workbench.entity.Activity;
import com.biscuit.crm.workbench.entity.ActivityRemark;
import com.biscuit.crm.workbench.service.ActivityRemarkService;
import com.biscuit.crm.workbench.service.ActivityService;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.*;

@Controller
public class ActivityController {

    @Autowired
    private UserService userService;
    @Autowired
    private ActivityService activityService;
    @Autowired
    private ActivityRemarkService activityRemarkService;

    @RequestMapping("/workbench/activity/index.do")
    public String index(HttpServletRequest request){
        List<User> userList = userService.queryAllUsers();
        request.setAttribute("requestUsers" , userList);
        return "workbench/activity/index";
    }


    @RequestMapping("/workbench/activity/saveCreateActivity.do")
    @ResponseBody
    public Object saveCreateActivity(Activity activity , HttpSession session){
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();
        // 封装参数
        activity.setId(UUIDUtils.getUUID());
        activity.setCreateTime(DateUtils.formateDateTime(new Date()));
        activity.setCreateBy(user.getId());

        try{
            // 调用 service 层方法，保存用户数据
            int row = activityService.saveCreateActivity(activity);
            // 根据新增结果判断，是否操作成功
            if(row > 0){
                // 新增成功
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            }else{
                // 新增失败
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统正忙，请稍后重试...");
            }
        } catch ( Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统正忙，请稍后重试...");
        }



        return returnObject;
    }


    @RequestMapping("/workbench/activity/queryActivityByConditionForPage.do")
    @ResponseBody
    public Object queryActivityByConditionForPage(String name , String owner , String startDate , String endDate ,
                                                  int pageNo , int pageSize){

        int beginNo = ( pageNo - 1 ) *  pageSize;
        Map<String,Object> map = new HashMap<>();
        map.put("beginNo" , beginNo);
        map.put("pageSize" , pageSize);
        map.put("name" , name);
        map.put("owner" , owner);
        map.put("startDate" , startDate);
        map.put("endDate" , endDate);
        // 调用 service 方法
        List<Activity> activityList  = activityService.queryActivityByConditionForPage(map);
        int totalCount = activityService.queryCountOfActivityByCondition(map);

        int totalPage = totalCount / pageSize; // 总页码
        totalPage += (totalCount % pageSize > 0)?1:0;
        Map<String , Object> page = new HashMap<>();
        page.put("pageNo" , pageNo); // 当前页面
        page.put("totalCount" , totalCount); // 总数据条数
        page.put("totalPage" , totalPage); // 总页码
        page.put("activityList" , activityList); // 当前页的数据
        return page;
    }


    /**
     * 根据当前请求中提供的多个市场活动id删除对应的多条数据
     * @param ids
     * @return
     */
    @RequestMapping("/workbench/activity/deleteActivityByIds.do")
    @ResponseBody
    public Object deleteActivityByIds(String[] ids){
        ReturnObject returnObject = new ReturnObject();
        if(ids != null && ids.length > 0){
            try {
                int row = activityService.deleteActivityByIds(ids);
                if( row > 0 ){
                    returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                    returnObject.setReturnData(row);
                }else{
                    returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                    returnObject.setMessage("系统正忙，请稍后重试！");
                }
            } catch ( Exception e ){
                e.printStackTrace();
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统正忙，请稍后重试！");
            }

        }
        return returnObject;
    }

    /**
     * 根据请求中提供的市场活动 id 获取指定的市场活动信息
     */
    @RequestMapping("/workbench/activity/queryActivityById.do")
    @ResponseBody
    public Object queryActivityById(String id){

        ReturnObject returnObject = new ReturnObject();

        Activity activity = activityService.queryActivityById(id);
        if(activity == null){
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage(Contants.RETURN_OBJECT_ERROR_MESSAGE_CURRENCY);
        }else{
            returnObject.setReturnData(activity);
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
        }

        return returnObject;
    }

    @RequestMapping("/workbench/activity/saveEditActivity.do")
    @ResponseBody
    public Object saveEditActivity(Activity activity , HttpSession session){
        ReturnObject returnObject = new ReturnObject();
        User user = (User) session.getAttribute(Contants.SESSION_USER);

        // 封装参数
        activity.setEditBy(user.getId());
        activity.setEditTime(DateUtils.formateDate(new Date()));

        try {
            int row = activityService.saveEditActivity(activity);
            if( row > 0 ){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            }else{
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setCode(Contants.RETURN_OBJECT_ERROR_MESSAGE_CURRENCY);
            }
        } catch ( Exception e ) {
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setCode(Contants.RETURN_OBJECT_ERROR_MESSAGE_CURRENCY);
        }

        return returnObject;
    }

    // 将市场活动信息生成 Excel 文件
    @RequestMapping("/workbench/activity/exportAllActivity.do")
    @ResponseBody
    public void exportAllActivity(HttpServletResponse response) throws Exception {

        // 获取所有市场活动信息
        List<Activity> activityList = activityService.queryAllActivity();
        // 根据查询结果，使用插件生成 excel 文件，并且将查询的所有市场活动数据写入文件中
        HSSFWorkbook workbook = HSSFUtils.createExcelByActivityList(activityList);
        // 根据市场活动信息生成的 WorkBook 对象，生成 excel 文件，并将生成的文件写到一个指定的位置
        /*String fileName = UUIDUtils.getUUID();
        FileOutputStream os = new FileOutputStream("Q:\\IdeaProject\\crm-project\\portExcelFile\\" + fileName + ".xls");// 生成的 excel 保存位置
        workbook.write(os);*/
        // 关闭资源
        /*os.close();*/
/*        workbook.close();*/

        // 之后将生成的 excel 文件存储响应中，供用户下载

        /*
            手动设置响应类型，设置为响应文件的格式（设置不同的类型百度搜索 content type）
                - application/octet-stream 代表设置相应格式为 excel 文件
        */
        // 1.设置相应类型
        response.setContentType("application/octet-stream;charset=UTF-8");
        // 浏览器接收到相应信息后，默认情况下，都是直接在显示窗口中打开一个空页面打开响应信息
        // 即使打不开也会调用本机的应用程序来打开响应信息，如果还是打不开则会进行文件下载
        // 那么在这时可用手动设置响应头信息，使浏览器接收到响应信息之后，直接激活文件下载窗口，即使响应是可用打开的信息也会打开下载窗口，而不会进行打开
        response.addHeader("Content-Disposition" , "attachment;filename=activityList.xls");
        // 2.获取输出流
        OutputStream outputStream = response.getOutputStream();



        // 3.从服务器中读取 excel 文件，并且通过 outputStream 输出到浏览器
        /*InputStream inputStream = new FileInputStream("Q:\\IdeaProject\\crm-project\\portExcelFile\\" + fileName + ".xls");
        byte[] bytes = new byte[256];
        int len = 0;
        while( (len = inputStream.read(bytes)) != -1){
            outputStream.write(bytes , 0 ,len);
        }*/

        // 最终解决方法，不讲 workbook 中生成的 excel 文件先写到服务器中，再从服务器中读取，而是直接通过写到浏览器中
        workbook.write(outputStream);

        // 4.关闭资源
        outputStream.flush();
        workbook.close();
       /* inputStream.close();*/
    }

    // 导出页码中选中的市场活动信息
    @RequestMapping("/workbench/activity/exportActivityByIds.do")
    public void exportActivityByIds(HttpServletResponse response , String[] ids) throws Exception{
        List<Activity> activityList = null;
        if(ids != null && ids.length > 0){
            activityList = activityService.queryActivityByIds(ids);
        }

        // 根据查询结果，使用插件生成 excel 文件，并且将查询的所有市场活动数据写入文件中
        HSSFWorkbook workbook = HSSFUtils.createExcelByActivityList(activityList);
        // 根据市场活动信息生成的 WorkBook 对象，生成 excel 文件，并将生成的文件写到一个指定的位置
        /*
        String fileName = UUIDUtils.getUUID();
        FileOutputStream os = new FileOutputStream("Q:\\IdeaProject\\crm-project\\portExcelFile\\" + fileName + ".xls");// 生成的 excel 保存位置
        workbook.write(os);
        // 关闭资源
        os.close();
        workbook.close();
        */

        // 之后将生成的 excel 文件存储响应中，供用户下载

        /*
            手动设置响应类型，设置为响应文件的格式（设置不同的类型百度搜索 content type）
                - application/octet-stream 代表设置相应格式为 excel 文件
        */
        // 1.设置相应类型
        response.setContentType("application/octet-stream;charset=UTF-8");
        // 浏览器接收到相应信息后，默认情况下，都是直接在显示窗口中打开一个空页面打开响应信息
        // 即使打不开也会调用本机的应用程序来打开响应信息，如果还是打不开则会进行文件下载
        // 那么在这时可用手动设置响应头信息，使浏览器接收到响应信息之后，直接激活文件下载窗口，即使响应是可用打开的信息也会打开下载窗口，而不会进行打开
        response.addHeader("Content-Disposition" , "attachment;filename=activityXzList.xls");
        // 2.获取输出流
        OutputStream outputStream = response.getOutputStream();



        // 3.从服务器中读取 excel 文件，并且通过 outputStream 输出到浏览器
        /*InputStream inputStream = new FileInputStream("Q:\\IdeaProject\\crm-project\\portExcelFile\\" + fileName + ".xls");
        byte[] bytes = new byte[256];
        int len = 0;
        while( (len = inputStream.read(bytes)) != -1){
            outputStream.write(bytes , 0 ,len);
        }*/


        // 最终解决方法，不讲 workbook 中生成的 excel 文件先写到服务器中，再从服务器中读取，而是直接通过写到浏览器中
        workbook.write(outputStream);

        // 4.关闭资源
        outputStream.flush();
        workbook.close();
        /*inputStream.close();*/

    }


    // 客户端导入市场活动 excel 文件，将其转换为数据并且添加到数据库中
    @ResponseBody
    @RequestMapping("/workbench/activity/importActivity.do")
    public Object importActivity(MultipartFile activityFile , HttpSession session){
        ReturnObject returnObject = new ReturnObject();
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        try {
            // 获取用户浏览器中上传的 excel 文件
            InputStream inputStream = activityFile.getInputStream();
            // 通过 HSSF 中 WorkBook 解析 inputStream 中的 excel 文件，并且返回一个集合
            List<Activity> activityList = HSSFUtils.importActivityExcelFormateList(inputStream , user);
            // 判断是否为空
            if(activityList != null && activityList.size() > 0){
                // 不为空进行将集合中的市场活动信息插入到数据库
                int row = activityService.saveMoreActivityByList(activityList);
                // 根据新增条数判断是否新增成功
                if( row > 0 ){
                    returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                }else{
                    returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                    returnObject.setMessage(Contants.RETURN_OBJECT_ERROR_MESSAGE_CURRENCY);
                }
            }else{
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage(Contants.RETURN_OBJECT_ERROR_MESSAGE_CURRENCY);
            }
        } catch (IOException e) {
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage(Contants.RETURN_OBJECT_ERROR_MESSAGE_CURRENCY);
        }
        return returnObject;
    }

    @RequestMapping("/workbench/activity/detail.do")
    public String detail(HttpServletRequest request , String id){
        Activity activity = activityService.queryActivityByIdForDetail(id);
        request.setAttribute("activity" , activity);
        return "workbench/activity/detail";
    }

    @ResponseBody
    @RequestMapping("/workbench/activity/queryActivityRemarkListByActivityId.do")
    public Object getActivityRemarkListByActivityId(String activityId){
        ReturnObject returnObject = new ReturnObject();
        List<ActivityRemark> activityRemarkList = null;
       if(activityId != null && activityId != ""){
           activityRemarkList = activityRemarkService.queryActivityRemarkListByActivityId(activityId);
       }else{
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setCode(Contants.RETURN_OBJECT_ERROR_MESSAGE_CURRENCY);
       }
       if(activityRemarkList != null && activityRemarkList.size() > 0){
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            returnObject.setReturnData(activityRemarkList);
       }else{
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setCode(Contants.RETURN_OBJECT_ERROR_MESSAGE_CURRENCY);
        }
       return returnObject;
    }

    @ResponseBody
    @RequestMapping("/workbench/activity/saveCreateActivityRemark.do")
    public Object saveCreateActivityRemark(String activityId , String noteContent , HttpSession session){
        ReturnObject returnObject = new ReturnObject();
        if(StringUtils.strNotNull(activityId) && StringUtils.strNotNull(noteContent)){
            ActivityRemark activityRemark = new ActivityRemark();
            User user = (User) session.getAttribute(Contants.SESSION_USER);
            activityRemark.setId(UUIDUtils.getUUID());
            activityRemark.setActivityId(activityId);
            activityRemark.setNoteContent(noteContent);
            activityRemark.setCreateTime(DateUtils.formateDateTime(new Date()));
            activityRemark.setCreateBy(user.getId());
            activityRemark.setEditFlag("0");
            try {
                int row = activityRemarkService.saveActivityRemark(activityRemark);
                if(row > 0){
                    returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                }else{
                    returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                    returnObject.setMessage(Contants.RETURN_OBJECT_ERROR_MESSAGE_CURRENCY);
                }
            } catch (Exception e){
                e.printStackTrace();
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage(Contants.RETURN_OBJECT_ERROR_MESSAGE_CURRENCY);
            }
        }else{
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage(Contants.RETURN_OBJECT_ERROR_MESSAGE_CURRENCY);
        }
        return returnObject;
    }


    @ResponseBody
    @RequestMapping("/workbench/activity/saveEditActivityRemark.do")
    public Object saveEditActivityRemark(HttpSession session , String id , String noteContent){
        ReturnObject returnObject = new ReturnObject();
        if(StringUtils.strNotNull(id) && StringUtils.strNotNull(noteContent)){
            ActivityRemark activityRemark = new ActivityRemark();
            User user = (User) session.getAttribute(Contants.SESSION_USER);
            activityRemark.setId(id);
            activityRemark.setEditBy(user.getId());
            activityRemark.setEditTime(DateUtils.formateDateTime(new Date()));
            activityRemark.setNoteContent(noteContent);
            activityRemark.setEditFlag("1"); // 将修改状态改为 1，表示修改过
            try{
                int row = activityRemarkService.saveEditActivityRemark(activityRemark);
                if(row > 0){
                    returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                }else{
                    returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                    returnObject.setMessage(Contants.RETURN_OBJECT_ERROR_MESSAGE_CURRENCY);
                }
            } catch (Exception e){
                e.printStackTrace();
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage(Contants.RETURN_OBJECT_ERROR_MESSAGE_CURRENCY);
            }
        }else{
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage(Contants.RETURN_OBJECT_ERROR_MESSAGE_CURRENCY);
        }
        return returnObject;
    }


    @ResponseBody
    @RequestMapping("/workbench/activity/saveDeleteActivityRemarkById.do")
    public Object saveDeleteActivityRemarkById(String id){
        ReturnObject returnObject = new ReturnObject();
        if(StringUtils.strNotNull(id)){
            try{
                int row = activityRemarkService.saveDeleteActivityRemarkById(id);
                if(row > 0){
                    returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                }else{
                    returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                    returnObject.setMessage(Contants.RETURN_OBJECT_ERROR_MESSAGE_CURRENCY);
                }
            } catch (Exception e){
                e.printStackTrace();
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage(Contants.RETURN_OBJECT_ERROR_MESSAGE_CURRENCY);
            }
        }else{
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage(Contants.RETURN_OBJECT_ERROR_MESSAGE_CURRENCY);
        }
        return returnObject;
    }



}
