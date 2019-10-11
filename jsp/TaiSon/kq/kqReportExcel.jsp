<%@ page language="java" contentType="application/vnd.ms-excel; charset=UTF-8" %>
<%@ page import="weaver.systeminfo.*,java.util.*,weaver.hrm.*" %>
<%@ page import="weaver.general.Util,weaver.hrm.common.*" %>
<%@ page import="weaver.hrm.attendance.domain.*"%>
<%@page import="weaver.hrm.report.schedulediff.HrmScheduleDiffManager"%>
<%@page import="java.net.URLEncoder"%>
<%@ page import="weaver.general.BaseBean" %>
<!-- modified by wcd 2014-07-24 [E7 to E8] -->
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs_dt" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="format" class="weaver.hrm.common.SplitPageTagFormat" scope="page"/>
<jsp:useBean id="strUtil" class="weaver.common.StringUtil" scope="page"/>
<jsp:useBean id="dateUtil" class="weaver.common.DateUtil" scope="page"/>
<jsp:useBean id="holidayManager" class="weaver.hrm.attendance.manager.HrmPubHolidayManager" scope="page" />
<jsp:useBean id="colorManager" class="weaver.hrm.attendance.manager.HrmLeaveTypeColorManager" scope="page" />
<jsp:useBean id="HrmScheduleDiffUtil" class="weaver.hrm.report.schedulediff.HrmScheduleDiffUtil" scope="page"/>
<jsp:useBean id="monthAttManager" class="weaver.hrm.attendance.manager.HrmScheduleDiffMonthAttManager" scope="page" />
<jsp:useBean id="leaveTimeManager" class="weaver.hrm.attendance.manager.HrmPaidLeaveTimeManager" scope="page" />
<jsp:useBean id="HrmScheduleDiffOtherManager" class="weaver.hrm.report.schedulediff.HrmScheduleDiffOtherManager" scope="page"/>
<jsp:useBean id="HrmScheduleDiffDetSignInManager" class="weaver.hrm.report.schedulediff.HrmScheduleDiffDetSignInManager" scope="page"/>
<jsp:useBean id="HrmScheduleDiffDetSignOutManager" class="weaver.hrm.report.schedulediff.HrmScheduleDiffDetSignOutManager" scope="page"/>
<jsp:useBean id="HrmScheduleDiffDetNoSignManager" class="weaver.hrm.report.schedulediff.HrmScheduleDiffDetNoSignManager" scope="page"/>
<jsp:useBean id="HrmScheduleDiffDetAbsentFromWorkManager" class="weaver.hrm.report.schedulediff.HrmScheduleDiffDetAbsentFromWorkManager" scope="page"/>
<jsp:useBean id="HrmScheduleDiffDetBeLateManager" class="weaver.hrm.report.schedulediff.HrmScheduleDiffDetBeLateManager" scope="page"/>
<jsp:useBean id="HrmScheduleDiffDetLeaveEarlyManager" class="weaver.hrm.report.schedulediff.HrmScheduleDiffDetLeaveEarlyManager" scope="page"/>
<jsp:useBean id="HrmScheduleApplicationRuleManager" class="weaver.hrm.attendance.manager.HrmScheduleApplicationRuleManager" scope="page" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<style>
<!--
td{font-size:12px}
.title{font-weight:bold;font-size:20px}
-->
</style>
<%!
	public String getTranStr(String data){
		String result = data;
		if("0".equals(data)){
			result = "";
		}else if("0.00".equals(data)){
			result = "";
		}
		return result;
	}

%>
<%
  new BaseBean().writeLog("test3333");
	User user = HrmUserVarify.getUser (request , response) ;
	if(user == null)  return ;
	response.setContentType("application/vnd.ms-excel");
	
	Calendar today = Calendar.getInstance ();
	String currentDate = Util.add0(today.get(Calendar.YEAR), 4) + "-"
					   + Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-"
					   + Util.add0(today.get(Calendar.DAY_OF_MONTH), 2);

	String cmd = strUtil.vString(request.getParameter("cmd"));
	String fromDate = strUtil.vString(request.getParameter("fromDate"));
	String toDate = strUtil.vString(request.getParameter("toDate"));
	String tnum = strUtil.vString(request.getParameter("tnum"));
	int subCompanyId = strUtil.parseToInt(request.getParameter("subCompanyId"),0);
	int departmentId = strUtil.parseToInt(request.getParameter("departmentId"),0);
	String resourceId = strUtil.vString(request.getParameter("resourceId"));
	String status = strUtil.vString(request.getParameter("status"));
	String _currentdate = strUtil.vString(request.getParameter("currentdate"));
		String isRule = strUtil.vString(request.getParameter("isRule"));
	String ruleid = strUtil.vString(request.getParameter("ruleid"));
	Calendar ____cal = null, ____Fday = null, ____Lday = null;
	if(_currentdate.length() > 0){
		Date CURRENT_DATE = dateUtil.parseToDate(_currentdate);
		____cal = dateUtil.getCalendar(CURRENT_DATE);
		____Fday = dateUtil.getCalendar(dateUtil.getFirstDayOfMonth(CURRENT_DATE));
		____Lday = dateUtil.getCalendar(dateUtil.getLastDayOfMonth(CURRENT_DATE));
		fromDate = dateUtil.getDate(____Fday.getTime());
		toDate = dateUtil.getDate(____Lday.getTime());
	}
	//安全检查  
	//查询的开始日期和结束日期必须有值且长度为10
	if(fromDate==null||fromDate.trim().equals("")||fromDate.length()!=10
	 ||toDate==null||toDate.trim().equals("")||toDate.length()!=10){
		return;
	}
	//非考勤管理员只能看到自己的记录
	if(!HrmUserVarify.checkUserRight("BohaiInsuranceScheduleReport:View", user)){
		resourceId = String.valueOf(user.getUID());
	}
	if(resourceId.length() > 0) {
		if(subCompanyId <= 0) subCompanyId = strUtil.parseToInt(ResourceComInfo.getSubCompanyID(resourceId), 0);
		if(departmentId <= 0) departmentId = strUtil.parseToInt(ResourceComInfo.getDepartmentID(resourceId), 0);
	}
	String tabName = SystemEnv.getHtmlLabelNames(tnum,user.getLanguage())+SystemEnv.getHtmlLabelNames("27904",user.getLanguage());
    if(!ruleid.equals("")){
		ScheduleApplicationRule scheduleApplicationRule = HrmScheduleApplicationRuleManager.get(ruleid);
		tabName = scheduleApplicationRule.getReportname() + tabName;
    }
		String fileName = fromDate+" "+SystemEnv.getHtmlLabelName(15322,user.getLanguage())+" "+toDate+" "+tabName;
	if("20090".equals(tnum)){
		fileName = fromDate+" "+SystemEnv.getHtmlLabelName(15322,user.getLanguage())+" "+toDate+" 缺勤明细";
	}
	new BaseBean().writeLog("test4444");
	response.setHeader("Content-disposition","attachment;filename="+new String(fileName.getBytes("GBK"),"iso8859-1")+".xls");
