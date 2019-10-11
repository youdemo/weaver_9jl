package com.higer.oa.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import weaver.conn.RecordSet;
import weaver.general.BaseBean;
import weaver.general.Util;

public class UpdateDocStatusForGWFBDao {
	
    /**
     * RecordSet.
     */
    private RecordSet rs;

    
    /**
     	* 构造方法.
     */
    public UpdateDocStatusForGWFBDao() {
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
    	 rs.execute("select official_doc_name,fblx1,official_doc_attachment,zwfj,zw from " + tableName + " where requestid = " + requestid);
         if (rs.next()) {
         	map.put("official_doc_name", Util.null2String(rs.getString("official_doc_name")));
         	map.put("fblx1", Util.null2String(rs.getString("fblx1")));
         	map.put("official_doc_attachment", Util.null2String(rs.getString("official_doc_attachment")));
         	map.put("zwfj", Util.null2String(rs.getString("zwfj")));
         	map.put("zw", Util.null2String(rs.getString("zw")));
         }
        return map;
    }
    /**
     * 获取流程明细数据
     * @param mainId 主表数据id
     * @param tableName 明细表名
     * @return
     */
    public List<Map<String,String>> getDetailInfo(String mainId,String tableName) {
    	List<Map<String,String>> list = new ArrayList<Map<String,String>>();
        rs.execute("select mxid from "+tableName+" where mainid="+mainId);
        while (rs.next()) {
        	Map<String,String> map = new HashMap<String,String>();
        	map.put("mxid", Util.null2String(rs.getString("mxid")));
        	list.add(map);
        }
        return list;
    }
    
    
    
    public void UpdateStatus(String docid) {
    	rs.execute("update docdetail set docstatus='1' where id="+docid); 
    }
	
	
	
	
	private void writeLog(Object obj) {
	    if (true) {
	      new BaseBean().writeLog(this.getClass().getName(), obj);
	    }
	}
}
