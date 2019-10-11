package com.higer.oa.workflow.service;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;

import com.higer.oa.common.ReturnUtil;
import com.higer.oa.workflow.dao.WorkflowDao;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import weaver.soa.workflow.request.Cell;
import weaver.soa.workflow.request.DetailTable;
import weaver.soa.workflow.request.DetailTableInfo;
import weaver.soa.workflow.request.MainTableInfo;
import weaver.soa.workflow.request.Property;
import weaver.soa.workflow.request.RequestInfo;
import weaver.soa.workflow.request.RequestService;
import weaver.soa.workflow.request.Row;

/**
 * 流程服务类.
 */
public class WorkflowService {

    /**
     * 日志.
     */
    private static Logger LOGGER = Logger.getLogger(WorkflowService.class);

    /**
     * 明细表信息key，前缀.
     */
    private static final String DETAIL_TABLE_INFO_KEY_PREFIX = "dt";

    /**
     * 错误信息.
     */
    private static final JSONObject ERROR_CODE_JSON = new JSONObject();

    /**
     * 默认错误日志.
     */
    private static final String DEFAULT_ERROR_MSG = "创建流程失败,详细请参见OA错误代码及后台日志";

    static {
        ERROR_CODE_JSON.put("-2", "用户没有流程创建权限");
        ERROR_CODE_JSON.put("-3", "创建流程基本信息失败");
        ERROR_CODE_JSON.put("-4", "保存表单主表信息失败");
        ERROR_CODE_JSON.put("-5", "更新紧急程度失败");
        ERROR_CODE_JSON.put("-6", "流程操作者失败");
        ERROR_CODE_JSON.put("-7", "流转至下一节点失败");
        ERROR_CODE_JSON.put("-8", "节点附加操作失败");
    }

    /**
     * 错误信息.
     */
    private String errorMsg = "";

    /**
     * 日志代码.
     */
    private String logCode = "";

    /**
     * 创建流程主方法
     * 
     * @param identity
     *            流程标识
     * @param datas
     *            格式说明 ： {"detailDatas" : { "dt1" : [{ "b1" : "2", "a1" : "1" },
     *            { "b2" : "22", "a2" : "12" } ], "dt2" : [{ "b2" : "22", "a2" :
     *            "11" } ] }, "mainTableData" : { "aa" : "aa2", "bb" : "bb2" } }
     *            <br />
     *            <li>detailDatas : 明细表数据</li><br />
     *            <li>dt1 :第一个明细表(必须以dt开头,且后面的数字必须连续)</li><br />
     *            <li>b1: 明细表的字段名称</li><br />
     *            <li>2: 字段b1的值.</li><br />
     *            <li>dt2:第二个明细表</li><br />
     *            <li>mainTableData:主表数据</li><br />
     *            <li>aa: 主表的字段名称</li><br />
     *            <li>aa2：字段aa2的值</li><br />
     * @param creator
     *            流程创建人登录账号(loginId)
     * @param isNext
     *            是否流转到下一节点 1 是 0 不是(默认)
     * @return
     */
    public String createWorkflow(String identity, String datas, String creator, String isNext) {

        try {
            WorkflowDao dao = new WorkflowDao();
            // 1.流程ID不存在，则直接返回失败.
            List workflowList = dao.getWorkflowByIdentity(identity);
            if (workflowList == null || workflowList.size() == 0) {
                return ReturnUtil.getFailReturnStr("流程不存在，请确认流程标识存在！", "0");
            }
            if (workflowList.size() > 1) {
                return ReturnUtil.getFailReturnStr("流程标识不唯一，请确认！", "0");
            }
            // 2.创建人ID不存在，则直接返回失败.
            Map userInfoMap = dao.getUserByLoginId(creator);
            if (userInfoMap == null || userInfoMap.isEmpty()) {
                return ReturnUtil.getFailReturnStr("创建人不存在或已失效，请确认创建人账号是否正确！", "0");
            }
            logCode = creator + identity + "_" + System.currentTimeMillis();
            // 3.创建请求信息（设置主表信息和明细表信息.）
            JSONObject infoJson = JSONObject.fromObject(datas);
            RequestInfo reqInfo = createReqInfo(infoJson);
            if (StringUtils.isNotBlank(errorMsg)) {
                return ReturnUtil.getFailReturnStr(errorMsg, "0");
            }
            if (reqInfo == null) {
                return ReturnUtil.getFailReturnStr("主、明细表信息设置错误，详细请参见后台日志", "0");
            }

            // 4.设置请求相关信息.
            if (!"1".equals(isNext)) {
                reqInfo.setIsNextFlow("0");
            } else {
                reqInfo.setIsNextFlow("1");
            }
            reqInfo.setCreatorid(String.valueOf(userInfoMap.get("id")));
            // 标题.
            if (infoJson.containsKey("title")) {
                reqInfo.setDescription(infoJson.getString("title"));
            } else {
                reqInfo.setDescription(getReqDesc((String) ((Map) workflowList.get(0)).get("workflowName"),
                        (String) userInfoMap.get("lastName")));
            }
            reqInfo.setWorkflowid(String.valueOf(((Map) workflowList.get(0)).get("id")));
            if (infoJson.containsKey("requestlevel")) {
                reqInfo.setRequestlevel(infoJson.getString("requestlevel"));
            } else {
                reqInfo.setRequestlevel("0");
            }
            if (infoJson.containsKey("remindtype")) {
                reqInfo.setRemindtype(infoJson.getString("remindtype"));
            } else {
                reqInfo.setRemindtype("0");
            }
            RequestService reqService = new RequestService();

            // 5. 创建流程
            String resultCode = reqService.createRequest(reqInfo);
            if (Integer.parseInt(resultCode) < 1) {
                return ReturnUtil.getFailReturnStr(getErrorMsg(resultCode), resultCode);
            }
            return ReturnUtil.getSuccessReturnStr("流程创建成功", resultCode);
        } catch (Exception e) {
            LOGGER.error(logCode + " : ", e);
        }
        return ReturnUtil.getFailReturnStr("流程创建失败,详细请参见日志,日志代码：" + logCode, "0");
    }

