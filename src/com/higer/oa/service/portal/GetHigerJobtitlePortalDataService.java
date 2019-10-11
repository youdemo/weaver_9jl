package com.higer.oa.service.portal;

import java.time.LocalDate;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONObject;

import com.higer.oa.dao.portal.GetHigerJobtitlePortalDataDao;
import com.higer.oa.service.portal.webservice.RequestOAServiceStub;
import com.higer.oa.service.portal.webservice.RequestOAServiceStub.GetTasksForOa;
import com.higer.oa.service.portal.webservice.RequestOAServiceStub.GetTasksForOaResponse;

import weaver.general.Util;

public class GetHigerJobtitlePortalDataService {
	/**
	 * 获取项目管理我的任务列表
	 * 
	 * @param userid
	 * @return
	 */
	public List<Map<String, String>> getMyPrjDataForP(String userid) {
		GetHigerJobtitlePortalDataDao gjdd = new GetHigerJobtitlePortalDataDao();
		List<Map<String, String>> list = gjdd.getDataListForPrj(gjdd.getLoginid(userid));

		long nowEpoDay = LocalDate.now(ZoneId.of("UTC+8")).toEpochDay();
		for (Map<String, String> map : list) {
			dealDataForP(map, nowEpoDay);
		}
		return list;
	}

	/**
	 * 获取will我的任务列表
	 * 
	 * @param userid
	 * @return
	 */
	public List<Map<String, String>> getMyPrjDataForW(String userid) {
		GetHigerJobtitlePortalDataDao gjpd = new GetHigerJobtitlePortalDataDao();
		List<Map<String, String>> list = new ArrayList<Map<String, String>>();
		String loginid = gjpd.getLoginid(userid + "");
		try {
			String result = getServiceData(loginid).replace("&quot;", "\"");
			int startindex = result.indexOf("<result>") + 8;
			int endindex = result.indexOf("</result>");
			result = result.substring(startindex, endindex);
			JSONObject json = new JSONObject(result);
			JSONArray ja = json.getJSONArray("taskDetl");
			long nowEpoDay = LocalDate.now(ZoneId.of("UTC+8")).toEpochDay();
			int count = 0;
			for (int i = 0; i < ja.length(); i++) {
				Map<String, String> map = new HashMap<String, String>();
				JSONObject jo = ja.getJSONObject(i);
				String startDate = jo.getString("startDate");
				String endDate = jo.getString("endDate");
				String projectName = jo.getString("projectName");
				String taskName = jo.getString("taskName");
				String url = jo.getString("url");
				String showdate = startDate + " - " + endDate;
				long balanceDay = 100;
				try {
					balanceDay = LocalDate.parse(endDate, DateTimeFormatter.ofPattern("yyyy/MM/dd")).toEpochDay()
							- nowEpoDay;
				} catch (Exception e) {
				}
				map.put("url", url);
				map.put("taskName", taskName);
				map.put("projectName", projectName);
				map.put("showdate", showdate);
				map.put("balanceDay", String.valueOf(balanceDay));
				list.add(map);
				count++;
				if(count==10){
					break;
				}
			}
		} catch (Exception e) {

		}
		return list;
	}
	/**
	 * 过去will项目任务webservice调用
	 * @param loginid
	 * @return
	 * @throws Exception
	 */
	public String getServiceData(String loginid) throws Exception {
		RequestOAServiceStub ros = new RequestOAServiceStub();
		GetTasksForOa gtf = new RequestOAServiceStub.GetTasksForOa();
		gtf.setLoadUser(loginid);
		GetTasksForOaResponse res = ros.GetTasksForOa(gtf);
		return res.getGetTasksForOaResult();
	}

	/**
	 * 获取会议信息列表
	 * 
	 * @param userid
	 * @return
	 */
	public List<Map<String, String>> getMyPrjDataForMeeting(String userid) {
		GetHigerJobtitlePortalDataDao gjdd = new GetHigerJobtitlePortalDataDao();
		List<Map<String, String>> list = gjdd.getDataListForMeeting(userid);
		return list;
	}

	/**
	 * 督办会议信息列表
	 * 
	 * @param userid
	 * @return
	 */
	public List<Map<String, String>> getMyPrjDataForGovern(String userid) {
		GetHigerJobtitlePortalDataDao gjdd = new GetHigerJobtitlePortalDataDao();
		List<Map<String, String>> list = gjdd.getDataListForGovern(userid);
		return list;
	}

	/**
	 * 获取各功能数量
	 * 
	 * @param userid
	 * @return
	 */
	public Map<String, Integer> getPortalCountList(String userid) {
		GetHigerJobtitlePortalDataDao gjdd = new GetHigerJobtitlePortalDataDao();
		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("oajobcount", gjdd.getOaJobCount(userid));
		map.put("pjobcount", gjdd.getPrjJobCount(gjdd.getLoginid(userid)));
		map.put("toDoCount", gjdd.getOaTodoCount(userid));
		map.put("toReadCount", gjdd.getOaTodoCount(userid));
		map.put("myMeetCount", gjdd.getMyMeetingCount(userid));
		map.put("myGovernCount", gjdd.getMyGovernCount(userid));
		map.put("havaToDoCount", gjdd.getHaveToDoCount(userid));
		map.put("havaToDoCountyear", gjdd.getHaveToDoCountYear(userid));

		return map;
	}

	/**
	 * 处理项目管理我的任务列表数据
	 * 
	 * @param map
	 * @param nowEpoDay
	 */
	public void dealDataForP(Map<String, String> map, long nowEpoDay) {
		String task_start_date = Util.null2String(map.get("task_start_date"));
		String task_end_date = Util.null2String(map.get("task_end_date"));
		String showdate = task_start_date + " - " + task_end_date;
		long balanceDay = 100;
		try {
			balanceDay = LocalDate.parse(task_end_date, DateTimeFormatter.ofPattern("yyyy/MM/dd")).toEpochDay()
					- nowEpoDay;
		} catch (Exception e) {

		}
		map.put("showdate", showdate);
		map.put("balanceDay", String.valueOf(balanceDay));
	}

	/**
	 * 获取岗位系统列表
	 * 
	 * @param userid
	 * @return
	 */
	public List<Map<String, String>> getJobtitleSystemList(String userid) {
		GetHigerJobtitlePortalDataDao gjdd = new GetHigerJobtitlePortalDataDao();
		return gjdd.getJobtitleSystemList(userid);
	}

	/**
	 * 获取公共系统列表
	 * 
	 * @return
	 */
	public List<Map<String, String>> getPublicSystemList() {
		GetHigerJobtitlePortalDataDao gjdd = new GetHigerJobtitlePortalDataDao();
		return gjdd.getPublicSystemList();
	}
}
