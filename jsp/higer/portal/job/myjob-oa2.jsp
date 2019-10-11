<%@page import="weaver.general.TimeUtil"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
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
</style>
	
 <BODY >
 <div >
	<table width="100%" class="elementdatatable">    		
		<colgroup><col style="width: 8px; min-width: 8px;"><col><col style="width: 30%; min-width: 30%;"><col style="width: 18%; min-width: 18%;"></colgroup>
		<tbody>
			<%
			int userid=user.getUID();
			String taskname = "";
			String principalid = "";
			String begindate = "";
			String sql = "select name,principalid,begindate,enddate from tm_taskinfo where  status=1 and (principalid="+userid+" or id in(select taskid from tm_taskpartner where partnerid="+userid+") or id in(select taskid from tm_tasksharer where sharerid="+userid+") )";
			rs.execute(sql);
			while(rs.next()){
				taskname = Util.null2String(rs.getString("name"));
				principalid = Util.null2String(rs.getString("principalid"));
				begindate = Util.null2String(rs.getString("begindate"));
			%>
				<tr>
					<td><img name="esymbol" src="/page/resource/userfile/image/ecology8/pointer_wev8.png" style="margin-bottom: 4px;"></td>							  
					<td class="reqdetail" width="*" title="我的任务" >
						<a class="ellipsis" href="" target="_blank"><font class="font"><font class="font"><span class="reqname" ><%=taskname%></span></font></font></a>
					</td>
					<td ><a href="javascript:openhrm(<%=Integer.valueOf(principalid)%>)" onclick="pointerXY(event);"><font class="font"><font class="font"><%=Util.toScreen(ResourceComInfo.getResourcename(principalid),user.getLanguage())%></font></font></a></td>  
					<td >
						<font class="font"><%=begindate%></font>
					</td>
				</tr>
			<%
			}
			%>
		
	
		 </tbody></table>
	</div>

</BODY>
</HTML>
