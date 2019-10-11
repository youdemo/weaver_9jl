package com.higer.oa.common;

import org.apache.commons.lang.StringUtils;

import net.sf.json.JSONObject;

/**
 * 返回值工具类.
 *
 */
public class ReturnUtil {

    /**
     * 获取失败返回值(字符串类型).
     * 
     * @param errorMsg
     *            错误信息
     * @return 返回值
     */
    public static String getFailReturnStr(String errorMsg) {
        return getFailReturnJson(errorMsg).toString();
    }

    /**
     * 获取失败返回值(JSON类型).
     * 
     * @param errorMsg
     *            错误信息
     * @return 返回值
     */
    public static JSONObject getFailReturnJson(String errorMsg) {
        return getReturnJson(false, errorMsg, null);
    }

    /**
     * 获取成功返回值(字符串类型).
     * 
     * @param data
     *            数据
     * @return 返回值
     */
    public static String getSuccessReturnStr(Object data) {
        return getSuccessReturnJson(data).toString();
    }

    /**
     * 获取成功返回值(字符串类型).
     * 
     * @param data
     *            数据
     * @return 返回值
     */
    public static JSONObject getSuccessReturnJson(Object data) {
        return getReturnJson(true, "", data);
    }

    /**
     * 获取返回值(字符串类型).
     * 
     * @param success
     *            true:成功,false:失败
     * @param errorMsg
     *            错误信息
     * @param data
     *            数据
     * @return 返回值
     */
    public static String getReturnStr(boolean success, String errorMsg, Object data) {
        JSONObject returnJson = getReturnJson(success, errorMsg, data);
        return returnJson.toString();
    }

    /**
     * 获取返回值(JSON类型).
     * 
     * @param success
     *            true:成功,false:失败
     * @param errorMsg
     *            错误信息
     * @param data
     *            数据
     * @return 返回值
     */
    public static JSONObject getReturnJson(boolean success, String errorMsg, Object data) {
        JSONObject returnJson = new JSONObject();
        returnJson.put("success", success);
        if (StringUtils.isNotBlank(errorMsg)) {
            returnJson.put("msg", errorMsg);
        }
        if (data != null) {
            returnJson.put("data", data);
        }
        return returnJson;
    }

    /**
     * 获取失败返回信息.
     * 
     * @param errorMsg
     *            错误信息
     * @param resultCode
     *            返回代码
     * @return 返回值
     */
    public static String getFailReturnStr(String errorMsg, String resultCode) {
        JSONObject retrunJson = ReturnUtil.getFailReturnJson(errorMsg);
        retrunJson.put("resultCode", resultCode);
        return retrunJson.toString();
    }

    /**
     * 获取成功返回信息.
     * 
     * @param data
     *            数据
     * @param resultCode
     *            返回代码
     * @return 返回值
     */
    public static String getSuccessReturnStr(Object data, String resultCode) {
        JSONObject retrunJson = ReturnUtil.getSuccessReturnJson(data);
        retrunJson.put("resultCode", resultCode);
        return retrunJson.toString();
    }
}
