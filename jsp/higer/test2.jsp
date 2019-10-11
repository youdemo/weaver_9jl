<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.general.BaseBean"%>
<%@ page import="higer.portal.job.GetJobWData"%>
<%@ page import="java.util.*,weaver.hrm.appdetach.*"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.formmode.setup.ModeRightInfo"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs_dt" class="weaver.conn.RecordSet" scope="page" />
<%
  GetJobWData scl=new GetJobWData();
  // "1" 可以改成被提醒人
  String result = scl.getServiceData("kangtj");
  out.print(result);
%>