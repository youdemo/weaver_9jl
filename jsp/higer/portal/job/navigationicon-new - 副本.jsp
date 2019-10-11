<%@page import="weaver.general.TimeUtil"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="higer.portal.job.GetJobWData" %>
<%@ page import="java.util.*" %>
<%@ page import="com.higer.oa.dao.portal.GetHigerJobtitlePortalDataDao" %>
<%@ page import="com.higer.oa.service.portal.GetHigerJobtitlePortalDataService" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="java.lang.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<html>
<head>
	<title></title>
</head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<style type="text/css">
	*{
		margin:0px;
		padding:0px;
	}
	.navifation{
		width:335px;
		height: 240px;
	}
	.navifation ul{
		width: 100%;
		height: 100%;
		list-style: none;
		background-color:#ffffff;
	}
	.navifation ul .list{
		width: 26%;
		height: 31%;
		float: left;
		margin-top: 5%;
		margin-left: 6%;
		border-radius: 10px;
		background-color: #d9d6c3;
		margin-bottom: -2%;
	}
	.list_logo{
		width:100%;
		height:60%;
	}
	.list_logo img{
		width: 100%;
		height: 100%;
		border-radius: 5px;
		z-index: 0;
		margin-top:5px;
		margin-left: 3px;
	}
	.title{
		width: 100%;
		height: 58%;
		color: #666;
		font-size: 13px;
		text-align: center;
		color: #ffffff;
		font-weight: bold;
	}
	.imgbox{
		width: 44%;
		height: 64%;
		margin:0 auto;
		margin-top: 7px;
		border-radius: 5px;
		font-size: 18px;
		text-align: center;
		position:relative;
		color: #ffffff;
	}
       .imgbox1{
		width: 55%;
		height: 80%;
		margin:0 auto;
		margin-top: 7px;
		border-radius: 5px;
		font-size: 14px;
		text-align: center;
		position:relative;
		color: #ffffff;
	}
	.number{
		width: 100%;
		text-align: center;
		font-size: 20px;
		margin-top: 5px;
		color:#ffffff;
	}
	.countinfo{
		font-size: 17px;
		z-index: 1;
		position: absolute;
		width: 20px;
		height: 20px;
		top: -2px;
		right: -18px;
		border-radius: 50%;
		color: #ffffff;
		margin-top: -3px;
		line-height: 20px;
		background-color: red;
	}
	#todo{
		background-color: rgb(255,155,100);
	}
	#mymission{
		background-color: rgb(255,204,103);
	}
	#mymissionW{
		background-color: rgb(102,194,204);
	}
	#mymissionP{ 
		background-color: rgb(1,102,255);
	}
	#supervisor{ 
		background-color: rgb(152,103,254);
	}
	#mettting{ 
		background-color: rgb(206,103,255);
	} 
	#read{ 
		background-color: rgb(0,153,255);
	}
	#byyb{
		background-color: rgb(153,153,153); 
	}
	#byyy{
		background-color: rgb(52,204,254); 
	}  	
</style>

<%
		//我的任务
        int userid=user.getUID();
		GetHigerJobtitlePortalDataService gjpd = new  GetHigerJobtitlePortalDataService();
		Map<String, Integer> map = gjpd.getPortalCountList(userid+"");
        int oajobcount = map.get("oajobcount");
        int pjobcount = map.get("pjobcount");
        String wjobcount = "0";     
        try{
            GetJobWData scl=new GetJobWData();
            GetHigerJobtitlePortalDataDao gjpdd = new GetHigerJobtitlePortalDataDao();
            String result = scl.getServiceData(gjpdd.getLoginid(userid+"")).replace("&quot;","\"");
            int  startindex=result.indexOf("<result>")+8;
            int  endindex=result.indexOf("</result>");
            result=result.substring(startindex,endindex);
            JSONObject json = new JSONObject(result);
            wjobcount = json.getString("taskNumber");
        }catch(Exception e){
        }   
        int toDoCount =  map.get("toDoCount");//我的待办		
		int toReadCount = map.get("toReadCount");//我的待阅		
		int myMeetCount = map.get("myMeetCount");	//我的会议		
		int myGovernCount = map.get("myGovernCount");//我的督办		
		int havaToDoCount = map.get("havaToDoCount");//本月已办		
		int havaToDoCountyear = map.get("havaToDoCountyear");//本月已办
		
