<%@page import="weaver.general.TimeUtil"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.time.ZoneId" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<HTML>
<HEAD>
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
</HEAD>
<style type="text/css">
	#navigation_glt{
		height:100%;
		width:100%;
		overflow :auto;
	}
	.navigation_glt_content{
		margin:0px;
		padding:0px;
		width:100%;
		height:100%;
	}
	.navigation_glt_content li{
		list-style: none;
		width:70px;
		height:60px;
		float: left;
		margin-left: 0px;
		margin-top: 0px;


	}
	.navigation_glt_content li .navigatio_headimg{
		width:46%;
		height:31%;
		border-radius: 4px;
		margin:14px auto;
		margin-top: 15px;
		margin-bottom: 8px
	}
	.navigation_glt_content li .navigatio_headimg img{
		width:100%;
		height:100%;
		border-radius: 5px;
	}
	.navigation_glt_content li .navigatio_title{
		font-size: 12px;
		
		text-overflow: ellipsis;
 		white-space: nowrap;
 		text-align: center;
 		line-height: 11px;
 		color: #666;
	}
	a{
		list-style: none;
		text-decoration: none;
	}
</style>
 <BODY >

<div id = "navigation_glt">
	<ul class=  "navigation_glt_content">
	
	<%
		String iconRsUrl = "/JLPortal/logo/car.png";
        	String subsystem_name = "";
        	String subsystem_url = "";
		String icon_url = "";
        	String sql = "select id,subsystem_name,subsystem_url,subsystem_seq_no,iconUrrl from uf_hg_auth_list where function_type='50' order by subsystem_seq_no asc ";
        	rs.execute(sql);
        	while(rs.next()){
       			subsystem_name = Util.null2String(rs.getString("subsystem_name"));
 			subsystem_url = Util.null2String(rs.getString("subsystem_url"));
			icon_url = Util.null2String(rs.getString("iconUrrl"));
			if(icon_url.length() < 5 ){
				icon_url = iconRsUrl;
			}
			String tmp_name = subsystem_name;
			
			if(subsystem_url.length() > 5){
	%>
		<li>
			<a href = "<%=subsystem_url%>" target="_blank" title="<%=subsystem_name%> -> <%=subsystem_url%> ">
				<div class = "navigatio_headimg">
					<img src = "<%=icon_url%>"/>
				</div>
				<div class = "navigatio_title"><%=tmp_name%></div>
			</a>
		</li>
	<%
			}
		} 
	%>
		
	</ul>
</div>

</BODY>
</HTML>