    /**
     * 创建请求信息.
     * 
     * @param infoJson
     *            主、明细表中的信息.
     * @return
     */
    private RequestInfo createReqInfo(JSONObject infoJson) {
        RequestInfo reqInfo = new RequestInfo();
        MainTableInfo mainTableInfo = getMainTableInfo(infoJson);
        if (StringUtils.isNotBlank(errorMsg)) {
            return null;
        }
        DetailTableInfo detailTableInfo = getDetailTableInfo(infoJson);
        if (StringUtils.isNotBlank(errorMsg)) {
            return null;
        }
        if (detailTableInfo != null) {
            reqInfo.setDetailTableInfo(detailTableInfo);
        }
        reqInfo.setMainTableInfo(mainTableInfo);
        return reqInfo;
    }

    /**
     * 解析明细表信息.
     * 
     * @param paramJson
     *            参数信息.
     * @return 明细表对象.
     */
    private DetailTableInfo getDetailTableInfo(JSONObject paramJson) {
        if (!paramJson.containsKey("detailDatas")) {
            return null;
        }
        JSONObject detailDataJson = paramJson.getJSONObject("detailDatas");
        if (detailDataJson == null || detailDataJson.isNullObject() || detailDataJson.isEmpty()) {
            return null;
        }
        DetailTableInfo detailTableInfo = new DetailTableInfo();
        List detailInfoList = new ArrayList();
        int detailTableLen = detailDataJson.keySet().size();
        for (int j = 1; j <= detailTableLen; j++) { // 遍历明细表
            JSONArray tableColArray = null;
            try {
                tableColArray = detailDataJson.getJSONArray(DETAIL_TABLE_INFO_KEY_PREFIX + j);
            } catch (Exception e) {
                continue;
            }
            List rowInfoList = new ArrayList();
            DetailTable dtInfo = new DetailTable();
            for (int rowIndex = 0; rowIndex < tableColArray.size(); rowIndex++) { // 遍历明细表的行.
                JSONObject rowInfoJson = tableColArray.getJSONObject(rowIndex);
                Row rowInfo = new Row();
                List cellInfoList = new ArrayList();
                Iterator it = rowInfoJson.keys();
                while (it.hasNext()) { // 遍历行的列.
                    String colName = it.next().toString();
                    String colValue = rowInfoJson.getString(colName);
                    Cell cellInfo = new Cell();
                    cellInfo.setName(colName);
                    if (StringUtils.isNotBlank(colValue)) {
                        cellInfo.setValue(colValue);
                        cellInfoList.add(cellInfo);
                    }
                }
                // 各列数据转化成数组.
                int celSize = cellInfoList.size();
                Cell cells[] = new Cell[celSize];
                for (int index = 0; index < celSize; index++) {
                    cells[index] = (Cell) cellInfoList.get(index);
                }
                rowInfo.setCell(cells);
                rowInfo.setId("" + rowIndex);
                rowInfoList.add(rowInfo);
            }
            // 各行数据转化成数组.
            int rowSize = rowInfoList.size();
            Row rows[] = new Row[rowSize];
            for (int index = 0; index < rowSize; index++) {
                rows[index] = (Row) rowInfoList.get(index);
            }
            dtInfo.setRow(rows);
            dtInfo.setId("" + j);
            detailInfoList.add(dtInfo);
        }
        int tabSize = detailInfoList.size();
        DetailTable detailtables[] = new DetailTable[tabSize];
        for (int index = 0; index < tabSize; index++) {
            detailtables[index] = (DetailTable) detailInfoList.get(index);
        }
        detailTableInfo.setDetailTable(detailtables);
        return detailTableInfo;
    }

