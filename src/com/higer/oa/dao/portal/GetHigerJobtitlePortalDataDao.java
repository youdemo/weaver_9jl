package com.higer.oa.dao.portal;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import weaver.conn.RecordSet;
import weaver.conn.RecordSetDataSource;
import weaver.general.Util;

public class GetHigerJobtitlePortalDataDao {
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
    public GetHigerJobtitlePortalDataDao() {
        rs = new RecordSet();
    }
    /**
     * 项目管理我的任务列表数据获取
     * @param loginid
     * @return
     */
    public List<Map<String,String>> getDataListForPrj(String loginid){
    	RecordSetDataSource rsd = new RecordSetDataSource("basdb_higerprj");
    	List<Map<String,String>> list = new ArrayList<Map<String,String>>();
    	if("".equals(loginid)) {
    		return list;
    	}
    	int count =1;
    	rsd.execute("select task_owner,task_id,task_start_date,task_end_date,task_name,proj_name,url from prj_klsz_task_detail_v where task_owner='"+loginid+"' and task_owner <> '' order by task_end_date asc");
    	while(rsd.next()) {
    		if(count >=10) {
    			break;
    		}
    		Map<String,String> map = new HashMap<String,String>();
    		map.put("task_start_date", Util.null2String(rsd.getString("task_start_date")));
    		map.put("task_end_date", Util.null2String(rsd.getString("task_end_date")));
    		map.put("task_name", Util.null2String(rsd.getString("task_name")));
    		map.put("proj_name", Util.null2String(rsd.getString("proj_name")));
    		map.put("url", Util.null2String(rsd.getString("url")));
    		list.add(map);
    		count ++;
    	}
    	return list;
    }
    /**
     * 会议数据获取
     * @param userid
     * @return
     */
    public List<Map<String,String>> getDataListForMeeting(String userid){
    	List<Map<String,String>> list = new ArrayList<Map<String,String>>();
    	if("".equals(userid)) {
    		return list;
    	}
    	String address = "";//会议地点
    	rs.execute(" select * from (select id,name,(select name from meetingroom where id =address) as address,customizeaddress,begindate||' '||begintime||' - '||enddate||' '||endtime as range from meeting where meetingstatus=2 and enddate||' '||endtime>=to_char(sysdate,'yyyy-mm-dd hh24:mi') and (dbms_lob.instr(','||hrmmembers||',',',"+userid+",')>0 or caller='"+userid+"' or contacter='"+userid+"') order by begindate||' '||begintime) where rownum<=10 ");
    	while(rs.next()) {
    		Map<String,String> map = new HashMap<String,String>();
    		map.put("meetingid", Util.null2String(rs.getString("id")));
    		map.put("name", Util.null2String(rs.getString("name")));		
    		map.put("range", Util.null2String(rs.getString("range")));
    		address = Util.null2String(rs.getString("address"));
    		if("".equals(address)) {
    			address = Util.null2String(rs.getString("customizeaddress"));
    		}
    		map.put("address", Util.null2String(rs.getString("address")));
    		list.add(map);
    	}
    	return list;
    }
    
    /**
     * 督办数据获取
     * @param userid
     * @return
     */
    public List<Map<String,String>> getDataListForGovern(String userid){
    	List<Map<String,String>> list = new ArrayList<Map<String,String>>();
    	if("".equals(userid)) {
    		return list;
    	}
    	rs.execute("select * from (select id,name,creater,(select lastname from hrmresource where id=t.creater) as lastname,startdate||' - '||enddate as range from govern_task t where tasktype=0 and status in (1,2) and responsible ="+userid+" order by startdate ) where rownum<=10");
    	while(rs.next()) {
    		Map<String,String> map = new HashMap<String,String>();
    		map.put("governid", Util.null2String(rs.getString("id")));
    		map.put("name", Util.null2String(rs.getString("name")));	
    		map.put("creater", Util.null2String(rs.getString("creater")));
    		if("1".equals(Util.null2String(rs.getString("creater")))) {
    			map.put("creatername", "系统管理员");
    		}else {
    			map.put("creatername", Util.null2String(rs.getString("lastname")));
    		}	
    		map.put("range", Util.null2String(rs.getString("range")));
    		list.add(map);
    	}
    	return list;
    }
    /**
     * 根据用户id获取登陆账号
     * @param userid
     * @return
     */
    public String getLoginid(String userid) {
    	String loginid = "";
    	if("".equals(userid)) {
    		return "";
    	}
    	rs.execute("select loginid from hrmresource where id="+userid);
    	if(rs.next()) {
    		loginid = Util.null2String(rs.getString("loginid"));
    	}
    	return loginid;
    }
    /**
     * 获取oa任务数量
     * @param userid
     * @return
     */
    public int getOaJobCount(String userid) {
    	int count=0;
    	if("".equals(userid)) {
    		return 0;
    	}
    	rs.execute("select count(b.id) as oajobcount from Prj_ProjectInfo a,Prj_TaskProcess b where a.id=b.prjid and a.status=1 and b.rwzz=9 and hrmid='"+userid+"'");
    	if(rs.next()) {
    		count = rs.getInt("oajobcount");
    	}
    	return count;
    }
    
