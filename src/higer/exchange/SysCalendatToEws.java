package higer.exchange;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import weaver.conn.RecordSet;
import weaver.general.BaseBean;
import weaver.interfaces.schedule.BaseCronJob;
import weaver.upgradetool.wscheck.Util;

public class SysCalendatToEws extends BaseCronJob{
	public void execute(){
		BaseBean log = new BaseBean();
		log.writeLog("开始同步日程");
		sysCanlendar();
		log.writeLog("结束同步日程");
	}
	
	public void sysCanlendar() {
		BaseBean log = new BaseBean();
		RecordSet rs = new RecordSet();
		String billid = "";
		int count = 1;
		String planid = "";
		String sql = "select max(id) as billid,count(1) as count,planid from uf_planexchangemid where isdeal=0 group by planid";
		//log.writeLog("同步日程 sql:"+sql);
		rs.execute(sql);
		while(rs.next()) {
			billid = Util.null2String(rs.getString("billid"));
			count = rs.getInt("count");
			planid = Util.null2String(rs.getString("planid"));
			//log.writeLog("同步日程 billid:"+billid+" count:"+count+" planid:"+planid);
			try {
				doPlanData(billid,count,planid);
			} catch (Exception e) {
				log.writeLog("同步日程失败");
				log.writeLog(e);
			}
		}
		
	}
	
	public void doPlanData(String billid,int count,String planid) throws Exception {
		BaseBean log = new BaseBean();
		RecordSet rs = new RecordSet();
		SimpleDateFormat  aa = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		EwsCalendarInfoUitl ewsUtil = new EwsCalendarInfoUitl();
		String sql = "";
		String type = checkSysType(billid,count,planid);
		//log.writeLog("同步日程 type:"+type);
		boolean result = false;
		String exchangeId = "";
		if("1".equals(type) || "2".equals(type)) {
			sql = "select exchangeid from uf_planexchangemid where planid='"+planid+"' and exchangeid is not null and id<="+billid+" order by id desc";
			rs.execute(sql);
			if(rs.next()) {
				exchangeId = Util.null2String(rs.getString("exchangeid"));
			}
			if("".equals(exchangeId)) {
				return;
			}
		}
		if("2".equals(type)) {
			result = ewsUtil.delAppointment(exchangeId);
		}else{
			OaCalendarInfo oaam = null;
			sql = "select name,description,begindate||' '||trim(begintime)||':00' as starttime,enddate||' '||trim(endtime)||':00' as endtime,resourceid from workplan where id="+planid;
			rs.execute(sql);
			if(rs.next()) {
				oaam = new OaCalendarInfo();
				oaam.setAmSubject(Util.null2String(rs.getString("name")));
				oaam.setBody(Util.null2String(rs.getString("description")));
				//log.writeLog("同步日程 name:"+rs.getString("name"));
				oaam.setAmStartDate(ewsUtil.local2Utc(aa.parse(Util.null2String(rs.getString("starttime")))));
				oaam.setAmEndDate(ewsUtil.local2Utc(aa.parse(Util.null2String(rs.getString("endtime")))));
				//oaam.setAmLocation("地点");
				oaam.setAllDay(false);
				List<String> mailList = new ArrayList<String>();
				String resourceid = Util.null2String(rs.getString("resourceid"));
				if(!"".equals(resourceid)&&!"1".equals(resourceid)) {
					sql = "select email from hrmresource where id in("+resourceid+")";
					rs.execute(sql);
					while(rs.next()) {
						String email = Util.null2String(rs.getString("email"));
						if(email.indexOf("@higer.com")>0) {
							mailList.add(email);
						}
					}
				}else {
					return;
				}
				if(mailList.size() <= 0) {
					return;
				}
				List<String> rmailsplus = new ArrayList<String>();
				for(String mail:mailList) {
					//log.writeLog(mail);
					rmailsplus.add(mail);
				}
				oaam.setRequiredAttendees(rmailsplus);
//				List<String> rmailsplus = new ArrayList<String>();
//				rmailsplus.add("chengz@higer.com");
//				oaam.setRequiredAttendees(rmailsplus);
			}
			if("1".equals(type) && oaam != null) {
				oaam.setId(exchangeId);
				result = ewsUtil.updateAppointment(oaam);
			}else if("0".equals(type) && oaam != null) {
				//log.writeLog("同步日程 调用接口:");
				exchangeId=ewsUtil.addAppointment(oaam);
				//log.writeLog("同步日程 调用exchangeId:"+exchangeId);
				if("".equals(exchangeId)) {
					result = false;
				}else {
					result = true;
				}
			}
			
		
		}
		if(result) {
			sql = "update uf_planexchangemid set isdeal = '1',remark='处理成功' , exchangeid='"+exchangeId+"' where planid='"+planid+"' and isdeal=0";
			rs.execute(sql);
		}else {
			sql = "update uf_planexchangemid set isdeal = '1',remark='处理失败' , exchangeid='"+exchangeId+"' where planid='"+planid+"' and isdeal=0";
			rs.execute(sql);
		}
		
		
		
	}
	
	public String checkSysType(String billid,int count,String planid) {
		RecordSet rs = new RecordSet();
		String wtype = "";
		String result = "";
		int count1 = 0;
		String sql = "select wtype from uf_planexchangemid where id="+billid;
		rs.execute(sql);
		if(rs.next()) {
			wtype = Util.null2String(rs.getString("wtype"));
		}
		if("2".equals(wtype)) {
			result = "2";
		}else if("0".equals(wtype)) {
			result = "0";
		}else if("1".equals(wtype)) {
			sql = "select count(1) as count  from uf_planexchangemid where planid='"+planid+"' and exchangeid is not null ";
			rs.execute(sql);
			if(rs.next()) {
				count1 = rs.getInt("count");
			}
			if(count1 <= 0) {
				result = "0";
			}else {
				result = "1";
			}
		}
		
		return result;
	}
}
