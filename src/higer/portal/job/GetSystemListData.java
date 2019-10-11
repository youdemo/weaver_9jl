package higer.portal.job;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONObject;

import higer.portal.servicext.RequestOAServiceStub;
import higer.portal.servicext.RequestOAServiceStub.GetAuthorityDiff;
import higer.portal.servicext.RequestOAServiceStub.GetAuthorityDiffResponse;
import weaver.conn.RecordSet;
import weaver.formmode.setup.ModeRightInfo;
import weaver.general.BaseBean;
import weaver.general.Util;
import weaver.interfaces.schedule.BaseCronJob;

public class GetSystemListData extends BaseCronJob{
	
	public void execute(){
		BaseBean log = new BaseBean();
		log.writeLog("开始同步系统列表");
		dealData();
		log.writeLog("结束同步系统列表");
	}
	
	public void dealData() {
		BaseBean log = new BaseBean();
		SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");
		String now = sf.format(new Date());
		RecordSet rs = new RecordSet();
		HigerJobUtil hju = new HigerJobUtil();
		ModeRightInfo ModeRightInfo = new ModeRightInfo();
		String tableName = "uf_hg_auth_list";
		String modeId = getModeId(tableName);
		String sql = "";
		try {
			String result = getServiceData();
			log.writeLog(this.getClass().getName(),"result:"+result);
			JSONObject json = new JSONObject(result);
			String success = json.getString("success");
			if(!"true".equals(success)) {
				return ;
			}
			JSONArray ja = json.getJSONArray("data");
			String functionType = "";
			String userId = "";
			String subsystemCode = "";
			String subsystemName = "";
			String subsystemEnName = "";
			String SeqNo = "";
			String url = "";
			String websiteType = "";
			String diffType = "";
			for(int i=0;i<ja.length();i++) {
				JSONObject jo = ja.getJSONObject(i);
				functionType = jo.getString("functionType");
				userId = jo.getString("userId");
				subsystemCode = jo.getString("subsystemCode");
				subsystemName = jo.getString("subsystemName");
				subsystemEnName = jo.getString("subsystemEnName");
				SeqNo = jo.getString("SeqNo");
				url = jo.getString("url");
				websiteType = jo.getString("websiteType");
				diffType = jo.getString("diffType");
				if("DEL".equals(diffType)) {
					if("".equals(userId)) {
						sql = "delete from "+tableName+" where user_id is null and function_type='"+functionType+"' and subsystem_code='"+subsystemCode+"' ";
					}else {
						sql = "delete from "+tableName+" where user_id='"+userId+"' and function_type='"+functionType+"' and subsystem_code='"+subsystemCode+"' ";
					}					
					rs.execute(sql);					
				}else if("ADD".equals(diffType)) {
					Map<String, String> mapStr = new HashMap<String, String>();
					mapStr.put("function_type", functionType);
					mapStr.put("user_id", userId);
					mapStr.put("subsystem_code", subsystemCode);
					mapStr.put("subsystem_name", subsystemName);
					mapStr.put("subsystem_en_name", subsystemEnName);
					mapStr.put("subsystem_seq_no", SeqNo);
					
					mapStr.put("subsystem_url", url);
					mapStr.put("website_type", websiteType);					
					mapStr.put("modedatacreater", "1");
					mapStr.put("modedatacreatertype", "0");
					mapStr.put("modedatacreatedate", now);
					mapStr.put("formmodeid", modeId);

					hju.insert(mapStr, tableName);
					String dataId = "";
					sql = "select max(id) as id from "+tableName+" where  user_id='"+userId+"' and subsystem_code='"+subsystemCode+"'";
					rs.execute(sql);					
					if (rs.next()) {
						dataId = Util.null2String(rs.getString("id"));
					}
					if (!"".equals(dataId)) {						
						ModeRightInfo.editModeDataShare(Integer.valueOf("1"),
								Integer.valueOf(modeId), Integer.valueOf(dataId));
					}
				}
			} 
		} catch (Exception e) {
			log.writeLog(this.getClass().getName(),e);
		}
	}
	
	public String getServiceData() throws Exception {
		RequestOAServiceStub ross = new RequestOAServiceStub();
		GetAuthorityDiff gau = new RequestOAServiceStub.GetAuthorityDiff();
		GetAuthorityDiffResponse  rew = ross.GetAuthorityDiff(gau);
		return rew.getGetAuthorityDiffResult();		
	}
	
	public String getModeId(String tableName) {
		RecordSet rs = new RecordSet();
		String formid = "";
		String modeid = "";
		String sql = "select id from workflow_bill where tablename='"
				+ tableName + "'";
		rs.executeSql(sql);
		if (rs.next()) {
			formid = Util.null2String(rs.getString("id"));
		}
		sql = "select id from modeinfo where  formid=" + formid;
		rs.executeSql(sql);
		if (rs.next()) {
			modeid = Util.null2String(rs.getString("id"));
		}
		return modeid;
	}

}
