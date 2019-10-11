<%@page import="weaver.conn.RecordSet"%>
<%@page import="org.json.JSONObject"%>
<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%@page import="weaver.general.*"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/higer/portal/file/element/util/Util.jsp"%>
<%
	out.clear();
	String key =  Util.null2String(request.getParameter("key"));
	
	JSONObject jsonconf = this.getHigerJSONObject(key);
	jsonconf.put("list", formatHrefforList(jsonconf.getJSONArray("list"),user,request));
	jsonconf.put("status", "0");
	out.write(jsonconf.toString());
%>