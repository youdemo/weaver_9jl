package com.higer.oa.workflow.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import weaver.conn.RecordSet;
import weaver.general.Util;

public class UpdateMeetingAgendaStatusDao {
	 /**
     * 日志.
     */
    //private static Logger LOGGER = Logger.getLogger(UpdateMeetingAgendaStatusDao.class);

    /**
     * RecordSet.
     */
    private RecordSet rs;

    
    /**
     	* 构造方法.
     */
    public UpdateMeetingAgendaStatusDao() {
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
        rs.execute("select glyc,id from " + tableName + " where requestid = " + requestid);
        if (rs.next()) {
        	map.put("glyc", Util.null2String(rs.getString("glyc")));
        	map.put("mainId", Util.null2String(rs.getString("id")));
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
    /**
     * 获取已议议程的议题
     * @param glyc议程id
     * @param ycids 议程明细id
     * @return
     */
    public List<Map<String,String>> getGLYt(String glyc,String ycids) {
    	List<Map<String,String>> list = new ArrayList<Map<String,String>>();
        rs.execute("select ytgl from uf_hyyc_dt1 where mainid="+glyc+" and id in("+ycids+")");
        while (rs.next()) {
        	Map<String,String> map = new HashMap<String,String>();
			map.put("ytgl", Util.null2String(rs.getString("ytgl")));
        	list.add(map);
        }
        return list;
    }
    /**
     * 获取未议议程的议题
     * @param glyc议程id
     * @param ycids 议程明细id
     * @return
     */
    public List<Map<String,String>> getWGLYt(String glyc,String ycids) {
    	List<Map<String,String>> list = new ArrayList<Map<String,String>>();
        rs.execute("select ytgl from uf_hyyc_dt1 where mainid="+glyc+" and id not in("+ycids+")");
        while (rs.next()) {
        	Map<String,String> map = new HashMap<String,String>();
        	map.put("ytgl", Util.null2String(rs.getString("ytgl")));
        	list.add(map);
        }
        return list;
    }
    /**
     * 更新会议关联的议程状态
     * @param glyc 议程id
     * @param ycids 议程明细id
     */
    public void UpdateAgendaStatus(String glyc,String ycids) {
    	rs.execute("update uf_hyyc set zzbs_new = '0' where id="+glyc);
    	rs.execute("update uf_hyyc_dt1 set zt = '0' where mainid="+glyc+" and id in("+ycids+")");
    	rs.execute("update uf_hyyc_dt1 set zt = '1' where mainid="+glyc+" and id not in("+ycids+")");
    }
    /**
     * 更新议题转台
     * @param ytids 议题id
     * @param status 0已议 1未议
     */
    public void UpdateYtStatus(String ytids,String status) {
    	rs.execute("update uf_hyytsj_dt1 set zt = '"+status+"' where id in("+ytids+")");
    }
    
}
