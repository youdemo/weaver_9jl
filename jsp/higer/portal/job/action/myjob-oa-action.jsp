<%@page import="weaver.general.TimeUtil"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
    String taskid =Util.null2String(request.getParameter("taskid"));
	String ryid =Util.null2String(request.getParameter("ryid"));
    String sql = "update tm_taskview set taskid='"+taskid+"',status=(select status from tm_taskinfo where id="+taskid+"),viewdate=to_char(sysdate,'yyyy-mm-dd hh:mi:ss')，menutype=0 where userid="+ryid;
    rs.execute(sql);
    out.print(1);



%>