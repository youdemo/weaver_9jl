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
 <div style="height:260px;">
	<table width="100%" class="elementdatatable">    		
		<colgroup><col style="width: 12px; min-width: 12px;"><col><col style="width: 20%; min-width: 20%;"><col style="width: 30%; min-width: 30%;"></colgroup>
		<tbody>
			<%
			int userid=user.getUID();
			String taskname = "";
			String principalid = "";
			String enddate = "";
			String taskid = "";
			String createdate = "";
			String begindate = "";
			String sql = "select * from (select rownum as rowseq,id,name,principalid,begindate,enddate,createdate from tm_taskinfo where  status=1 and nvl(deleted,0) <>'1' and (principalid="+userid+" or id in(select taskid from tm_taskpartner where partnerid="+userid+") or id in(select taskid from tm_tasksharer where sharerid="+userid+") ) order by enddate asc) a where rowseq<=10";
			rs.execute(sql);
			while(rs.next()){
				taskid = Util.null2String(rs.getString("id"));
				taskname = Util.null2String(rs.getString("name"));
				principalid = Util.null2String(rs.getString("principalid"));
				enddate = Util.null2String(rs.getString("enddate"));
				createdate = Util.null2String(rs.getString("createdate"));
				begindate = Util.null2String(rs.getString("begindate"));
				String showdate = "";
				if("".equals(begindate)){
					showdate = createdate + " - "+enddate;
				}else{
					showdate = begindate + " - "+enddate;
				} 

			%>
				<tr>
					<td><img name="esymbol" src="/page/resource/userfile/image/ecology8/pointer_wev8.png" style="margin-bottom: 4px;margin-left:4px;"></td>							  
					<td class="reqdetail" width="*" title="我的任务" >
						<a class="ellipsis" href="javascript:openjob(<%=taskid%>)" ><font class="font"><font class="font"><span class="reqname" ><%=taskname%></span></font></font></a>
					</td>
					<td ><a href="javascript:openhrm(<%=Integer.valueOf(principalid)%>)" onclick="pointerXY(event);"><font class="font"><font class="font"><%=Util.toScreen(ResourceComInfo.getResourcename(principalid),user.getLanguage())%></font></font></a></td>  
					<td >
						<font class="font" style="float:right;"><%=showdate%></font> 
					</td>
				</tr>
			<%
			}
			%>
		
	
		 </tbody></table>
	</div>

</BODY>
<script>
	function openjob(taskid){
		var ryid = "<%=userid%>";
		 $.ajax({
             type: "POST",
             url: "/higer/portal/job/action/myjob-oa-action.jsp",
             data: {'taskid':taskid, 'ryid':ryid},
             dataType: "text",
             async:false,//同步   true异步
             success: function(data){
                        data=data.replace(/^(\s|\xA0)+|(\s|\xA0)+$/g, '');
                        
                      }
         });

		window.open("/workrelate/task/data/Main.jsp","_blank");
	}
</script>
</HTML>
