<%@page import="weaver.general.TimeUtil"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="higer.portal.job.GetJobWData" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="java.time.ZoneId" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<script type="text/javascript" src="/appres/hrm/js/mfcommon_wev8.js"></script>
		<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
		<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
		<SCRIPT language="JavaScript" src="/js/weaver_wev8.js"></SCRIPT>
		<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
		<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
		<style>
</HEAD>
<style type="text/css">
.application{
		width:700px;
		margin-top:10px;	
	}
.elementdatatable {
    table-layout: fixed;
}
.elementdatatable {
    margin-top: 3px;
    border-collapse: collapse;
}
.overdue {
	color:red
}
.indue {
	color:green
} 
tbody>tr>td {
    border: none;
    padding: 4px 1px 3px;
}
body{
overflow:hidden;
overflow-x:hidden;
overflow-y:hidden;
}
</style>
	
 <BODY >
 <div style="height:260px;">
	<table width="100%" class="elementdatatable">    		
		<colgroup><col style="width: 8px; min-width: 8px;"><col><col style="width: 35%; min-width: 35%;"><col style="width: 25%; min-width:25%;"></colgroup>
		<tbody>
			<%
			int userid=user.getUID();
			String loginid = "";
			String sql = "select loginid from hrmresource where id="+userid;
			rs.execute(sql);
			if(rs.next()){
				loginid = Util.null2String(rs.getString("loginid"));
			}
			GetJobWData scl=new GetJobWData();
		    String result = scl.getServiceData(loginid).replace("&quot;","\"");
			int  startindex=result.indexOf("<result>")+8;
			int  endindex=result.indexOf("</result>");
			result=result.substring(startindex,endindex);
			JSONObject json = new JSONObject(result);JSONArray ja = json.getJSONArray("taskDetl");
			long nowEpoDay = LocalDate.now(ZoneId.of("UTC+8")).toEpochDay();
			int count = 0;
		  	for(int i=0;i<ja.length();i++) {
			  JSONObject jo = ja.getJSONObject(i);
			  String startDate = jo.getString("startDate");
			  String endDate = jo.getString("endDate");
			  String projectName = jo.getString("projectName");
			  String taskName = jo.getString("taskName");
			  String url = jo.getString("url");
			  String showname = "";
				if("".equals(projectName)){
					showname = taskName;
				}else{
					showname = taskName+" [ "+projectName+" ]";
				}
			  String showdate = startDate+" - "+endDate;
			  long balanceDay = 100;
			  try{
				balanceDay = LocalDate.parse(endDate, DateTimeFormatter.ofPattern("yyyy/MM/dd")).toEpochDay() - nowEpoDay;
			  }catch(Exception e){
			  }
			  if(balanceDay<0){
			%>
				<tr class="overdue">
			<%
			  }else if(balanceDay<3){
			%>
				<tr class="indue">
			<%
			  }else{
			%>
				<tr>
			<%
			  }
			%>
					<td><img name="esymbol" src="/page/resource/userfile/image/ecology8/pointer_wev8.png" style="margin-bottom: 4px;"></td>							  
					<td class="reqdetail" width="*" title="我的任务W" >
						<a class="ellipsis" href="<%=url%>" target="_blank"><font class="font"><font class="font"><span class="reqname" ><%=taskName%></span></font></font></a>
					</td>
					<td >
						<font class="font"><%=projectName%></font>
					</td>
					<td >
						<font class="font" style="float:right;"><%=showdate%></font>
					</td>
				</tr>
			<%
				count++;
				if(count==10){
					break;
				}
			}
			%>
		
	
		 </tbody></table>
	</div>

</BODY>
<script>
	
</script>
</HTML>
