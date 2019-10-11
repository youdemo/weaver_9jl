<%@page import="weaver.general.TimeUtil"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
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
		<tbody><tr>
                <td><img name="esymbol" src="/page/resource/userfile/image/ecology8/pointer_wev8.png" style="margin-bottom: 4px;"></td>							  
				<td class="reqdetail" width="*" title="我的任务" >
					<a class="ellipsis" href="" target="_blank"><font class="font"><font class="font"><span class="reqname" >我的任务</span></font></font></a>
				</td>
				<td ><a href="javascript:openhrm(1)" onclick="pointerXY(event);"><font class="font"><font class="font">系统管理员</font></font></a></td>  
				<td >
					<font class="font">2019-06-12</font>
				</td>
		</tr>
		<tr>
                <td><img name="esymbol" src="/page/resource/userfile/image/ecology8/pointer_wev8.png" style="margin-bottom: 4px;"></td>							  
				<td class="reqdetail" width="*" title="测试任务" >
					<a class="ellipsis" href="" target="_blank"><font class="font"><font class="font"><span class="reqname" >测试任务</span></font></font></a>
				</td>
				<td ><a href="javascript:openhrm(1)" onclick="pointerXY(event);"><font class="font"><font class="font">系统管理员</font></font></a></td>  
				<td >
					<font class="font">2019-06-12</font>
				</td>
		</tr>
		 </tbody></table>
	</div>

</BODY>
</HTML>
