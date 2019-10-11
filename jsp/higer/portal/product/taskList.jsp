<%@page import="com.higer.oa.service.portal.ProductPortalService"%>
<%@page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
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
.elementdatatable {
    table-layout: fixed;
    border-collapse: collapse;
	text-align: left;
}
.elementdatatable caption{
	text-align: left;
	background-color: #e8f5f9;
	font-size: 14px;
	font-weight: 700;
	padding: 5px 5px 5px 8px;
	border-radius: 5px;
	margin-bottom: 5px;
}
.elementdatatable thead{
	background-color:#ecf0f1;
	text-align: left;
}
.elementdatatable thead th{
	padding:3px 0px;
}

.elementdatatable tbody>tr>td {
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
 <div style="height:100%;overflow-y:auto">
	<table width="100%" class="elementdatatable">    		
		<colgroup>
			<col style="width: 8px; min-width: 8px;" />
			<col style="width: 60%; min-width: 50%;" />
			<col style="width: 30%; max-width:150px;" />
			<col style="width: 8%; max-width:40px;" />
		</colgroup>
		<%
			int userid=user.getUID();
			String maxNumStr = request.getParameter("maxNum");
			if(maxNumStr == null || "".equals(maxNumStr)){
				maxNumStr = "10";
			}
			int maxNum = 10;
			try{
				if(org.apache.commons.lang.math.NumberUtils.isDigits(maxNumStr)){
					maxNum = org.apache.commons.lang.math.NumberUtils.toInt(maxNumStr);
				}
			}catch(Exception e){
				
			}
			ProductPortalService service = new ProductPortalService();
			String projectId = request.getParameter("projectId");
			String fromType = request.getParameter("fromType");
			String projectName = request.getParameter("projectName");
			if(projectName == null){
				projectName = "";
			}
			List<Map<String, String>> projectTaskInfoList = service.getProjectTaskInfos(projectId,fromType);
			int count =0;
		%>
		<caption style="text-align: left;"><%=projectName%></caption>
		<thead>
			<tr>
			  <th></th>
			  <th>任务名称</th>
			  <th>任务时间</th>
			  <th>状态</th>
			</tr>
		</thead>
		<tbody>
			<%
				for(Map<String, String> projectTaskInfo:projectTaskInfoList){
					String taskName = projectTaskInfo.get("taskName");
					String planBeginDate = projectTaskInfo.get("planBeginDate");
					String planEndDate = projectTaskInfo.get("planEndDate");
					String actEndDate = projectTaskInfo.get("actEndDate");
					String taskDate = planBeginDate+"-";
					String taskStatusName = projectTaskInfo.get("statusName");
					if("关闭".equals(taskStatusName)){
						taskDate += actEndDate;
					}else{
						taskDate += planEndDate;
					}
			%>
				<tr>
					<td><img name="esymbol" src="/page/resource/userfile/image/ecology8/pointer_wev8.png" style="margin-bottom: 4px;"></td>					
					<td >
						<font class="font"><font class="font"><span class="reqname" ><%=taskName%></span></font></font>
					</td>
					<td ><font class="font"><%=taskDate%></font></td>
					<td >
						<font class="font"><%=taskStatusName%></font>
					</td>
				</tr>
			<%
				count++;
				if(count>=maxNum){
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
