<%@page import="weaver.general.TimeUtil"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.higer.oa.service.portal.GetHigerJobtitlePortalDataService" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page isELIgnored="false" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
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
	
 <BODY >
 <div style="height:280px;">
	<table width="100%" class="elementdatatable">    		
		<colgroup><col style="width: 8px; min-width: 8px;"><col><col style="width: 20%; min-width: 20%;"><col style="width: 30%; min-width: 30%;"></colgroup>
		<tbody>
			<%
			int userid=user.getUID();
			GetHigerJobtitlePortalDataService gjpd = new GetHigerJobtitlePortalDataService();
			List<Map<String, String>> list = gjpd.getMyPrjDataForGovern(userid+"");
			for(Map<String, String> map:list){
			%>
				<tr>
					<td><img name="esymbol" src="/page/resource/userfile/image/ecology8/pointer_wev8.png" style="margin-bottom: 4px;"></td>							  
					<td ><a href="javascript:opengovern(<%=map.get("governid")%>)"><font class="font"><span class="reqname" ><%=map.get("name")%></span></font></a></td>
					<td ><a href="javascript:openhrm(<%=Integer.valueOf(map.get("creater"))%>)" onclick="pointerXY(event);"><font class="font"><%=Util.toScreen(ResourceComInfo.getResourcename(map.get("creater")),user.getLanguage())%></font></a></td>  
					<td ><font class="font" style="float:right;"><%=map.get("range")%></font></td>  
				</tr>
			<%
			}
			%>
		 </tbody></table>
	</div>
</BODY>
<script>
	function opengovern(governid){
		//alert(meetingid);
		window.open("/spa/govern/static/index.html#/main/govern/proinfo?id="+governid,"_blank");
	}
</script>
</HTML>