%>
<body>
	<div class = "navifation">
		<ul >
			<li class = "list " id = "todo">
            	<a href="/wui/index.html#/main/workflow/listDoing" target="_blank">
				<div class = "list_logo">
					<div class = "imgbox">
						<span class = "countinfo"><%=toDoCount%></span>
					
						<img src="/higer/portal/job/img/todo.png"/>
						
					</div>
				</div>
				<div class = "title">我的待办</div>
                </a>
			</li>
			<li class = "list" id = "mymission">
            <a href="/spa/prj/index.html#/main/prj/queryTaskResult?searchfrom=portal" target="_blank">
				<div class = "list_logo">
					<div class = "imgbox">
						<span class = "countinfo"><%=oajobcount%></span>
						
						<img src="/higer/portal/job/img/mymission.png"/>
						
					</div>
				</div>
				<div class = "title">OA任务</div>
                </a>
			</li>
			<li class = "list" id = "mymissionW">
            <a href="/higer/portal/job/myjob-w.jsp" target="_blank">
				<div class = "list_logo">
					<div class = "imgbox">
						<span class = "countinfo"><%=wjobcount%></span>
						
						<img src="/higer/portal/job/img/mymission.png"/>
						
					</div>
				</div>
				<div class = "title" style="font-size:11px;">Windchill任务</div>
                </a>
			</li>
			<li class = "list" id = "mymissionP">
            <a href="/higer/portal/job/myjob-p-more-Url.jsp" target="_blank">
				<div class = "list_logo">
					<div class = "imgbox">
						<span class = "countinfo"><%=pjobcount%></span>
						
						<img src="/higer/portal/job/img/mymission.png"/>
						
					</div>
				</div>
				<div class = "title">项目任务</div>
                </a>
			</li>
			<li class = "list"  id= "supervisor">
            	<a href="/spa/govern/static/index.html#/main/govern/projAccount" target="_blank">
				<div class = "list_logo">
					<div class = "imgbox">
						<span class = "countinfo"><%=myGovernCount%></span>
					
						<img src="/higer/portal/job/img/Supervisor.png"/>
					
					</div>
				</div>
				<div class = "title">我的督办</div>
                	</a>
			</li>
			<li class = "list" id = "mettting">
            <a href="/wui/index.html#/main/meeting/calView" target="_blank">
				<div class = "list_logo">
					<div class = "imgbox">
						<span class = "countinfo"><%=myMeetCount%></span>
						
						<img src="/higer/portal/job/img/styleing.png"/>
					
					</div>
				</div>
				<div class = "title">我的会议</div>
                	</a>
			</li>
			<li class = "list" id = "read">
            <a href="/wui/index.html#/main/workflow/listDoing" target="_blank">
				<div class = "list_logo">
					<div class = "imgbox">
						<span class = "countinfo"><%=toReadCount%></span>
						
						<img src="/higer/portal/job/img/newprocess.png"/>
						
					</div>
				</div>
				<div class = "title">我的待阅</div>
                </a>
			</li>
			
			<li class = "list" id = "byyb">
				<div class = "list_logo">
					<a href="/wui/index.html#/main/workflow/listDone" target="_blank">
					<div class = "imgbox1">
						本月<br>已办
					</div>
					<div class = "number"><%=havaToDoCount%></div>
					</a>
				</div>
			</li>
			<li class = "list" id = "byyy">
				<div class = "list_logo">
					<a href="/wui/index.html#/main/workflow/listDone" target="_blank">
					<div class = "imgbox1">
						本年<br>已办
					</div>
					<div class = "number"><%=havaToDoCountyear%></div>
					</a>
				</div>
			</li>
		</ul>
	</div>
</body>
</html>