    /**
     * 解析主表信息.
     * 
     * @param paramJson
     *            参数信息.
     * @return 主表对象.
     */
    private MainTableInfo getMainTableInfo(JSONObject paramJson) {
        if (!paramJson.containsKey("mainTableData")) {
            this.errorMsg = "没有主表信息，请设置主表信息";
            return null;
        }
        JSONObject mainTableDataJson = paramJson.getJSONObject("mainTableData");
        if (mainTableDataJson == null || mainTableDataJson.isNullObject() || mainTableDataJson.isEmpty()) {
            this.errorMsg = "没有主表信息，请设置主表信息";
            return null;
        }
        MainTableInfo mainTableInfo = new MainTableInfo();
        Iterator it = mainTableDataJson.keys();
        List rowInfoList = new ArrayList();
        while (it.hasNext()) {
            String key = it.next().toString();
            String value = mainTableDataJson.getString(key);
            Property pro = new Property();
            pro.setName(key);
            if (StringUtils.isNotBlank(value)) {
                pro.setValue(value);
                rowInfoList.add(pro);
            }
        }
        int rowSize = rowInfoList.size();
        if (rowSize == 0) {
            this.errorMsg = "主表没有任何值，请设置主表信息";
            return null;
        }
        Property properties[] = new Property[rowSize];
        for (int index = 0; index < rowSize; index++) {
            properties[index] = (Property) rowInfoList.get(index);
        }
        mainTableInfo.setProperty(properties);
        return mainTableInfo;
    }

    /**
     * 请求描述(标题:流程名称-创建人名称-创建日期(yyyy-MM-dd)).
     * 
     * @param workflowName
     *            流程名称.
     * @param creator
     *            创建人名称.
     * @return 请求描述
     */
    private String getReqDesc(String workflowName, String creator) {
        return workflowName + "-" + creator + "-" + new SimpleDateFormat("yyyy-MM-dd").format(new Date());
    }

    /**
     * 依据返回代码获取对应的错误信息.
     * 
     * @param resultCode
     *            返回代码
     * @return 错误信息
     */
    private String getErrorMsg(String resultCode) {
        if (!ERROR_CODE_JSON.containsKey(resultCode)) {
            return DEFAULT_ERROR_MSG;
        }
        return ERROR_CODE_JSON.getString(resultCode);
    }

}
