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
	text-align: left;
	background-color:#ecf0f1;
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
	
<script>
	function showProjectDetail(fromType,projId,projectName){
		var taskIframe = $("iframe:[src*='taskList.jsp']", window.parent.document); 
		if(taskIframe){
			taskIframe.attr("src", "/higer/portal/product/taskList.jsp?maxNum=9999&fromType="+fromType+"&projectId="+projId+"&projectName="+projectName);
		}
	}
</script>
 <BODY >
 <div style="height:100%;overflow-y:auto">
	<table width="100%" class="elementdatatable">    		
		<colgroup>
			<col style="width: 8px; min-width: 8px;" />
			<col style="width: 60%; min-width: 50%;" />
			<col style="width: 30%; max-width:150px;" />
			<col style="width: 8%; max-width:40px;" />
		</colgroup>
		<thead>
			<tr>
			  <th></th>
			  <th>项目名称</th>
			  <th style="padding-left：10px">项目时间</th>
			  <th>状态</th>
			</tr>
		</thead>
		<tbody>
			<%
				String firstFromType = "";
				String firstProjName = "";
				String firstPorjId = "";
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
				List<Map<String, String>> projectInfoList = service.getProjectInfos();
				int count =0;
				for(Map<String, String> projectInfo:projectInfoList){
					String projName = projectInfo.get("projName");
					String planBeginDate = projectInfo.get("planBeginDate");
					String planEndDate = projectInfo.get("planEndDate");
					String actEndDate = projectInfo.get("actEndDate");
					String statusName = projectInfo.get("statusName");
					String fromType = projectInfo.get("fromType");
					String projId = projectInfo.get("projId");
					String projectDate = planBeginDate + "-";
					if("".equals(firstPorjId)){
						firstPorjId = projId;
						firstProjName = projName;
						firstFromType = fromType;
					}
					if("关闭".equals(statusName)){
						projectDate += actEndDate;
					}else{
						projectDate += planEndDate;
					}
			%>
				<tr>
					<td><img name="esymbol" src="/page/resource/userfile/image/ecology8/pointer_wev8.png" style="margin-bottom: 4px;"></td>							  
					<td class="reqdetail">
						<a class="ellipsis" id="projectInfo_<%=projId%>" href="javascript:showProjectDetail('<%=fromType%>','<%=projId%>','<%=projName%>');">
						<font class="font"><font class="font"><span class="reqname" ><%=projName%></span></font></font>
						</a>
					</td>
					<td style="padding-left：10px"><font class="font"><%=projectDate%></font></td>
					<td >
						<font class="font" style="float:right;"><%=statusName%></font>
					</td>
				</tr>
			<%
				count++;
				if(count >= maxNum){
					break;
				}
			}
			%>
			<script>
				showProjectDetail('<%=firstFromType%>','<%=firstPorjId%>','<%=firstProjName%>');
			</script>
		 </tbody></table>
	</div>
</BODY>
</HTML>