%>
<%
	if(cmd.equals("HrmScheduleDiffReport")){
		new BaseBean().writeLog("5555");
		List qList = colorManager.find("[map]subcompanyid:0;field002:1;field003:1");
		int qSize = qList == null ? 0 : qList.size();
%>
<table  border=1  bordercolor=black style="border-collapse:collapse;" width="100%" >
	<COLGROUP>
		<COL width="9%">
		<COL width="9%">
		<COL width="6%">
		<COL width="6%">
		<COL width="6%">
		<COL width="6%">
		<COL width="6%">
		<COL width="6%">
		<COL width="6%">
		<COL width="6%">
		<COL width="6%">
		<COL width="6%">
		<COL width="6%">
		<COL width="6%">
	</COLGROUP>
	<tbody>
		<tr>
			<td colspan="14" align="center" ><font size=4><b><%=fileName%></b></font></td>
		</tr>
		<tr>
			<td colspan="14" align="right" ></td>
		</tr>
		<tr>
			<td rowspan=3 align="center"><%=SystemEnv.getHtmlLabelName(15390,user.getLanguage())%></td>
			<td rowspan=3 align="center"><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></td>
			<td colspan="11" align="center"><%=SystemEnv.getHtmlLabelName(20080,user.getLanguage())%></td>   
		</tr>
		<tr>
			<td rowspan=2 align="center"><%=SystemEnv.getHtmlLabelName(34082,user.getLanguage())%></td>
				<td rowspan=2 align="center">实际出勤（天）</td>
			<td rowspan=2 align="center"><%=SystemEnv.getHtmlLabelNames("20081,81913,18929,81914",user.getLanguage())%></td>
			<td rowspan=2 align="center"><%=SystemEnv.getHtmlLabelNames("20082,81913,18929,81914",user.getLanguage())%></td>
		
			<td colspan="4" align="center">请假（小时）</td> 
			
		
			<td rowspan=2 align="center"><%=SystemEnv.getHtmlLabelNames("20084,81913,1925,81914",user.getLanguage())%></td>
			<td rowspan=2 align="center">外出（小时）</td>
			<td rowspan=2 align="center"><%=SystemEnv.getHtmlLabelNames("20085,81913,18929,81914",user.getLanguage())%></td>
			<td rowspan=2 align="center"><%=SystemEnv.getHtmlLabelNames("20086,81913,18929,81914",user.getLanguage())%></td>
		</tr> 
	<tr>
		<td align='center'>调休</td>
		<td align='center'>事假</td>
		<td align='center'>病假</td>
		<td align='center'>年假</td>
		</tr>
		<%
		String ycqts = "";
		String ycqsss = "";
		String sql = "select count(1) as ycqts, count(1) * 7.5 as ycqsss from (SELECT  TO_CHAR(TO_DATE('"+fromDate+"', 'YYYY-MM-DD') + ROWNUM - 1, 'YYYY-MM-DD') DAY_ID   FROM DUAL "+
                     " CONNECT BY ROWNUM <= TO_DATE('"+toDate+"', 'YYYY-MM-DD') - TO_DATE('"+fromDate+"', 'YYYY-MM-DD') + 1) where app_what_holiday(DAY_ID)=2";
		rs.execute(sql);
		if(rs.next()){
			ycqts = Util.null2String(rs.getString("ycqts"));
			ycqsss = Util.null2String(rs.getString("ycqsss"));
		}
		sql = "select a.id,a.departmentid,a.subcompanyid1,a.lastname,b.departmentname,c.subcompanyname,"+
				"f_getData_type('"+fromDate+"','"+toDate+"',a.id,'cdcs') as cdcs,"+
				"f_getData_type('"+fromDate+"','"+toDate+"',a.id,'ztcs') as ztcs,"+
				"f_getData_type('"+fromDate+"','"+toDate+"',a.id,'txts') as txts,"+
				"f_getData_type('"+fromDate+"','"+toDate+"',a.id,'sjts') as sjts,"+
				"f_getData_type('"+fromDate+"','"+toDate+"',a.id,'bjts') as bjts,"+
				"f_getData_type('"+fromDate+"','"+toDate+"',a.id,'njts') as njts,"+
				"f_getData_type('"+fromDate+"','"+toDate+"',a.id,'ccts') as ccts,"+
				"f_getData_type('"+fromDate+"','"+toDate+"',a.id,'gcts') as gcts,"+
				"f_getData_type('"+fromDate+"','"+toDate+"',a.id,'qqcs') as qqcs, "+
				"f_getData_type('"+fromDate+"','"+toDate+"',a.id,'lqcs') as lqcs, "+
				""+ycqts+"-f_getData_type('"+fromDate+"','"+toDate+"',a.id,'lqcs')/2-f_getData_type('"+fromDate+"','"+toDate+"',a.id,'qqcs') as sjcqts "+
				"from hrmresource a, hrmdepartment b, hrmsubcompany c where a.departmentid=b.id and a.subcompanyid1=c.id and (a.id in(select distinct xm from uf_tsmygskqry) or a.id in(select distinct xm from uf_jtzbkqry))";
		if(!"".equals(resourceId)){
			sql = sql+" and a.id="+resourceId;
		}else if(departmentId != 0 ){
			sql = sql+" and a.departmentid="+departmentId;
		}else if(subCompanyId != 0 ){
			sql = sql+" and a.subcompanyid1="+subCompanyId;
		}else{
			sql = sql+" and 1=2";
		}
		new BaseBean().writeLog("test111:"+sql);
		rs.execute(sql);
		while(rs.next()){

	
		%>
		<tr>
			<td><%=Util.null2String(rs.getString("departmentname"))%></td>
			<td><%=Util.null2String(rs.getString("lastname"))%></td>
			<td align="right"><%=ycqts%></td>
			<td align="right"><%=getTranStr(Util.null2String(rs.getString("sjcqts")))%></td>
			<td align="right"><%=getTranStr(Util.null2String(rs.getString("cdcs")))%></td>
			<td align="right"><%=getTranStr(Util.null2String(rs.getString("ztcs")))%></td>
			<td align="right"><%=getTranStr(Util.null2String(rs.getString("txts")))%></td>
			<td align="right"><%=getTranStr(Util.null2String(rs.getString("sjts")))%></td>
			<td align="right"><%=getTranStr(Util.null2String(rs.getString("bjts")))%></td>
			<td align="right"><%=getTranStr(Util.null2String(rs.getString("njts")))%></td>
			
			<td align="right"><%=getTranStr(Util.null2String(rs.getString("ccts")))%></td>
			<td align="right"><%=getTranStr(Util.null2String(rs.getString("gcts")))%></td>
			<td align="right"><%=getTranStr(Util.null2String(rs.getString("qqcs")))%></td>
			<td align="right"><%=getTranStr(Util.null2String(rs.getString("lqcs")))%></td>
		</tr>
		<%
			}
		%>
		<tr>
			<td colspan="14" align="right" ><%=SystemEnv.getHtmlLabelName(20087,user.getLanguage())+"："+currentDate%></td>
		</tr>
	</tbody>
</table>
<%
	}else if(cmd.equals("HrmScheduleDiffSignInDetail")){
%>
<table  border=1  bordercolor=black style="border-collapse:collapse;" width="100%" >
  <COLGROUP>
  <COL width="13%">
  <COL width="8%">
  <COL width="8%">
  <COL width="12%">
  <COL width="20%">
  <COL width="10%">
  <COL width="12%">
  <COL width="16%">
  </COLGROUP>
<tbody>
<tr>
	<td colspan="8" align="center" ><font size=4><b><%=fileName%></b></font></td>
</tr>
<tr class=header>
  <td align="center"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(125799,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(20035,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(32531,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(81524,user.getLanguage())%></td>
</tr> 
<%
    String trClass="DataLight";
    HrmScheduleDiffDetSignInManager.setUser(user);
    List scheduleList=HrmScheduleDiffDetSignInManager.getScheduleList(fromDate,toDate,subCompanyId,departmentId,resourceId);
    Map scheduleMap=null;
	for(int i=0 ; i<scheduleList.size() ; i++ ) {
		scheduleMap=(Map)scheduleList.get(i);
%>
<tr class="<%=trClass%>">
  <td align="left"><%=strUtil.vString(scheduleMap.get("departmentName"))%></td>
  <td align="left"><%=strUtil.vString(scheduleMap.get("resourceName"))%></td>
  <td align="left"><%=strUtil.vString(scheduleMap.get("statusName"))%></td>
  <td align="left"><%=strUtil.vString(scheduleMap.get("signDate"))%></td>
  <td align="left"><%=strUtil.vString(scheduleMap.get("scheduleName"))%></td>
  <td align="left"><%=strUtil.vString(scheduleMap.get("signTime"))%></td>
  <td align="left"><%=strUtil.vString(scheduleMap.get("clientAddress"))%></td>
  <td align="left"><%=strUtil.vString(scheduleMap.get("addrDetail"))%></td>
</tr>
<%    
		if(trClass.equals("DataLight")){
			trClass="DataDark";
		}else{
			trClass="DataLight";
		}
	} 
%>
</tbody>
</table>
<%
	}else if(cmd.equals("HrmScheduleDiffSignOutDetail")){
%>
<table  border=1  bordercolor=black style="border-collapse:collapse;" width="100%" >
  <COLGROUP>
  <COL width="13%">
  <COL width="8%">
  <COL width="8%">
  <COL width="12%">
  <COL width="20%">
  <COL width="10%">
  <COL width="12%">
  <COL width="16%">
  </COLGROUP>
<tbody>
<tr>
	<td colspan="8" align="center" ><font size=4><b><%=fileName%></b></font></td>
</tr>
<tr class=header>
  <td align="center"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(125799,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(20039,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(32531,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(81524,user.getLanguage())%></td>
</tr> 
<% 
    String trClass="DataLight";
    HrmScheduleDiffDetSignOutManager.setUser(user);
    List scheduleList=HrmScheduleDiffDetSignOutManager.getScheduleList(fromDate,toDate,subCompanyId,departmentId,resourceId);
    Map scheduleMap=null;
	for(int i=0 ; i<scheduleList.size() ; i++ ) {
		scheduleMap=(Map)scheduleList.get(i);
%>
<tr class="<%=trClass%>">
  <td align="left"><%=strUtil.vString(scheduleMap.get("departmentName"))%></td>
  <td align="left"><%=strUtil.vString(scheduleMap.get("resourceName"))%></td>
  <td align="left"><%=strUtil.vString(scheduleMap.get("statusName"))%></td>
  <td align="left"><%=strUtil.vString(scheduleMap.get("signDate"))%></td>
  <td align="left"><%=strUtil.vString(scheduleMap.get("scheduleName"))%></td>
  <td align="left"><%=strUtil.vString(scheduleMap.get("signTime"))%></td>
  <td align="left"><%=strUtil.vString(scheduleMap.get("clientAddress"))%></td>
  <td align="left"><%=strUtil.vString(scheduleMap.get("addrDetail"))%></td>
</tr>
<%    
		if(trClass.equals("DataLight")){
			trClass="DataDark";
		}else{
			trClass="DataLight";
		}
	} 
%>
</tbody>
</table>
<%		
	}else if(cmd.equals("HrmScheduleDiffBeLateDetail")){
%>
<table  border=1  bordercolor=black style="border-collapse:collapse;" width="100%" >
  <COLGROUP>
  <COL width="13%">
  <COL width="8%">
  <COL width="8%">
  <COL width="12%">
  <COL width="20%">
  <COL width="10%">
  <COL width="12%">
  <COL width="16%">
  </COLGROUP>
<tbody>
<tr>
	<td colspan="8" align="center" ><font size=4><b><%=fileName%></b></font></td>
</tr>
<tr class=header>
  <td align="center"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(125799,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(20035,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(32531,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(81524,user.getLanguage())%></td>
</tr> 
<%
 String trClass="DataLight";
  String sql= "select a.id,b.lastname as resourceName,c.departmentname,case when b.status='1' then '正式' when b.status='0' then '试用' when b.status='5' then '离职' else '正式' end as statusName,atten_day as signDate,am_begin_time||'-'||pm_end_time as scheduleName,atten_start_time as signTime,'' as clientAddress,'' as addrDetail from uf_all_atten_info a ,hrmresource b,hrmdepartment c where a.emp_id=b.id and b.departmentid=c.id and nvl(late_times,0)>0 and atten_day <='"+toDate+"' and atten_day>='"+fromDate+"'";
	if(!"".equals(resourceId)){
			sql = sql+" and b.id="+resourceId;
		}else if(departmentId != 0 ){
			sql = sql+" and b.departmentid="+departmentId;
		}else if(subCompanyId != 0 ){
			sql = sql+" and b.subcompanyid1="+subCompanyId;
		}else{
			sql = sql+" and 1=2";
		}
	rs.execute(sql);
	while(rs.next()){

%>
<tr class="<%=trClass%>">
  <td align="left"><%=strUtil.vString(rs.getString("departmentName"))%></td>
  <td align="left"><%=strUtil.vString(rs.getString("resourceName"))%></td>
  <td align="left"><%=strUtil.vString(rs.getString("statusName"))%></td>
  <td align="left"><%=strUtil.vString(rs.getString("signDate"))%></td>
  <td align="left"><%=strUtil.vString(rs.getString("scheduleName"))%></td>
  <td align="left"><%=strUtil.vString(rs.getString("signTime"))%></td>
  <td align="left"><%=strUtil.vString(rs.getString("clientAddress"))%></td>
  <td align="left"><%=strUtil.vString(rs.getString("addrDetail"))%></td>
</tr>
<%    
		if(trClass.equals("DataLight")){
			trClass="DataDark";
		}else{
			trClass="DataLight";
		}
	} 
%>
</tbody>
</table>
<%		
	}else if(cmd.equals("HrmScheduleDiffLeaveEarlyDetail")){
%>
<table  border=1  bordercolor=black style="border-collapse:collapse;" width="100%" >
  <COLGROUP>
  <COL width="13%">
  <COL width="8%">
  <COL width="8%">
  <COL width="12%">
  <COL width="20%">
  <COL width="10%">
  <COL width="12%">
  <COL width="16%">
  </COLGROUP>
<tbody>
<tr>
	<td colspan="8" align="center" ><font size=4><b><%=fileName%></b></font></td>
</tr>
<tr class=header>
  <td align="center"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(125799,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(20039,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(32531,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(81524,user.getLanguage())%></td>
</tr> 
<%
	String trClass="DataLight";
    String sql= "select a.id,b.lastname as resourceName,c.departmentname,case when b.status='1' then '正式' when b.status='0' then '试用' when b.status='5' then '离职' else '正式' end as statusName,atten_day as signDate,am_begin_time||'-'||pm_end_time as scheduleName,atten_end_time as signTime,'' as clientAddress,'' as addrDetail from uf_all_atten_info a ,hrmresource b,hrmdepartment c where a.emp_id=b.id and b.departmentid=c.id and nvl(early_leave_times,0)>0 and atten_day <='"+toDate+"' and atten_day>='"+fromDate+"'";
	if(!"".equals(resourceId)){
			sql = sql+" and b.id="+resourceId;
		}else if(departmentId != 0 ){
			sql = sql+" and b.departmentid="+departmentId;
		}else if(subCompanyId != 0 ){
			sql = sql+" and b.subcompanyid1="+subCompanyId;
		}else{
			sql = sql+" and 1=2";
		}
	rs.execute(sql);
	while(rs.next()){

%>
<tr class="<%=trClass%>">
  <td align="left"><%=strUtil.vString(rs.getString("departmentName"))%></td>
  <td align="left"><%=strUtil.vString(rs.getString("resourceName"))%></td>
  <td align="left"><%=strUtil.vString(rs.getString("statusName"))%></td>
  <td align="left"><%=strUtil.vString(rs.getString("signDate"))%></td>
  <td align="left"><%=strUtil.vString(rs.getString("scheduleName"))%></td>
  <td align="left"><%=strUtil.vString(rs.getString("signTime"))%></td>
  <td align="left"><%=strUtil.vString(rs.getString("clientAddress"))%></td>
  <td align="left"><%=strUtil.vString(rs.getString("addrDetail"))%></td>
</tr>
<%    
		if(trClass.equals("DataLight")){
			trClass="DataDark";
		}else{
			trClass="DataLight";
		}
	} 
%>
</tbody>
</table>
<%		
	}else if(cmd.equals("HrmScheduleDiffAbsentFromWorkDetail")){
%>
	<table  border=1  bordercolor=black style="border-collapse:collapse;" width="100%" >
  <COLGROUP>
  <COL width="20%">
  <COL width="25%">
  <COL width="15%">
  <COL width="15%">
  <COL width="30%">
  </COLGROUP>
<tbody>
<tr>
	<td colspan="5" align="center" ><font size=4><b><%=fileName%></b></font></td>
</tr>
<tr class=header>
  <td align="center"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(125799,user.getLanguage())%></td>
</tr> 
 

<%
    String trClass="DataLight";
    String sql= "select a.id,b.lastname as resourceName,c.departmentname,case when b.status='1' then '正式' when b.status='0' then '试用' when b.status='5' then '离职' else '正式' end as statusName,atten_day as currentDate,am_begin_time||'-'||pm_end_time as scheduleName,atten_start_time as signTime,'' as clientAddress,'' as addr from uf_all_atten_info a ,hrmresource b,hrmdepartment c where a.emp_id=b.id and b.departmentid=c.id and nvl(isex,-1)='2' and atten_day <='"+toDate+"' and atten_day>='"+fromDate+"'";
	if(!"".equals(resourceId)){
			sql = sql+" and b.id="+resourceId;
		}else if(departmentId != 0 ){
			sql = sql+" and b.departmentid="+departmentId;
		}else if(subCompanyId != 0 ){
			sql = sql+" and b.subcompanyid1="+subCompanyId;
		}else{
			sql = sql+" and 1=2";
		}
	rs.execute(sql);
	while(rs.next()){
%>
<tr class="<%=trClass%>">
  <td align="left"><%=strUtil.vString(rs.getString("departmentName"))%></td>
  <td align="left"><%=strUtil.vString(rs.getString("resourceName"))%></td>
  <td align="left"><%=strUtil.vString(rs.getString("statusName"))%></td>
  <td align="left"><%=strUtil.vString(rs.getString("currentDate"))%></td>
  <td align="left"><%=strUtil.vString(rs.getString("scheduleName"))%></td>
</tr>
<%    
        if(trClass.equals("DataLight")){
	        trClass="DataDark";
        }else{
	        trClass="DataLight";
		}
 } 
%>
</tbody>
</table>
<%		
	}else if(cmd.equals("HrmScheduleDiffNoSignDetail")){
%>
	<table  border=1  bordercolor=black style="border-collapse:collapse;" width="100%" >
  <COLGROUP>
  <COL width="20%">
  <COL width="25%">
  <COL width="15%">
  <COL width="15%">
  <COL width="30%">
  </COLGROUP>
<tbody>
<tr>
	<td colspan="5" align="center" ><font size=4><b><%=fileName%></b></font></td>
</tr>
<tr class=header>
  <td align="center"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(125799,user.getLanguage())%></td>
</tr> 
 

<%
    String trClass="DataLight";
     String sql= "select a.id,b.lastname as resourceName,c.departmentname,case when b.status='1' then '正式' when b.status='0' then '试用' when b.status='5' then '离职' else '正式' end as statusName,atten_day as currentDate,am_begin_time||'-'||pm_end_time as scheduleName,atten_start_time as signTime,'' as clientAddress,'' as addr from uf_all_atten_info a ,hrmresource b,hrmdepartment c where a.emp_id=b.id and b.departmentid=c.id and nvl(isex,-1)='1' and atten_day <='"+toDate+"' and atten_day>='"+fromDate+"'";
	if(!"".equals(resourceId)){
			sql = sql+" and b.id="+resourceId;
		}else if(departmentId != 0 ){
			sql = sql+" and b.departmentid="+departmentId;
		}else if(subCompanyId != 0 ){
			sql = sql+" and b.subcompanyid1="+subCompanyId;
		}else{
			sql = sql+" and 1=2";
		}
	rs.execute(sql);
	while(rs.next()){
%>
<tr class="<%=trClass%>">
  <td align="left"><%=strUtil.vString(rs.getString("departmentName"))%></td>
  <td align="left"><%=strUtil.vString(rs.getString("resourceName"))%></td>
  <td align="left"><%=strUtil.vString(rs.getString("statusName"))%></td>
  <td align="left"><%=strUtil.vString(rs.getString("currentDate"))%></td>
  <td align="left"><%=strUtil.vString(rs.getString("scheduleName"))%></td>
</tr>
<%    
        if(trClass.equals("DataLight")){
	        trClass="DataDark";
        }else{
	        trClass="DataLight";
		}
 } 
%>
</tbody>
</table>
<%		
	}else if(cmd.equals("HrmScheduleDiffLeaveDetail")){
%>
	<table  border=1  bordercolor=black style="border-collapse:collapse;" width="100%" >
  <COLGROUP>
  <COL width="15%">
  <COL width="10%">
  <COL width="20%">
  <COL width="20%">
  <COL width="10%">
  <COL width="15%">
  <COL width="10%">
<tbody>
<tr>
	<td colspan="7" align="center" ><font size=4><b><%=fileName%></b></font></td>
</tr>
<tr class=header>
  <td align="center"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(15378,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(828,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(1881,user.getLanguage())%></td>
</tr> 
<%
    String trClass="DataLight";
    List scheduleList=HrmScheduleDiffOtherManager.getScheduleList(user,fromDate,toDate,subCompanyId,departmentId,resourceId,0,status);
    Map scheduleMap=null;
	for(int i=0 ; i<scheduleList.size() ; i++ ) {
		scheduleMap=(Map)scheduleList.get(i);
%>
<tr class="<%=trClass%>">
  <td align="left"><%=strUtil.vString((String)scheduleMap.get("departmentName"))%></td>
  <td align="left"><%=strUtil.vString((String)scheduleMap.get("resourceName"))%></td>
  <td align="left"><%=strUtil.vString((String)scheduleMap.get("startTime"))%></td>
  <td align="left"><%=strUtil.vString((String)scheduleMap.get("endTime"))%></td>
  <td align="left"><%=strUtil.vString((String)scheduleMap.get("status"))%></td>
  <td align="left"><%=strUtil.vString((String)scheduleMap.get("leaveDays"))%></td>
  <td align="left"><%=strUtil.vString((String)scheduleMap.get("leaveType"))%></td>
</tr>
<%    
		if(trClass.equals("DataLight")){
			trClass="DataDark";
		}else{
			trClass="DataLight";
		}
	} 
%>
</tbody>
</table>
<%		
	}else if(cmd.equals("HrmScheduleDiffEvectionDetail")){
%>
	<table  border=1  bordercolor=black style="border-collapse:collapse;" width="100%" >
  <COLGROUP>
  <COL width="15%">
  <COL width="15%">
  <COL width="20%">
  <COL width="20%">
  <COL width="15%">
  <COL width="15%">
<tbody>
<tr>
	<td colspan="6" align="center" ><font size=4><b><%=fileName%></b></font></td>
</tr>
<tr class=header>
  <td align="center"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(15378,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(20095,user.getLanguage())%></td>
</tr> 
<%
    String trClass="DataLight";
    List scheduleList=HrmScheduleDiffOtherManager.getScheduleList(user,fromDate,toDate,subCompanyId,departmentId,resourceId,1,status);
    Map scheduleMap=null;
	for(int i=0 ; i<scheduleList.size() ; i++ ) {
		scheduleMap=(Map)scheduleList.get(i);
%>
<tr class="<%=trClass%>">
  <td align="left"><%=strUtil.vString((String)scheduleMap.get("departmentName"))%></td>
  <td align="left"><%=strUtil.vString((String)scheduleMap.get("resourceName"))%></td>
  <td align="left"><%=strUtil.vString((String)scheduleMap.get("startTime"))%></td>
  <td align="left"><%=strUtil.vString((String)scheduleMap.get("endTime"))%></td>
  <td align="left"><%=strUtil.vString((String)scheduleMap.get("status"))%></td>
  <td align="left"><%=strUtil.vString((String)scheduleMap.get("days"))%></td>
</tr>
<%    
		if(trClass.equals("DataLight")){
			trClass="DataDark";
		}else{
			trClass="DataLight";
		}
	} 
%> 
</tbody>
</table>
<%		
	}else if(cmd.equals("HrmScheduleDiffOutDetail")){
%>
<table  border=1  bordercolor=black style="border-collapse:collapse;" width="100%" >
  <COLGROUP>
  <COL width="15%">
  <COL width="15%">
  <COL width="20%">
  <COL width="20%">
  <COL width="15%">
  <COL width="15%">
<tbody>
<tr>
	<td colspan="6" align="center" ><font size=4><b><%=fileName%></b></font></td>
</tr>
<tr class=header>
  <td align="center"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(15378,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(20096,user.getLanguage())%></td>
</tr> 
<%
    String trClass="DataLight";
    List scheduleList=HrmScheduleDiffOtherManager.getScheduleList(user,fromDate,toDate,subCompanyId,departmentId,resourceId,2,status);
    Map scheduleMap=null;
	for(int i=0 ; i<scheduleList.size() ; i++ ) {
		scheduleMap=(Map)scheduleList.get(i);
%>
<tr class="<%=trClass%>">
  <td align="left"><%=strUtil.vString((String)scheduleMap.get("departmentName"))%></td>
  <td align="left"><%=strUtil.vString((String)scheduleMap.get("resourceName"))%></td>
  <td align="left"><%=strUtil.vString((String)scheduleMap.get("startTime"))%></td>
  <td align="left"><%=strUtil.vString((String)scheduleMap.get("endTime"))%></td>
  <td align="left"><%=strUtil.vString((String)scheduleMap.get("status"))%></td>
  <td align="left"><%=strUtil.vString((String)scheduleMap.get("days"))%></td>
</tr>
<%    
		if(trClass.equals("DataLight")){
			trClass="DataDark";
		}else{
			trClass="DataLight";
		}
	} 
%> 
</tbody>
</table>
<%
	}else if(cmd.equals("HrmScheduleDiffOtherDetail")){
%>
<table  border=1  bordercolor=black style="border-collapse:collapse;" width="100%" >
  <COLGROUP>
  <COL width="30%">
  <COL width="15%">
  <COL width="20%">
  <COL width="20%">
  <COL width="15%">
<tbody>
<tr>
	<td colspan="5" align="center" ><font size=4><b><%=fileName%></b></font></td>
</tr>
<tr class=header>
  <td align="center"><%=SystemEnv.getHtmlLabelName(1334,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(15378,user.getLanguage())%></td>
</tr> 
<%
    String trClass="DataLight";
    List scheduleList=HrmScheduleDiffOtherManager.getScheduleList(user,fromDate,toDate,subCompanyId,departmentId,resourceId,4,status);
    Map scheduleMap=null;
	for(int i=0 ; i<scheduleList.size() ; i++ ) {
		scheduleMap=(Map)scheduleList.get(i);
%>
<tr class="<%=trClass%>">
  <td align="left"><%=strUtil.vString((String)scheduleMap.get("outName"))%></td>
  <td align="left"><%=strUtil.vString((String)scheduleMap.get("resourceName"))%></td>
  <td align="left"><%=strUtil.vString((String)scheduleMap.get("startTime"))%></td>
  <td align="left"><%=strUtil.vString((String)scheduleMap.get("endTime"))%></td>
  <td align="left"><%=strUtil.vString((String)scheduleMap.get("status"))%></td>
</tr>
<%    
		if(trClass.equals("DataLight")){
			trClass="DataDark";
		}else{
			trClass="DataLight";
		}
	} 
%>
</tbody>
</table>
<%		
	}else if(cmd.equals("HrmScheduleDiffMonthAttDetail")){
		//当查询条件只是部门的时候，需要重新获取部门对应的分部
		if(departmentId > 0) {
			if(subCompanyId <= 0) subCompanyId = strUtil.parseToInt(DepartmentComInfo.getSubcompanyid1(String.valueOf(departmentId)), 0);
		}
		int __year = ____cal.get(Calendar.YEAR), __month = ____cal.get(Calendar.MONTH), fDay = ____Fday.get(Calendar.DATE), lDay = ____Lday.get(Calendar.DATE);
		boolean isAfter = __month >= strUtil.parseToInt(dateUtil.getMonth(), 0) && __year >= strUtil.parseToInt(dateUtil.getYear(), 0);
%>
	<table id="monthAttData" class="altrowstable" border=1 cellspacing=0 cellpadding=0 style="width:99.7%;margin-left: 0.2%;margin-top: -1px">
		<%out.println("<tr><td align='center' colspan='"+(lDay+2)+"'><font size=4><b>"+fileName+"</b></font></td></tr>");%>
		<tr style="height:2px;background-color: #f7f7f7;">
			<td style="width:3%;text-align:center;"><%=strUtil.addWords(SystemEnv.getHtmlLabelName(413,user.getLanguage()), "<br>")%></td>
			<td style="width:3%;text-align:center;"><%=strUtil.addWords(SystemEnv.getHtmlLabelName(124,user.getLanguage()), "<br>")%></td>
			<%for(int __date=fDay; __date<=lDay; __date++) out.println("<td height=\"20px\" width=\"3%\" ALIGN=CENTER>"+__date+"</td>");%>
		</tr>
		<%
		List hList = holidayManager.find("[map]countryid:1;sql_holidaydate:and t.holidaydate like '"+__year+"%'");
		int hSize = hList == null ? 0 : hList.size();
		HrmPubHoliday hBean = null;
		Calendar tempday = Calendar.getInstance();
		Map colorMap = new HashMap();
		int curDay = 0;
		String bgColor = "", curDate = "";
		for(int __date=fDay; __date<=lDay; __date++){
			tempday.clear();
			tempday.set(__year, __month, __date);
			curDay = tempday.getTime().getDay();
			bgColor = curDay == 0 || curDay == 6 ? "#f7f7f7" : "";
			curDate = dateUtil.getDate(tempday.getTime());
			for(int j=0; j<hSize; j++) {
				hBean = (HrmPubHoliday)hList.get(j);
				if(curDate.equals(hBean.getHolidaydate())){
					switch(hBean.getChangetype()) {
					case 1 :
						bgColor = "RED";
						break ;
					case 2 :
						bgColor = "GREEN";
						break ;
					case 3 :
						bgColor = "MEDIUMBLUE";
						break ;
					}
					break;
				}
			}
			colorMap.put(curDate, bgColor);
		}
		monthAttManager.setUser(user);
		String sql_dt = "";
		String sql = "select a.id,a.lastname,b.departmentname  from hrmresource a, hrmdepartment b, hrmsubcompany c where a.departmentid=b.id and a.subcompanyid1=c.id and (a.id in(select distinct xm from uf_tsmygskqry) or a.id in(select distinct xm from uf_jtzbkqry))";
		if(!"".equals(resourceId)){
			sql = sql+" and a.id="+resourceId;
		}else if(departmentId !=0){
			sql = sql+" and a.departmentid="+departmentId;
		}else if(subCompanyId != 0){
			sql = sql+" and a.subcompanyid1="+subCompanyId;
		}else{
			sql = sql+" and 1=2";
		}
		rs.execute(sql);
		while(rs.next()){
			out.println("<tr>");
			out.println("<td style=\"border-color:#E6E6E6;text-align:center;\" title=\""+Util.null2String(rs.getString("lastname"))+"\">"+Util.null2String(rs.getString("lastname"))+"</td>");
			out.println("<td style=\"border-color:#E6E6E6;text-align:center;\" title=\""+Util.null2String(rs.getString("departmentname"))+"\">"+Util.null2String(rs.getString("departmentname"))+"</td>");
			for(int __date=fDay; __date<=lDay; __date++){
				tempday.clear();
				tempday.set(__year, __month, __date);
				String curValue = "";
				curDate = dateUtil.getDate(tempday.getTime());
				sql_dt = "select getEmpStatus("+Util.null2String(rs.getString("id"))+",'"+curDate+"') as status from dual";
				rs_dt.execute(sql_dt);
				if(rs_dt.next()){
					curValue = Util.null2String(rs_dt.getString("status"));
				}
				if(curValue.equals("Y")){
					curValue = "√";
				}

		%>
				<td height="20px" align="center" style="background-color:<%=strUtil.vString(colorMap.get(curDate))%>;border-color: #E6E6E6;"><%=isAfter ? "" :curValue %></td>
		<%
			}
			out.println("</tr>");
		}
		%>
	</table>
<%		
	}else if(cmd.equals("HrmScheduleDiffMonthAttDateDetail")){
		String curDate = strUtil.vString(request.getParameter("curDate"), fromDate);
		resourceId = strUtil.vString(request.getParameter("resourceId"));
		HrmScheduleDiffUtil.setUser(user);
		monthAttManager.setUser(user);
		subCompanyId = strUtil.parseToInt(ResourceComInfo.getSubCompanyID(resourceId));
		Map timeMap = HrmScheduleDiffUtil.getOnDutyAndOffDutyTimeMap(curDate, subCompanyId);
		
		List fList = monthAttManager.getScheduleList(curDate, curDate, resourceId);
		boolean showFList = fList!=null && fList.size() > 0;
		String[] colWidths = "15%,13%,13%,24%,15%,15%".split(",");
		String[] colNames = "124;413;97;125799;20035;20039".split(";");
		Map map = null;
%>
<table  border=1  bordercolor=black style="border-collapse:collapse;" width="100%" >
<tbody>
<tr>
	<td align="center" colspan="<%=colWidths.length%>"><font size=4><b><%=fileName%></b></font></td>
</tr>
<%if(showFList){%>
<tr class="header">
	<td align="left" colspan="<%=colWidths.length%>"><%=SystemEnv.getHtmlLabelNames("15880,17463",user.getLanguage())%></td>
</tr>
<%}%>
<tr class="header">
	<%for(int i=0; i<colWidths.length; i++) out.println("<td align='center' width='"+colWidths[i]+"'>"+SystemEnv.getHtmlLabelNames(colNames[i],user.getLanguage())+"</td>");%>
</tr> 
<%
    String trClass="DataLight";
    String sql ="select a.id,b.lastname as resourceName,c.departmentName,atten_day as signDate,am_begin_time||'-'||pm_end_time as scheduleName,atten_start_time as signInTime,atten_end_time as signOutTime from uf_all_atten_info a ,hrmresource b,hrmdepartment c where a.emp_id=b.id and b.departmentid=c.id and a.emp_id="+resourceId+" and a.atten_day='"+curDate+"'";
		rs.execute(sql);
		while(rs.next()){
%>
<tr class="<%=trClass%>">
  <td align="left"><%=strUtil.vString(rs.getString("departmentName"))%></td>
  <td align="left"><%=strUtil.vString(rs.getString("resourceName"))%></td>
  <td align="left"><%=strUtil.vString(rs.getString("signDate"))%></td>
  <td align="left"><%=strUtil.vString(rs.getString("scheduleName"))%></td>
  <td align="left"><%=strUtil.vString(rs.getString("signInTime"))%></td>
  <td align="left"><%=strUtil.vString(rs.getString("signOutTime"))%></td>
</tr>
<%    
	trClass = trClass.equals("DataLight") ? "DataDark" : "DataLight";
	}
%>
</tbody>
</table>
<%if(showFList){%>
<table  border=1  bordercolor=black style="border-collapse:collapse;" width="100%" >
<tbody>
<tr class="header">
	<td align="left" colspan="<%=colWidths.length%>"><%=SystemEnv.getHtmlLabelNames("15880,18015",user.getLanguage())%></td>
</tr>
<tr class="header">
	<td align='center' width='20%'><%=SystemEnv.getHtmlLabelName(1334,user.getLanguage())%></td>
	<td align='center' width='12%'><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></td>
	<td align='center' width='15%'><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></td>
	<td align='center' width='15%'><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></td>
	<td align='center' width='12%'><%=SystemEnv.getHtmlLabelName(15378,user.getLanguage())%></td>
	<td align='center' width='14%'><%=SystemEnv.getHtmlLabelName(670,user.getLanguage())+"/"+SystemEnv.getHtmlLabelNames("31345,496",user.getLanguage())%></td>
	<td align='center' width='12%'><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></td>
</tr> 
<%
    trClass="DataLight";
    for(int i=0; i<fList.size(); i++){
		map = (Map)fList.get(i);
%>
<tr class="<%=trClass%>">
  <td align="left"><%=strUtil.vString(map.get("requestName"))%></td>
  <td align="left"><%=strUtil.vString(map.get("resourceName"))%></td>
  <td align="left"><%=strUtil.vString(map.get("startTime"))%></td>
  <td align="left"><%=strUtil.vString(map.get("endTime"))%></td>
  <td align="left"><%=strUtil.vString(map.get("status"))%></td>
  <td align="left"><%=strUtil.vString(map.get("days"))%></td>
  <td align="left"><%=strUtil.vString(map.get("dType"))%></td>
</tr>
<%    
	trClass = trClass.equals("DataLight") ? "DataDark" : "DataLight";
	}
%>
</tbody>
</table>
<%		}
	}else if(cmd.equals("HrmScheduleOvertimeWorkDetail")){
%>
<table  border=1  bordercolor=black style="border-collapse:collapse;" width="100%" >
  <COLGROUP>
  <COL width="30%">
  <COL width="15%">
  <COL width="20%">
  <COL width="20%">
  <COL width="15%">
<tbody>
<tr>
	<td colspan="5" align="center" ><font size=4><b><%=fileName%></b></font></td>
</tr>
<tr class=header>
  <td align="center"><%=SystemEnv.getHtmlLabelName(1334,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(15378,user.getLanguage())%></td>
</tr> 
<%
    String trClass="DataLight";
    List scheduleList=HrmScheduleDiffOtherManager.getScheduleList(user,fromDate,toDate,subCompanyId,departmentId,resourceId,3,false,true,status);
    Map scheduleMap=null;
	for(int i=0 ; i<scheduleList.size() ; i++ ) {
		scheduleMap=(Map)scheduleList.get(i);
%>
<tr class="<%=trClass%>">
  <td align="left"><%=strUtil.vString((String)scheduleMap.get("outName"))%></td>
  <td align="left"><%=strUtil.vString((String)scheduleMap.get("resourceName"))%></td>
  <td align="left"><%=strUtil.vString((String)scheduleMap.get("startTime"))%></td>
  <td align="left"><%=strUtil.vString((String)scheduleMap.get("endTime"))%></td>
  <td align="left"><%=strUtil.vString((String)scheduleMap.get("status"))%></td>
</tr>
<%    
		if(trClass.equals("DataLight")){
			trClass="DataDark";
		}else{
			trClass="DataLight";
		}
	} 
%>
</tbody>
</table>
<%		
	}
%>