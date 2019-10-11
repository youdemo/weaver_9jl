package higer.portal.job;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONObject;

import weaver.conn.ConnStatement;
import weaver.conn.RecordSet;
import weaver.conn.RecordSetDataSource;
import weaver.general.BaseBean;
import weaver.general.Util;
import weaver.hrm.User;

public class HigerJobUtil { 
	public List getJobDataP(User user, Map map, HttpServletRequest httpservletrequest,
			HttpServletResponse httpservletresponse) {
		//BaseBean log = new BaseBean();
		ArrayList<Map> arraylist = new ArrayList<Map>();
		RecordSet rs = new RecordSet();
		RecordSetDataSource rsd = new RecordSetDataSource("basdb_higerprj");
		String userid = Util.null2String(map.get("operateuserid"));
		String loginid = "";
		String sql = "select loginid from hrmresource where id="+userid;
		//log.writeLog(this.getClass().getName(),"sql:"+sql);
		rs.execute(sql);
		if(rs.next()) {
			loginid = Util.null2String(rs.getString("loginid"));
		}
		String task_owner = "";
		String task_id = "";
		String task_start_date = "";
		String task_end_date = "";
		String task_name = "";
		String proj_name = "";
		String url = "";
		sql = "select task_owner,task_id,task_start_date,task_end_date,task_name,proj_name,url from prj_klsz_task_detail_v where task_owner='"+loginid+"' and task_owner <> '' order by task_end_date asc";
		rsd.execute(sql);
		while(rsd.next()) {
			task_owner = Util.null2String(rsd.getString("task_owner"));
			task_id = Util.null2String(rsd.getString("task_id"));
			task_start_date = Util.null2String(rsd.getString("task_start_date"));
			task_end_date = Util.null2String(rsd.getString("task_end_date"));
			task_name = Util.null2String(rsd.getString("task_name"));
			proj_name = Util.null2String(rsd.getString("proj_name"));
			url = Util.null2String(rsd.getString("url"));
			String showname = "<a href=\""+url+"\" target=\"_blank\">"+task_name+"</a>";
			HashMap<String,String> datamap = new HashMap<String,String>();
			datamap.put("task_owner",task_owner);
			datamap.put("task_id",task_id);
			datamap.put("task_start_date",task_start_date);
			datamap.put("task_end_date",task_end_date);
			datamap.put("task_name",showname);
			datamap.put("proj_name",proj_name);
			arraylist.add(datamap);
		}
		//log.writeLog(this.getClass().getName(),"arraylist:"+arraylist.size());
		return arraylist;
	}
	
	public List getJobDataW(User user, Map map, HttpServletRequest httpservletrequest,
			HttpServletResponse httpservletresponse) {
		BaseBean log = new BaseBean();
		ArrayList<Map> arraylist = new ArrayList<Map>();
		RecordSet rs = new RecordSet();
		String userid = Util.null2String(map.get("operateuserid"));
		String loginid = "";
		String sql = "select loginid from hrmresource where id="+userid;
		log.writeLog(this.getClass().getName(),"sql:"+sql);
		rs.execute(sql);
		if(rs.next()) {
			loginid = Util.null2String(rs.getString("loginid"));
		}
		GetJobWData scl=new GetJobWData();
	    String result;
		try {
			result = scl.getServiceData(loginid).replace("&quot;","\"");
			int  startindex=result.indexOf("<result>")+8;
			int  endindex=result.indexOf("</result>");
			result=result.substring(startindex,endindex);
			JSONObject json = new JSONObject(result);
			JSONArray ja = json.getJSONArray("taskDetl");
			int count = 0;
		  	for(int i=0;i<ja.length();i++) {
			  JSONObject jo = ja.getJSONObject(i);
			  String startDate = jo.getString("startDate");
			  String endDate = jo.getString("endDate");
			  String projectName = jo.getString("projectName");
			  String taskName = jo.getString("taskName");
			  String url = jo.getString("url");
			  String showname = "<a href=\""+url+"\" target=\"_blank\">"+taskName+"</a>";
			  HashMap<String,String> datamap = new HashMap<String,String>();
		      datamap.put("startDate",startDate);
			  datamap.put("endDate",endDate);
		      datamap.put("taskName",showname);
			  datamap.put("projectName",projectName);
			  arraylist.add(datamap);
			  
		  	}
		} catch (Exception e) {
			new BaseBean().writeLog(this.getClass().getName(), e);
		}
		
		
		return arraylist;
	}
	public boolean insert(Map<String, String> mapStr, String table) {
		BaseBean log = new BaseBean();
		if (mapStr == null)
			return false;
		if (mapStr.isEmpty())
			return false;


		String sql_0 = "insert into " + table + "(";
		StringBuffer sql_1 = new StringBuffer();
		String sql_2 = ") values(";
		StringBuffer sql_3 = new StringBuffer();
		String sql_4 = ")";

		Iterator<String> it = mapStr.keySet().iterator();
		while (it.hasNext()) {
			String tmp_1 = it.next();
			// String tmp_1_str = Util.null2String(mapStr.get(tmp_1));
			String tmp_1_str = mapStr.get(tmp_1);
			if (tmp_1_str == null)
				tmp_1_str = "";

			if (tmp_1_str.length() > 0) {
				sql_1.append(tmp_1);
				sql_1.append(",");

				sql_3.append("?");
				sql_3.append(",");
				
			}
		}

		String now_sql_1 = sql_1.toString();
		if (now_sql_1.lastIndexOf(",") > 0) {
			now_sql_1 = now_sql_1.substring(0, now_sql_1.length() - 1);
		}

		String now_sql_3 = sql_3.toString();
		if (now_sql_3.lastIndexOf(",") > 0) {
			now_sql_3 = now_sql_3.substring(0, now_sql_3.length() - 1);
		}

		String sql = sql_0 + now_sql_1 + sql_2 + now_sql_3 + sql_4;
		ConnStatement cs = new ConnStatement();
		 log.writeLog("## sql = " + sql);
		 try {
				cs.setStatementSql(sql);
				 it = mapStr.keySet().iterator();
				 int num=1;
				while (it.hasNext()) {
					String tmp_1 = it.next();
					// String tmp_1_str = Util.null2String(mapStr.get(tmp_1));
					String tmp_1_str = mapStr.get(tmp_1);
					if (tmp_1_str == null)
						tmp_1_str = "";

					if (tmp_1_str.length() > 0) {
						cs.setString(num,tmp_1_str);
						num++;
					}
				}
				
				cs.executeUpdate();		
				cs.close();
			} catch (Exception e) {
				log.writeLog(e);
				cs.close();
				return false;
			}				

		// return false;
		return true;
	}
}
