package com.higer.oa.workflow.dao;

import java.util.HashMap;
import java.util.Map;

import org.apache.log4j.Logger;

import weaver.conn.RecordSet;
import weaver.general.Util;

public class UpdateDocNameForGWFBDao {
	 /**
     * 日志.
     */
   // private static Logger LOGGER = Logger.getLogger(UpdateDocNameForGWFBDao.class);

    /**
     * RecordSet.
     */
    private RecordSet rs;

    
    /**
     	* 构造方法.
     */
    public UpdateDocNameForGWFBDao() {
        rs = new RecordSet();
    }
    /**
     	*  根据workflowid获取表名
     * @param workflowid workflowid
     * @return
     */
    public String getWorkflowTableNameById(String workflowid) {
        rs.execute("select tablename from workflow_bill where id=(select formid from workflow_base where id=" + workflowid + ")");
        if (rs.next()) {
            return Util.null2String(rs.getString("tablename"));
        }
        return "";
    }
    /**
     * 获取流程主表数据
     * @param requestid
     * @param tableName
     * @return
     */
    public Map<String,String> getMainInfo(String requestid,String tableName) {
    	Map<String,String> map = new HashMap<String,String>();
        rs.execute("select official_doc_name,fblx1,official_doc_attachment from " + tableName + " where requestid = " + requestid);
        if (rs.next()) {
        	map.put("official_doc_name", Util.null2String(rs.getString("official_doc_name")));
        	map.put("fblx1", Util.null2String(rs.getString("fblx1")));
        	map.put("official_doc_attachment", Util.null2String(rs.getString("official_doc_attachment")));
        }
        return map;
    }
    
    public String getSelectValue(String fieldName,String fieldValue,String tableName) {
    	String selectValue = "";
        rs.execute("select selectname from workflow_billfield a, workflow_bill b,workflow_selectitem c where a.billid=b.id and c.fieldid=a.id  and b.tablename='"+tableName+"' and a.fieldname='"+fieldName+"' and c.selectvalue='"+fieldValue+"' and cancel=0");
        if (rs.next()) {
        	selectValue = Util.null2String(rs.getString("selectname"));
        }
        return selectValue;
    }
    
    public void updateDocName(String newname,String docids) {
        rs.execute("update docdetail set docsubject='"+newname+"' where id in("+docids+")");       
    }
    
    
}
