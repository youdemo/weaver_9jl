package com.higer.oa.webservice;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;

import com.higer.oa.common.ReturnUtil;
import com.higer.oa.workflow.service.WorkflowService;

import net.sf.json.JSONObject;

/**
 * 流程Webservice实现类.
 *
 */
public class WorkflowWebServiceImpl implements IWorkflowWebService {

    /**
     * 日志.
     */
    private static Logger LOGGER = Logger.getLogger(WorkflowService.class);

    private JSONObject paramJson = new JSONObject();

    private boolean success = true;

    private String errorMsg = "";

    @Override
    public String createWorkflow(String workflowInfo) {
        String opName = "createWorkflow";
        logInfoParam(opName, workflowInfo);
        // 1.解析参数.
        parseParams(workflowInfo);
        if (!isSuccess()) {
            // 参数解析失败,直接返回创建失败.
            String result = ReturnUtil.getFailReturnStr(getErrorMsg(), "0");
            logInfoResult(opName, result);
            return result;
        }
        // 2.创建流程.
        return new WorkflowService().createWorkflow(paramJson.getString("workflow"), workflowInfo,
                paramJson.getString("creator"), paramJson.getString("isNext"));
    }

    /**
     * 解析参数.
     * 
     * @param workflowInfo
     *            流程信息
     */
    private void parseParams(String workflowInfo) {
        JSONObject paramJson = JSONObject.fromObject(workflowInfo);
        if (isBlank(paramJson, "workflow")) {
            setFail("没有指定流程");
        }
        if (isBlank(paramJson, "creator")) {
            setFail("没有指定创建人");
        }
        if (isBlank(paramJson, "isNext")) {
            paramJson.put("isNext", "0");
        }
        this.paramJson = paramJson;
    }

    /**
     * 为空.
     * 
     * @param paramJson
     *            JSON
     * @param key
     *            键
     * @return true:为空,false:不为空
     */
    private boolean isBlank(JSONObject paramJson, String key) {
        return !paramJson.containsKey(key) || StringUtils.isBlank(paramJson.getString(key));
    }

    /**
     * 设置错误信息.
     * 
     * @param errorMsg
     *            错误信息.
     */
    private void setFail(String errorMsg) {
        setSuccess(false);
        setErrorMsg(errorMsg);
    }

    /**
     * 记录操作入口Info日志.
     * 
     * @param opName
     *            操作名称
     * @param result
     *            结果
     */
    private void logInfoParam(String opName, String params) {
        LOGGER.info("start " + opName + "...");
        LOGGER.info("params:" + params);
    }

    /**
     * 记录操作结果Info日志.
     * 
     * @param opName
     *            操作名称
     * @param result
     *            结果
     */
    private void logInfoResult(String opName, String result) {
        LOGGER.info(opName + " end");
        LOGGER.info("result:" + result);
    }

    public String getErrorMsg() {
        return errorMsg;
    }

    private void setErrorMsg(String errorMsg) {
        this.errorMsg = errorMsg;
    }

    public boolean isSuccess() {
        return success;
    }

    private void setSuccess(boolean success) {
        this.success = success;
    }
}
