<%@page import="weaver.general.TimeUtil"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
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
    		margin-top: 2px;
    		margin-bottom: 5px;
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
    		color: #87CEFA;
    		margin-left: 5px;
    		color:#b3b3b3;
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
</style>
 <BODY >
 <div class = "application">
		<div class = "application_title">
			<div class = "application_img">
				<img src="/higer/portal/applicant.png">
			</div>
			<div class= "application_name">
				通用链接（公共）
			</div>
		
		</div>
		<div style = "clear: both;"></div>
		<div class = "applicant_link">
			<ul>
                <%
                   String subsystem_name = "";
                   String subsystem_url = "";
                   String sql = "select subsystem_name,subsystem_url from uf_hg_auth_list where function_type='20' order by subsystem_seq_no asc";
                   rs.execute(sql);
                   while(rs.next()){
                       subsystem_name = Util.null2String(rs.getString("subsystem_name"));
                       subsystem_url = Util.null2String(rs.getString("subsystem_url"));
                 %>
                    <a href = "<%=subsystem_url%>" target="_blank">
					<li><%=subsystem_name%></li>
			    	</a>
                <%
                   } 
                %>

               
				
				
				
			</ul>
		</div>
	</div>

</BODY>
</HTML>
