<%@page import="weaver.general.TimeUtil"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.higer.oa.service.portal.GetHigerJobtitlePortalDataService" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page isELIgnored="false" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
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
<%
			int userid=user.getUID();
			GetHigerJobtitlePortalDataService gjpd = new GetHigerJobtitlePortalDataService();
			List<Map<String, String>> list = gjpd.getMyPrjDataForMeeting(userid+"");
			pageContext.setAttribute("meetingList",list); //会议列表
			%>	
 <BODY >
 <div style="height:280px;">
	<table width="100%" class="elementdatatable">    		
		<colgroup><col style="width: 8px; min-width: 8px;"><col><col style="width:30%; min-width: 30%;"><col style="width: 35%;"></colgroup>
		<tbody>
			
			<c:forEach var="meetingList" items="${meetingList}"> 
				<tr>
					<td><img name="esymbol" src="/page/resource/userfile/image/ecology8/pointer_wev8.png" style="margin-bottom: 4px;"></td>							  
					<td ><a href="javascript:openmeeting(${meetingList.meetingid})"><font class="font"><span class="reqname" >${meetingList.name}</span></font></a></td>
					<td ><font class="font">${meetingList.address}</font></td>  
					<td ><font class="font" style="float:right;">${meetingList.range}</font></td>  
				</tr>
			</c:forEach>
			
		 </tbody></table>
	</div>
</BODY>
<script>
	function openmeeting(meetingid){
		//alert(meetingid);
		window.open("/spa/meeting/static/index.html#/main/meeting/dialogsingle?meetingid="+meetingid,"_blank");
	}
</script>
</HTML>
