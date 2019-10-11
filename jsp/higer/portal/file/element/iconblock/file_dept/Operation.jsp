<%@page import="org.json.JSONArray"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="org.json.JSONObject"%>
<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%@page import="weaver.general.*"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/higer/portal/file/element/util/Util.jsp"%>
<%
    String sql = "select departmentmark,outkey from hrmdepartment where supdepid = 0 and subcompanyid1 = 1021";
	// type=1
	String allFileBaseUrl = "/spa/cube/index.html#/main/cube/search?customid=5501&OUTKEY=";
	// type=2
	String allRecordBaseUrl = "/spa/cube/index.html#/main/cube/search?customid=7514&OUTKEY=";
	// type 标识查询的是所有文件（1） 还是所有记录 （2）
	String type = Util.null2String(request.getParameter("type"));
	String baseUrl = "";
	switch (type){
	case "1":
		baseUrl = allFileBaseUrl;
		break;
	case "2":
		baseUrl = allRecordBaseUrl;
		break;
	default:
		break;
	}
	out.clear();
	String key =  Util.null2String(request.getParameter("key"));
	JSONObject json = new JSONObject();
	JSONObject jsonconf = this.getHigerJSONObject(key);
	JSONArray arrs = jsonconf.getJSONArray("list"); 
	String style= "0";
	if(jsonconf.has("style")){
		style = jsonconf.getString("style");
	}
	json.put("datas", formatHrefforList(arrs,user,request));
	json.put("colnum", jsonconf.getString("colnum"));
	json.put("style", style);
	json.put("status", "0");
	rs.executeSql(sql);
	JSONArray jsonArray = new JSONArray();
	while(rs.next()){
	    JSONObject selfJson = new JSONObject();
	    selfJson.put("departmentmark",rs.getString("departmentmark"));
	    selfJson.put("outkey", rs.getString("outkey"));
		selfJson.put("icon","/higer/portal/file/element/uploadImg/845.png");
	    jsonArray.put(selfJson);
	}
	json.put("selfJson",jsonArray);
	
	json.put("baseUrl",baseUrl);
	out.write(json.toString());
%>