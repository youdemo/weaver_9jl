package higer.password;

import org.json.JSONException;
import org.json.JSONObject;

import weaver.conn.RecordSet;
import weaver.email.EmailEncoder;
import weaver.general.BaseBean;
import weaver.general.Util;
import weaver.hrm.resource.ResourceComInfo;

public class ChangePassWordService {
	/**
	 * 
	 * @param changeInfo {"loginid":"123","password":"asdsa"}
	 * @return {"type":"S","message":"成功"}
	 */
	public String changePassWord(String changeInfo) {
		BaseBean log = new BaseBean();
		RecordSet rs = new RecordSet();
		String result = "";
		String sql = "";
		String ryid = "";
		String password = "";
		String loginid = "";
		try {
			JSONObject jo = new JSONObject(changeInfo);
			password = jo.getString("password");
			loginid = jo.getString("loginid");
		} catch (JSONException e1) {
			log.writeLog(e1);
			result = "{\"type\":\"E\",\"message\":\"json格式异常\"}";
			return result;
			
		}
		if(!"".equals(Util.null2String(password))){
			String newPassWord = Util.getEncrypt(password);
			sql = "select id from hrmresource where loginid='"+loginid+"'";
			rs.execute(sql);
			if(rs.next()) {
				ryid = Util.null2String(rs.getString("id"));
			}
			if("".equals(ryid)) {
				result = "{\"type\":\"E\",\"message\":\"人员不存在\"}";
			}
			sql = "update hrmresource set password='"+newPassWord+"' where id="+ryid;
			rs.execute(sql);
			String mailPassword = EmailEncoder.EncoderPassword(password);
			//log.writeLog(this.getClass().getName(),"mailPassword:"+mailPassword);
			int count = 0;
			sql = "select count(1) as count from mailaccount where userid="+ryid;
			rs.execute(sql);
			if(rs.next()) {
				count = rs.getInt("count");
			}
			if(count>0) {
				sql = "update mailaccount set accountPassword='"+mailPassword+"' where userid="+ryid;
				//log.writeLog(this.getClass().getName(),"sql:"+sql);
				rs.execute(sql);
			}
			try {
				new ResourceComInfo().updateResourceInfoCache(ryid);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			result = "{\"type\":\"S\",\"message\":\"更新成功\"}";
		}else {
			result = "{\"type\":\"E\",\"message\":\"密码不能为空\"}";
		}
		
		return result;
	}
	
}
