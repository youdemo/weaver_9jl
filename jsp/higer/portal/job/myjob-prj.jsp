<%@page import="weaver.general.TimeUtil"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="com.higer.oa.service.portal.GetOAProcessListService" %>
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
GetOAProcessListService gol = new GetOAProcessListService();
String tablestr = gol.getProcessList(userid+"");
			
%>	
 <BODY >
 <div style="height:260px;">
	<table width="100%" class="elementdatatable">    		
		<colgroup><col style="width: 8px; min-width: 8px;"><col><col style="width: 34%; min-width: 34%;"><col style="width: 30%; min-width: 30%;"></colgroup>
		<tbody>			
			<%=tablestr%>			
		 </tbody></table>
	</div>

</BODY>
<script>
	function openPrj(prjid){
		window.open("/spa/prj/index.html#/main/prj/projectCard?prjid="+prjid,"_blank");
	}
	function openProcess(processid){
		window.open("/spa/prj/index.html#/main/prj/taskCard?taskid="+processid,"_blank");
	}
</script>
</HTML>
