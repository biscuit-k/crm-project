package com.biscuit.crm.commons.utils;

import com.biscuit.crm.settings.entity.User;
import com.biscuit.crm.workbench.entity.Activity;
import javafx.scene.control.Cell;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class HSSFUtils {

    public static HSSFWorkbook createExcelByActivityList(List<Activity> list){
        HSSFWorkbook workbook = new HSSFWorkbook(); // 创建文件
        HSSFSheet sheet = workbook.createSheet("市场活动数据表");// 创建一页

        HSSFRow row = sheet.createRow(0); // 在一页中创建第一行
        HSSFCell cell = row.createCell(0); // 在一行中创建第一列
        cell.setCellValue("ID");
        cell = row.createCell(1); // 在一行中创建第二列
        cell.setCellValue("所有者");
        cell = row.createCell(2);
        cell.setCellValue("市场活动名称");
        cell = row.createCell(3);
        cell.setCellValue("开始日期");
        cell = row.createCell(4);
        cell.setCellValue("结束日期");
        cell = row.createCell(5);
        cell.setCellValue("成本");
        cell = row.createCell(6);
        cell.setCellValue("描述");
        cell = row.createCell(7);
        cell.setCellValue("创建时间");
        cell = row.createCell(8);
        cell.setCellValue("创建者");
        cell = row.createCell(9);
        cell.setCellValue("修改时间");
        cell = row.createCell(10);
        cell.setCellValue("修改者");

        // 判断是否存在数据，存在数据则进行插入，不存在则返回一个空文件
        if(list != null && list.size() > 0){
            // 使用循环插入实际数据
            Activity activity = null;
            for (int i = 0; i < list.size(); i++) {
                activity = list.get(i);
                row = sheet.createRow(i+1);

                cell = row.createCell(0);
                cell.setCellValue(activity.getId());
                cell = row.createCell(1); // 在一行中创建第二列
                cell.setCellValue(activity.getOwner());
                cell = row.createCell(2);
                cell.setCellValue(activity.getName());
                cell = row.createCell(3);
                cell.setCellValue(activity.getStartDate());
                cell = row.createCell(4);
                cell.setCellValue(activity.getEndDate());
                cell = row.createCell(5);
                cell.setCellValue(activity.getCost());
                cell = row.createCell(6);
                cell.setCellValue(activity.getDescription());
                cell = row.createCell(7);
                cell.setCellValue(activity.getCreateTime());
                cell = row.createCell(8);
                cell.setCellValue(activity.getCreateBy());
                cell = row.createCell(9);
                cell.setCellValue(activity.getEditTime());
                cell = row.createCell(10);
                cell.setCellValue(activity.getEditBy());
            }
        }


        return workbook;
    }

    /**
     * 将 inputStream 输入流中的 excel 文件解析为 Activity 的 List 集合
     * @param inputStream
     * @return
     * @throws IOException
     */
    public static List<Activity> importActivityExcelFormateList(InputStream inputStream , User user) throws IOException {
        List<Activity> activityList = new ArrayList<>();

        HSSFWorkbook workbook = new HSSFWorkbook(inputStream);
        HSSFSheet sheet = workbook.getSheetAt(0);
        HSSFRow row = null;
        HSSFCell cell = null;
        Activity activity = null;
        for (int i = 1; i <= sheet.getLastRowNum(); i++) {

            activity = new Activity();
            // 用户不能自己输入的内容
            activity.setId(UUIDUtils.getUUID()); // 该市场活动的 id
            activity.setCreateBy(user.getId()); // 该订单的创建者
            activity.setOwner(user.getId()); // 该活动的所有者，这里采用谁导入的数据，所有者就是谁，四种解决方案，主要使用的是这种和公共账号的方式
            activity.setCreateTime(DateUtils.formateDate(new Date())); // 活动创建时间
            row = sheet.getRow(i);
            for (int j = 0; j < row.getLastCellNum(); j++) {
                cell = row.getCell(j);
                String cellValue = getCellValueForStr(cell);
                switch ( j ){
                    case 0:
                        activity.setName(cellValue);
                        break;
                    case 1:
                        activity.setStartDate(cellValue);
                        break;
                    case 2:
                        activity.setEndDate(cellValue);
                        break;
                    case 3:
                        activity.setCost(cellValue);
                        break;
                    case 4:
                        activity.setDescription(cellValue);
                        break;
                    case 5:
                        activity.setCreateTime(cellValue);
                        break;
                }
            }
            activityList.add(activity);
        }
        return activityList;
    }

    /**
     * 将 HSSFCell 列中的数据，根据存储的数据类型获取并转换为字符串
     * @param cell
     * @return
     */
    public static String getCellValueForStr(HSSFCell cell){
        String str = "";
        if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING){
            // 字符串
            str = cell.getStringCellValue();
        }else if( cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
            // 数值型
            str = cell.getNumericCellValue()+"";
        }else if( cell.getCellType() == HSSFCell.CELL_TYPE_BOOLEAN ){
            // 布尔类型
            str = cell.getBooleanCellValue()+"";
        }else if( cell.getCellType() == HSSFCell.CELL_TYPE_FORMULA ){
            // 公式类型
            str = (cell.getCellFormula()+"");
        }else{
            // HSSFCell.CELL_TYPE_BLANK 空类型
            // HSSFCell.CELL_TYPE_ERROR 错误类型
        }
        return str;
    }

}
