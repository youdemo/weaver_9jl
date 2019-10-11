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
<HTML><HEAD>
</HEAD>
<style type="text/css">
	 *{
    		margin:0px;
    		padding:0px;
    		font-family: '微软雅黑';
  	}
  	.application{
    		width:100%;
                height:100%; 
		overflow :auto;
  	}
  	.application_title div{
    		float: left;
  	}
  	.application_img{
    		height:20px;
    		width:20px;
    		margin-left: 5px;
  	}
  	.application_img img{
    		width:100%;
    		height: 100%;
    		margin-top:2px;
		margin-bottom:5px;
  	}
  	.applicant_link{
    		list-style: none;
    		border-top: 2px solid #e1dbdb;
    		margin-left: 5px;

  	}
  	a{
    		text-decoration: none;
  	}
  	.applicant_link ul{
    		width:100%;
  	}
  	.applicant_link ul li{
    		width:11%;
    		float: left;
    		list-style: none;
    		margin-top:5px;
    		margin-left: 5px;
    		color:#242424!important;
    		font-size: 12px;
  	}
  	.application_name{
    		font-size: 12px;
    		color: #242424;
			font-style: normal;
			font-weight: normal;
    		margin-top:2px;
    		margin-bottom: 5px;
			font-family: 微软雅黑!important;
  	}
  	#img{
    		height:15px;
    		width:15px;
    		margin-right: 2px;
  	}
  	#img img{
    		width:100%;
    		height:100%;
  	}
	.itemcolor:hover{
		color:#008ff3 !important;
	}
</style>
 <BODY >
 <%
	int userid=user.getUID();
    GetHigerJobtitlePortalDataService gjpd = new GetHigerJobtitlePortalDataService();
	List<Map<String, String>> list = gjpd.getJobtitleSystemList(userid+"");
	pageContext.setAttribute("jbtitleSystemList",list);
%>
 <div class = "application">
		<div class = "application_title">
			<div class = "application_img">
				<img src="/higer/portal/applicant.png">
			</div>
			<div class= "application_name">
				我的应用
			</div>
		
		</div>
		<div style = "clear: both;"></div>
		<div class = "applicant_link">
			<ul>              
				 <c:forEach var="jbtitleSystemList" items="${jbtitleSystemList}"> 
                    <a href = "${jbtitleSystemList.subsystem_url}" target="_blank">
					<li class="itemcolor">${jbtitleSystemList.subsystem_name}</li>
			    	</a>
                </c:forEach>			
			</ul>
		</div>
	</div>

</BODY>
</HTML>
