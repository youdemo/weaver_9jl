package com.higer.oa.service.portal;

import java.util.Date;
import java.util.List;
import java.util.Map;

import com.higer.oa.dao.portal.GetOAProcessListDao;

import ln.TimeUtil;
import weaver.general.Util;

public class GetOAProcessListService {
	public String getProcessList(String userid) {
		String nowDate = TimeUtil.getFormartString(new Date(), "yyyy-MM-dd");
		GetOAProcessListDao gopd = new GetOAProcessListDao();
		List<Map<String,String>> list =gopd.getList(userid);
		StringBuffer sb = new StringBuffer();
		for(Map<String,String> map:list) {
			sb.append(getTdStr(map,nowDate));
		}
		return sb.toString();
	}
	
	public String getTdStr(Map<String,String> map,String nowDate) {
		StringBuffer sb = new StringBuffer();
		GetOAProcessListDao gopd = new GetOAProcessListDao();
		String name = map.get("name");//项目名称
		String subject = map.get("subject");//任务名称
		String begindate = map.get("begindate");//任务开始时间
		String enddate = map.get("enddate");//任务结束时间
		String id = map.get("id");//任务id
		String prjid = map.get("prjid");//项目id
		String type = "0";
		if(!"".equals(enddate)) {
			type = gopd.getDayBetween(nowDate, enddate);
		}
		String color = "";
		String textcolor = "";
		if("1".equals(type)) {
			color = "style=\"color:green\"";
			textcolor = "color=\"green\"";
		}else if("2".equals(type)){
			color = "style=\"color:red\"";
			textcolor = "color=\"red\"";
		}
		String showdate = begindate+" - "+enddate;
		sb.append("");
		sb.append("<tr>");
		sb.append("	<td><img name=\"esymbol\" src=\"/page/resource/userfile/image/ecology8/pointer_wev8.png\" style=\"margin-bottom: 4px;\"></td>");					  
		sb.append("	<td class=\"reqdetail\" width=\"*\" title=\"我的任务\" >");
		sb.append("		<a "+color+" href=\"javascript:openPrj("+prjid+")\" ><font class=\"font\" ><span class=\"reqname\" >"+name+"</span></font></a>");
		sb.append("	</td>");
		sb.append("	<td ><a "+color+"href=\"javascript:openProcess("+id+")\"><font class=\"font\" >"+subject+"</font></a></td>");  
		sb.append("	<td >");
		sb.append("	<font class=\"font\" style=\"float:right;\" "+textcolor+">"+showdate+"</font> ");
		sb.append("	</td>");
		sb.append("</tr>");
		return sb.toString();
		
	}
}
