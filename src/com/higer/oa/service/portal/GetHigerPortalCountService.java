package com.higer.oa.service.portal;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;

import org.json.JSONObject;

import com.higer.oa.dao.portal.GetHigerJobtitlePortalDataDao;
import com.higer.oa.service.portal.webservice.RequestOAServiceStub;
import com.higer.oa.service.portal.webservice.RequestOAServiceStub.GetTasksForOa;
import com.higer.oa.service.portal.webservice.RequestOAServiceStub.GetTasksForOaResponse;

import weaver.general.BaseBean;
import weaver.hrm.HrmUserVarify;
import weaver.hrm.User;

public class GetHigerPortalCountService {
	@GET
	@Path("/getPortalCount")
	@Produces({ MediaType.TEXT_PLAIN })
	public String getPortalCount(@Context HttpServletRequest request, @Context HttpServletResponse response) {
		GetHigerJobtitlePortalDataDao gjdd = new GetHigerJobtitlePortalDataDao();
		JSONObject result = new JSONObject();
		try {
			// 获取当前用户
			User user = HrmUserVarify.getUser(request, response);
			String userid = String.valueOf(user.getUID());
			result.put("oajobcount", gjdd.getOaJobCount(userid));
			result.put("pjobcount", gjdd.getPrjJobCount(gjdd.getLoginid(userid)));
			result.put("toDoCount", gjdd.getOaTodoCount(userid));
			result.put("toReadCount", gjdd.getOaToReadCount(userid));
			result.put("myMeetCount", gjdd.getMyMeetingCount(userid));
			result.put("myGovernCount", gjdd.getMyGovernCount(userid));
			result.put("havaToDoCount", gjdd.getHaveToDoCount(userid));
			result.put("havaToDoCountyear", gjdd.getHaveToDoCountYear(userid));
			result.put("wjobcount",GetWillJobCount(userid));
		} catch (Exception e) {
			e.printStackTrace();

		}
		return result.toString();
	}

	public int GetWillJobCount(String userid) {
		String wjobcount = "";
		GetHigerJobtitlePortalDataDao gjpdd = new GetHigerJobtitlePortalDataDao();
		try {
		String result = getServiceData(gjpdd.getLoginid(userid + "")).replace("&quot;", "\"");
		int startindex = result.indexOf("<result>") + 8;
		int endindex = result.indexOf("</result>");
		result = result.substring(startindex, endindex);
		JSONObject json = new JSONObject(result);
		wjobcount = json.getString("taskNumber");
		}catch(Exception e) {
			wjobcount = "0";
			new BaseBean().writeLog(e);
		}
		if("".equals(wjobcount)) {
			wjobcount = "0";
		}
		return Integer.valueOf(wjobcount);
	}
	public String getServiceData(String loginid) throws Exception {
		RequestOAServiceStub ros = new RequestOAServiceStub();
		GetTasksForOa gtf =new RequestOAServiceStub.GetTasksForOa();
		gtf.setLoadUser(loginid);
		GetTasksForOaResponse res =ros.GetTasksForOa(gtf);
		return res.getGetTasksForOaResult();
	}
}
