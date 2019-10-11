package com.higer.oa.dao.portal;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import weaver.conn.RecordSet;
import weaver.general.Util;

public class GetOAProcessListDao {
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
    public GetOAProcessListDao() {
        rs = new RecordSet();
    }
   
    public List<Map<String,String>> getList(String userid){
    	List<Map<String,String>> list = new ArrayList<Map<String,String>>();
    	if("".equals(userid)) {
    		return list;
    	}
    	rs.execute("select * from (select a.name,b.subject,b.begindate,b.enddate,b.id,b.prjid from Prj_ProjectInfo a,Prj_TaskProcess b where a.id=b.prjid and a.status=1 and b.rwzz=9 and hrmid='"+userid+"' order by enddate asc) a where rownum<=10");
    	while(rs.next()) {
    		Map<String,String> map = new HashMap<String,String>();
    		map.put("name", Util.null2String(rs.getString("name")));
    		map.put("subject", Util.null2String(rs.getString("subject")));
    		map.put("begindate", Util.null2String(rs.getString("begindate")));
    		map.put("enddate", Util.null2String(rs.getString("enddate")));
    		map.put("id", Util.null2String(rs.getString("id")));
    		map.put("prjid", Util.null2String(rs.getString("prjid")));
    		list.add(map);
    	}
    	return list;
    }
    
    public String getDayBetween(String nowDate,String endDate) {
    	String type = "";
    	int daynum = 0;
    	rs.execute("select to_date('"+endDate+"','yyyy-mm-dd')- to_date('"+nowDate+"','yyyy-mm-dd') as daynum from dual");
    	if(rs.next()) {
    		daynum = rs.getInt("daynum");
    	}
    	if(daynum<0) {
    		type = "2";//红色
    	}else if(daynum<=2) {
    		type = "1";//绿色
    	}else {
    		type = "0";//正常
    	}
    	return type;
    }
    
}
