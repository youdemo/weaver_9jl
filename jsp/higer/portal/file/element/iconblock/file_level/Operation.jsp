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
	JSONObject json = new JSONObject();
	JSONObject jsonconf = this.getHigerJSONObject(key);

	json.put("center", formatHrefforObject(jsonconf.getJSONObject("center"),user,request));
	json.put("top", formatHrefforObject(jsonconf.getJSONObject("top"),user,request));
	json.put("left", formatHrefforObject(jsonconf.getJSONObject("left"),user,request));
	json.put("right",  formatHrefforObject(jsonconf.getJSONObject("right"),user,request));
	json.put("bottom", formatHrefforObject(jsonconf.getJSONObject("bottom"),user,request));
	json.put("brand",jsonconf.getString("brand"));
	json.put("status", "0");
	out.write(json.toString());
%>