    /**
     * 获取项目管理任务数量
     * @param loginid
     * @return
     */
    public int getPrjJobCount(String loginid) {
    	int count=0;
    	if("".equals(loginid)) {
    		return 0;
    	}
    	RecordSetDataSource rsd = new RecordSetDataSource("basdb_higerprj");
		String sql = "select count(1) as pjobcount from prj_klsz_task_detail_v where task_owner='"+loginid+"' and task_owner <> ''";
		rsd.execute(sql);
        if(rsd.next()){
        	count = rsd.getInt("pjobcount");
        }
    	return count;
    }
    /**
     * 获取oa待办数量
     * @param userid
     * @return
     */
    public int getOaTodoCount(String userid) {
    	int count=0;
    	if("".equals(userid)) {
    		return 0;
    	}
    	String sql = " select count( distinct t1.requestid) as toDoCount from workflow_requestbase t1 left join workflow_currentoperator t2 on t1.requestid=t2.requestid where (t1.deleted <> 1 or t1.deleted is null or t1.deleted = '') and t2.userid in ("+userid+") and t2.usertype = 0 and (t1.deleted = 0 or t1.deleted is null) and ((t2.isremark = 0 and (t2.takisremark is null or t2.takisremark = 0)) or t2.isremark in ('5', '7')) and (t1.deleted = 0 or t1.deleted is null) and t2.islasttimes = 1 and (nvl(t1.currentstatus, -1) = -1 or (nvl(t1.currentstatus, -1) = 0 and t1.creater in ("+userid+"))) and t1.workflowid in (select id from workflow_base where (isvalid = '1' or isvalid = '3')) ";
        rs.execute(sql);
        if(rs.next()){
        	count = rs.getInt("toDoCount");
		}
		sql = "select count(1) as count from ofs_todo_data where userid="+userid+" and isremark=0 and islasttimes='1'";
		rs.execute(sql);
        if(rs.next()){
        	count = count+rs.getInt("count");
		}
    	return count;
    }
    /**
     * 获取oa待办数量
     * @param userid
     * @return
     */
    public int getOaToReadCount(String userid) {
    	int count=0;
    	if("".equals(userid)) {
    		return 0;
    	}
    	String sql = " select count( distinct t1.requestid) as toReadCount from workflow_requestbase t1 left join workflow_currentoperator t2 on t1.requestid=t2.requestid where (t1.deleted <> 1 or t1.deleted is null or t1.deleted = '') and t2.userid in ("+userid+") and t2.usertype = 0 and (t1.deleted = 0 or t1.deleted is null) and (t2.isremark in ('1', '8','9')) and (t1.deleted = 0 or t1.deleted is null) and t2.islasttimes = 1 and (nvl(t1.currentstatus, -1) = -1 or (nvl(t1.currentstatus, -1) = 0 and t1.creater in ("+userid+"))) and t1.workflowid in (select id from workflow_base where (isvalid = '1' or isvalid = '3')) ";
		rs.execute(sql);
        if(rs.next()){
        	count = rs.getInt("toReadCount");
		}
    	return count;
    }
    /**
     * 获取我的会议数量
     * @param userid
     * @return
     */
    public int getMyMeetingCount(String userid) {
    	int count=0;
    	if("".equals(userid)) {
    		return 0;
    	}
    	String sql = " select  count(1) as myMeetCount from meeting where meetingstatus in (2) and enddate||' '||endtime>=to_char(sysdate,'yyyy-mm-dd hh24:mi') and (dbms_lob.instr(','||hrmmembers||',',',"+userid+",')>0 or caller='"+userid+"' or contacter='"+userid+"') ";
		rs.execute(sql);
		if(rs.next()){
			count = rs.getInt("myMeetCount");
		}
    	return count;
    }
    /**
     * 获取我的督办数量
     * @param userid
     * @return
     */
    public int getMyGovernCount(String userid) {
    	int count=0;
    	if("".equals(userid)) {
    		return 0;
    	}
    	String sql = " select count(1) as myGovernCount from govern_task where tasktype=0 and status in (1,2) and responsible ="+userid+"";
		rs.execute(sql);
		if(rs.next()){
			count = rs.getInt("myGovernCount");
		}
    	return count;
    }
    /**
     * 获取本月已办数量
     * @param userid
     * @return
     */
    public int getHaveToDoCount(String userid) {
    	int count=0;
    	if("".equals(userid)) {
    		return 0;
    	}
    	String sql = " select count(1) havaToDoCount from workflow_requestbase t1 left join workflow_currentoperator t2 on t1.requestid=t2.requestid where (t1.deleted <> 1 or t1.deleted is null or t1.deleted = '') and t2.userid in ("+userid+") and t2.usertype = 0 and (t1.deleted = 0 or t1.deleted is null) and ((t2.isremark = 0 and t2.takisremark = -2) or t2.isremark in ('2', '4')) and (t1.deleted = 0 or t1.deleted is null) and t2.islasttimes = 1 and (nvl(t1.currentstatus, -1) = -1 or (nvl(t1.currentstatus, -1) = 0 and t1.creater in ("+userid+"))) and t1.workflowid in (select id from workflow_base where (isvalid = '1' or isvalid = '3')) and to_char(to_date(operatedate,'yyyy-mm-dd'),'yyyy-mm') = to_char(sysdate,'yyyy-mm') ";
		rs.execute(sql);
		if(rs.next()){
			count = rs.getInt("havaToDoCount");
		}
		sql = " select count(1) as count from ofs_todo_data where userid="+userid+" and isremark in(2,4) and islasttimes='1' and to_char(to_date(operatedate,'yyyy-mm-dd'),'yyyy-mm') = to_char(sysdate,'yyyy-mm') ";
		rs.execute(sql);
		if(rs.next()){
			count = count+rs.getInt("count");
		}
    	return count;
    }
    /**
     * 获取本年已办数量
     * @param userid
     * @return
     */
    public int getHaveToDoCountYear(String userid) {
    	int count=0;
    	if("".equals(userid)) {
    		return 0;
    	}
    	String sql = " select count(1) havaToDoCount from workflow_requestbase t1 left join workflow_currentoperator t2 on t1.requestid=t2.requestid where (t1.deleted <> 1 or t1.deleted is null or t1.deleted = '') and t2.userid in ("+userid+") and t2.usertype = 0 and (t1.deleted = 0 or t1.deleted is null) and ((t2.isremark = 0 and t2.takisremark = -2) or t2.isremark in ('2', '4')) and (t1.deleted = 0 or t1.deleted is null) and t2.islasttimes = 1 and (nvl(t1.currentstatus, -1) = -1 or (nvl(t1.currentstatus, -1) = 0 and t1.creater in ("+userid+"))) and t1.workflowid in (select id from workflow_base where (isvalid = '1' or isvalid = '3')) and to_char(to_date(operatedate,'yyyy-mm-dd'),'yyyy') = to_char(sysdate,'yyyy') ";
		rs.execute(sql);
		if(rs.next()){
			count = rs.getInt("havaToDoCount");
		}
		sql = " select count(1) as count from ofs_todo_data where userid="+userid+" and isremark in(2,4) and islasttimes='1' and to_char(to_date(operatedate,'yyyy-mm-dd'),'yyyy-mm') = to_char(sysdate,'yyyy-mm') ";
		rs.execute(sql);
		if(rs.next()){
			count = count+rs.getInt("count");
		}
    	return count;
    }
    
