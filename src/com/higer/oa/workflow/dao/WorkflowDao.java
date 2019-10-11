package com.higer.oa.workflow.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import weaver.conn.RecordSet;

/**
 * 流程DAO.
 */
public class WorkflowDao {

    /**
     * 日志.
     */
    private static Logger LOGGER = Logger.getLogger(WorkflowDao.class);

    /**
     * RecordSet.
     */
    private RecordSet rs;

    /**
     * SQL_查询流程信息.
     */
    private static final String SQL_QRY_WORKFLOW = "select id, workflowname, workflowdesc from workflow_base ";

    /**
     * SQL_查询流程信息（BY 标识）.
     */
    private static final String SQL_QRY_WORKFLOW_IDENTITY = "select a.id, a.workflowname, a.workflowdesc from workflow_base a ,uf_wfIdentity b where a.id = b.wfBaseId ";

    /**
     * SQL_查询用户信息.
     */
    private static final String SQL_QRY_HRMRESOURCE = "select id,loginid,lastname,status from hrmresource ";

    /**
     * 构造方法.
     */
    public WorkflowDao() {
        rs = new RecordSet();
    }

    /**
     * 依据流程ID查询流程信息.
     * 
     * @param id
     *            流程ID
     * @return 流程信息（id:ID,workflowName:名称,workflowDesc:描述）
     */
    public Map getWorkflowById(String id) {
        rs.executeSql(SQL_QRY_WORKFLOW + " where id = " + id);
        if (rs.next()) {
            return rsToWorkflowInfoMap();
        }
        return null;
    }

    /**
     * 依据流程名称查询流程信息.
     * 
     * @param workflowname
     *            流程名称
     * @return 流程信息（id:ID,workflowName:名称,workflowDesc:描述）
     */
    public List getWorkflowByName(String workflowname) {
        List workflowList = new ArrayList();
        rs.executeSql(SQL_QRY_WORKFLOW + " where workflowname = '" + workflowname + "'");
        while (rs.next()) {
            workflowList.add(rsToWorkflowInfoMap());
        }
        return workflowList;
    }

    /**
     * 将结果集转成流程信息MAP.
     * 
     * @return 流程信息（id:ID,workflowName:名称,workflowDesc:描述）
     */
    private Map rsToWorkflowInfoMap() {
        Map workflowMap = new HashMap();
        workflowMap.put("id", rs.getInt("id"));
        workflowMap.put("workflowName", rs.getString("workflowname"));
        workflowMap.put("workflowDesc", rs.getString("workflowdesc"));
        return workflowMap;
    }

    /**
     * 依据流程标识查询流程信息.
     * 
     * @param identity
     *            流程标识
     * @return 流程信息（id:ID,workflowName:名称,workflowDesc:描述）
     */
    public List getWorkflowByIdentity(String identity) {
        List workflowList = new ArrayList();
        rs.executeSql(SQL_QRY_WORKFLOW_IDENTITY + " and  b.wfIdentity = '" + identity + "'");
        while (rs.next()) {
            workflowList.add(rsToWorkflowInfoMap());
        }
        return workflowList;
    }

    /**
     * 依据用户ID查询用户信息.
     * 
     * @param id
     *            用户ID
     * @return 用户信息(id:ID,loginId:登录账号,lastName:名称,status:状态)
     */
    public Map getUserById(String id) {
        rs.executeSql(SQL_QRY_HRMRESOURCE + " where id = " + id + " and status in(0,1,2,3)");
        if (rs.next()) {
            return rsToUserInfoMap();
        }
        return null;
    }

    /**
     * 将结果集转换成用户信息Map.
     * 
     * @return 用户信息(id:ID,loginId:登录账号,lastName:名称,status:状态)
     */
    private Map rsToUserInfoMap() {
        Map userMap = new HashMap();
        userMap.put("id", rs.getInt("id"));
        userMap.put("loginId", rs.getString("loginid"));
        userMap.put("lastName", rs.getString("lastname"));
        userMap.put("status", rs.getInt("status"));
        return userMap;
    }

    /**
     * 依据用户登录账号查询用户信息.
     * 
     * @param loginid
     *            登录账号
     * @return 用户信息(id:ID,loginId:登录账号,lastName:名称,status:状态)
     */
    public Map getUserByLoginId(String loginid) {
        rs.executeSql(SQL_QRY_HRMRESOURCE + " where loginid = '" + loginid + "' and status in(0,1,2,3)");
        if (rs.next()) {
            return rsToUserInfoMap();
        }
        return null;
    }
}
