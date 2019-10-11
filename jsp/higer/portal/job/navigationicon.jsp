<%@page import="weaver.general.TimeUtil"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="higer.portal.job.GetJobWData" %>
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
        int oajobcount =0;
        int pjobcount =0;
        String wjobcount = "0";
        String loginid = "";
    	String sql = "select count(b.id) as oajobcount from Prj_ProjectInfo a,Prj_TaskProcess b where a.id=b.prjid and a.status=1 and b.rwzz=9 and hrmid='"+userid+"'" ;
        rs.execute(sql);
        if(rs.next()){
            oajobcount = rs.getInt("oajobcount");
        }
        sql = "select loginid from hrmresource where id="+userid;
		rs.execute(sql);
		if(rs.next()){
			loginid = Util.null2String(rs.getString("loginid"));
		}
        RecordSetDataSource rsd = new RecordSetDataSource("basdb_higerprj");
		sql = "select count(1) as pjobcount from prj_klsz_task_detail_v where task_owner='"+loginid+"' and task_owner <> ''";
		rsd.execute(sql);
        if(rsd.next()){
            pjobcount = rsd.getInt("pjobcount");
        }
        try{
            GetJobWData scl=new GetJobWData();
            String result = scl.getServiceData(loginid).replace("&quot;","\"");
            int  startindex=result.indexOf("<result>")+8;
            int  endindex=result.indexOf("</result>");
            result=result.substring(startindex,endindex);
            JSONObject json = new JSONObject(result);
            wjobcount = json.getString("taskNumber");
        }catch(Exception e){
        }
        //我的待办
        int toDoCount = 0;
        sql = " select count( distinct t1.requestid) as toDoCount from workflow_requestbase t1 left join workflow_currentoperator t2 on t1.requestid=t2.requestid where (t1.deleted <> 1 or t1.deleted is null or t1.deleted = '') and t2.userid in ("+userid+") and t2.usertype = 0 and (t1.deleted = 0 or t1.deleted is null) and ((t2.isremark = 0 and (t2.takisremark is null or t2.takisremark = 0)) or t2.isremark in ('5', '7')) and (t1.deleted = 0 or t1.deleted is null) and t2.islasttimes = 1 and (nvl(t1.currentstatus, -1) = -1 or (nvl(t1.currentstatus, -1) = 0 and t1.creater in ("+userid+"))) and t1.workflowid in (select id from workflow_base where (isvalid = '1' or isvalid = '3')) ";
        rs.execute(sql);
        if(rs.next()){
			toDoCount = rs.getInt("toDoCount");
		}
		sql = "select count(1) as count from ofs_todo_data where userid="+userid+" and isremark=0 and islasttimes='1'";
		rs.execute(sql);
        if(rs.next()){
			toDoCount = toDoCount+rs.getInt("count");
		}
		//我的待阅
		int toReadCount = 0;
		sql = " select count( distinct t1.requestid) as toReadCount from workflow_requestbase t1 left join workflow_currentoperator t2 on t1.requestid=t2.requestid where (t1.deleted <> 1 or t1.deleted is null or t1.deleted = '') and t2.userid in ("+userid+") and t2.usertype = 0 and (t1.deleted = 0 or t1.deleted is null) and (t2.isremark in ('1', '8','9')) and (t1.deleted = 0 or t1.deleted is null) and t2.islasttimes = 1 and (nvl(t1.currentstatus, -1) = -1 or (nvl(t1.currentstatus, -1) = 0 and t1.creater in ("+userid+"))) and t1.workflowid in (select id from workflow_base where (isvalid = '1' or isvalid = '3')) ";
		rs.execute(sql);
        if(rs.next()){
			toReadCount = rs.getInt("toReadCount");
		}
		//我的会议
		int myMeetCount = 0;
		sql = " select  count(1) as myMeetCount from meeting where meetingstatus in (2) and enddate||' '||endtime>=to_char(sysdate,'yyyy-mm-dd hh24:mi') and (dbms_lob.instr(','||hrmmembers||',',',"+userid+",')>0 or caller='"+userid+"' or contacter='"+userid+"') ";
		rs.execute(sql);
		if(rs.next()){
			myMeetCount = rs.getInt("myMeetCount");
		}
		//我的督办
		int myGovernCount = 0;
		sql = " select count(1) as myGovernCount from govern_task where tasktype=0 and status in (1,2) and responsible ="+userid+"";
		rs.execute(sql);
		if(rs.next()){
			myGovernCount = rs.getInt("myGovernCount");
		}
		//本月已办
		int havaToDoCount = 0;
		sql = " select count(1) havaToDoCount from workflow_requestbase t1 left join workflow_currentoperator t2 on t1.requestid=t2.requestid where (t1.deleted <> 1 or t1.deleted is null or t1.deleted = '') and t2.userid in ("+userid+") and t2.usertype = 0 and (t1.deleted = 0 or t1.deleted is null) and ((t2.isremark = 0 and t2.takisremark = -2) or t2.isremark in ('2', '4')) and (t1.deleted = 0 or t1.deleted is null) and t2.islasttimes = 1 and (nvl(t1.currentstatus, -1) = -1 or (nvl(t1.currentstatus, -1) = 0 and t1.creater in ("+userid+"))) and t1.workflowid in (select id from workflow_base where (isvalid = '1' or isvalid = '3')) and to_char(to_date(operatedate,'yyyy-mm-dd'),'yyyy-mm') = to_char(sysdate,'yyyy-mm') ";
		rs.execute(sql);
		if(rs.next()){
			havaToDoCount = rs.getInt("havaToDoCount");
		}
		sql = " select count(1) as count from ofs_todo_data where userid="+userid+" and isremark in(2,4) and islasttimes='1' and to_char(to_date(operatedate,'yyyy-mm-dd'),'yyyy-mm') = to_char(sysdate,'yyyy-mm') ";
		rs.execute(sql);
		if(rs.next()){
			havaToDoCount = havaToDoCount+rs.getInt("count");
		}


		//本月已办
		int havaToDoCountyear = 0;
		sql = " select count(1) havaToDoCount from workflow_requestbase t1 left join workflow_currentoperator t2 on t1.requestid=t2.requestid where (t1.deleted <> 1 or t1.deleted is null or t1.deleted = '') and t2.userid in ("+userid+") and t2.usertype = 0 and (t1.deleted = 0 or t1.deleted is null) and ((t2.isremark = 0 and t2.takisremark = -2) or t2.isremark in ('2', '4')) and (t1.deleted = 0 or t1.deleted is null) and t2.islasttimes = 1 and (nvl(t1.currentstatus, -1) = -1 or (nvl(t1.currentstatus, -1) = 0 and t1.creater in ("+userid+"))) and t1.workflowid in (select id from workflow_base where (isvalid = '1' or isvalid = '3')) and to_char(to_date(operatedate,'yyyy-mm-dd'),'yyyy') = to_char(sysdate,'yyyy') ";
		rs.execute(sql);
		if(rs.next()){
			havaToDoCountyear = rs.getInt("havaToDoCount");
		}
		sql = " select count(1) as count from ofs_todo_data where userid="+userid+" and isremark in(2,4) and islasttimes='1' and to_char(to_date(operatedate,'yyyy-mm-dd'),'yyyy') = to_char(sysdate,'yyyy') ";
		rs.execute(sql);
		if(rs.next()){
			havaToDoCountyear = havaToDoCountyear+rs.getInt("count");
		}

		//本月已阅
		//int haveToReadCount = 0;
		//sql = " select count( distinct t1.requestid) as haveToReadCount from workflow_requestbase t1 left join workflow_currentoperator t2 on t1.requestid=t2.requestid where (t1.deleted <> 1 or t1.deleted is null or t1.deleted = '') and t2.userid in ("+userid+") and t2.usertype = 0 and (t1.deleted = 0 or t1.deleted is null) and (t2.isremark in ('1', '8')) and (t1.deleted = 0 or t1.deleted is null) and t2.islasttimes = 1 and (nvl(t1.currentstatus, -1) = -1 or (nvl(t1.currentstatus, -1) = 0 and t1.creater in ("+userid+"))) and t1.workflowid in (select id from workflow_base where (isvalid = '1' or isvalid = '3')) and to_char(to_date(t2.operatedate,'yyyy-mm-dd'),'yyyy-mm') = to_char(sysdate,'yyyy-mm') ";
		//rs.execute(sql);
        //if(rs.next()){
		//	haveToReadCount = rs.getInt("haveToReadCount");
		//}
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