    /**
     * 获取岗位系统列表
     * @param userid
     * @return
     */
    public List<Map<String,String>> getJobtitleSystemList(String userid){
    	List<Map<String,String>> list = new ArrayList<Map<String,String>>();
    	if("".equals(userid)) {
    		return list;
    	}
    	 String sql = "select subsystem_name,subsystem_url from uf_hg_auth_list where function_type='10' and website_type='portal' and(user_id ='common' or user_id=(select loginid from hrmresource where id='"+userid+"')) order by subsystem_seq_no asc";
         rs.execute(sql);
         while(rs.next()){
    		Map<String,String> map = new HashMap<String,String>();
    		map.put("subsystem_name", Util.null2String(rs.getString("subsystem_name")));
    		map.put("subsystem_url", Util.null2String(rs.getString("subsystem_url")));	
    		list.add(map);
    	}
    	return list;
    }
    /**
     * 获取公共系统列表
     * @return
     */
    public List<Map<String,String>> getPublicSystemList(){
    	List<Map<String,String>> list = new ArrayList<Map<String,String>>();
    	String sql = "select subsystem_name,subsystem_url from uf_hg_auth_list where function_type='20' order by subsystem_seq_no asc";
        rs.execute(sql);
        while(rs.next()){
    		Map<String,String> map = new HashMap<String,String>();
    		map.put("subsystem_name", Util.null2String(rs.getString("subsystem_name")));
    		map.put("subsystem_url", Util.null2String(rs.getString("subsystem_url")));	
    		list.add(map);
    	}
    	return list;
    }
}
