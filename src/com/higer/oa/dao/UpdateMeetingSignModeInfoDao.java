package com.higer.oa.dao;

import java.util.ArrayList;
import java.util.List;

import weaver.conn.RecordSet;
import weaver.general.Util;

public class UpdateMeetingSignModeInfoDao {
	 /**
     * 日志.
     */
   // private static Logger LOGGER = Logger.getLogger(UpdateMeetingSignModeInfoDao.class);

    /**
     * RecordSet.
     */
    private RecordSet rs;

    
    /**
     	* 构造方法.
     */
    public UpdateMeetingSignModeInfoDao() {
        rs = new RecordSet();
    }
    /**
     * 获取待处理列表
     * @return
     */
    public List<String> getDelMeetingIdList() {
    	List<String> mtList = new ArrayList<String>();
    	String sql = "select distinct hyid from uf_meeting_change where sfcl='0' and lx='0'";
    	rs.execute(sql);
    	while(rs.next()) {
    		mtList.add(Util.null2String(rs.getString("hyid")));
    	}
    	return mtList;
    }
    /**
     * 更新变革中间表状态
     * @return
     */
    public List<String> getUpdateMeetingIdList() {
    	List<String> mtList = new ArrayList<String>();
    	String sql = "select distinct hyid from uf_meeting_change where sfcl='0' and lx='1'";
    	rs.execute(sql);
    	while(rs.next()) {
    		mtList.add(Util.null2String(rs.getString("hyid")));
    	}
    	return mtList;
    }
    /**
     * 删除会议建模数据
     * @param mtid
     */
    public void delMeetingData(String mtid) {
    	rs.execute("delete from uf_qdym_dt1 where mainid in(select id from uf_qdym where hymc='"+mtid+"')");
    	rs.execute("delete from uf_qdym where hymc='"+mtid+"'");
    	rs.execute("delete from formtable_main_89_dt2 where mainid in(select id from formtable_main_89 where hymc='"+mtid+"')");
    	rs.execute("delete from formtable_main_89_dt1 where mainid in(select id from formtable_main_89 where hymc='"+mtid+"')");
    	rs.execute("delete from formtable_main_89 where hymc='"+mtid+"'");
    	rs.execute("delete from formtable_main_103_dt1 where mainid in(select id from formtable_main_103 where hymc='"+mtid+"')");
    	rs.execute("delete from formtable_main_103 where hymc='"+mtid+"'");
    	rs.execute("delete from formtable_main_101_dt2 where mainid in(select id from formtable_main_101 where hymc='"+mtid+"')");
    	rs.execute("delete from formtable_main_101_dt1 where mainid in(select id from formtable_main_101 where hymc='"+mtid+"')");
    	rs.execute("delete from formtable_main_101 where hymc='"+mtid+"'");
    	rs.execute("update uf_meeting_change set sfcl='1' where hyid='"+mtid+"'");
    }
    /**
     * 更新会议建模数据
     * @param mtid
     */
    public void UpdateMeetingData(String mtid) {
    	rs.execute("update uf_qdym a set (hydd,kssj,jssj,chry,ksrq,kssj1) =(select address,begindate||' '||begintime,enddate||' '||endtime,hrmmembers,begindaupdate formtable_main_89 a set (hydd,kssj,jssj) =(select address,begindate||' '||begintime,enddate||' '||endtime from meeting where id=a.hymc) where a.hymc='te,begintime from meeting where id=a.hymc) where a.hymc='"+mtid+"'");
    	rs.execute(""+mtid+"'");
    	rs.execute("update formtable_main_103 a set (hydd,kssj,jssj,chry,ksrq,kssj1) =(select address,begindate||' '||begintime,enddate||' '||endtime,hrmmembers,begindate,begintime from meeting where id=a.hymc) where a.hymc='"+mtid+"'");
    	rs.execute("update formtable_main_101 a set (hydd,kssj,jssj) =(select address,begindate||' '||begintime,enddate||' '||endtime from meeting where id=a.hymc) where a.hymc='"+mtid+"'");
    	rs.execute("update uf_meeting_change set sfcl='1' where hyid='"+mtid+"'");
    }
    
    
}
