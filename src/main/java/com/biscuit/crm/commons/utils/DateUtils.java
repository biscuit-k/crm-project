package com.biscuit.crm.commons.utils;

import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * 专门用于对日期数据进行处理的工具类
 */
public class DateUtils {

    /**
     * 对指定的 Date 日期对象，进行格式化：yyyy-MM-dd HH:mm:ss
     * @param date
     * @return
     */
    public static String formateDateTime(Date date){
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String dateStr = sdf.format(date); // 当前时间的字符串格式
        return dateStr;
    }

    /**
     * 对指定的 Date 日期对象，进行格式化：yyyy-MM-dd
     * @param date
     * @return
     */
    public static String formateDate(Date date){
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        String dateStr = sdf.format(date); // 当前时间的字符串格式
        return dateStr;
    }

    /**
     * 对指定的 Date 日期对象，进行格式化：HH:mm:ss
     * @param date
     * @return
     */
    public static String formateTime(Date date){
        SimpleDateFormat sdf = new SimpleDateFormat("HH:mm:ss");
        String dateStr = sdf.format(date); // 当前时间的字符串格式
        return dateStr;
    }
}
