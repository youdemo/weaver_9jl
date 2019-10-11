<%@page import="weaver.conn.RecordSet"%>
<%@page import="org.json.JSONObject"%>
<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%@page import="weaver.general.*"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/plugin/element/util/Util.jsp"%>
<%
	out.clear();
	String key =  Util.null2String(request.getParameter("key"));
	String folder = "iconblock";
	JSONObject json = new JSONObject();
	JSONObject jsonconf = this.getJSONObject(folder,key);
	JSONArray arrs = jsonconf.getJSONArray("list"); 
	String sql = "";
	String userid = user.getUID()+"";
	if(arrs.length()>0){
	  for(int i=0;i<arrs.length();i++){
	    JSONObject obj = arrs.getJSONObject(i);
	    setDataNum(obj,userid,user,request);
	  }
	}
	json.put("datas", formatHrefforList(arrs,user,request));
	json.put("colnum", jsonconf.getString("colnum"));
	json.put("status", "0");
	out.write(json.toString());
%>
<%!
public void setDataNum(JSONObject json,String userid,User user,HttpServletRequest request){
	try{
		JSONObject num = json.getJSONObject("num");
	    String type = num.getString("type");
	    if(type.equals("0")){
	    	if(num.has("sql")){
		    	RecordSet rs = new RecordSet();
		    	String sql = num.getString("sql");
				sql = formatsql(sql,user,request);
		    	rs.executeSql(sql);
		    	if(rs.next()){
		    		json.put("num",rs.getString(1));
		    	}
	    	}else if(num.has("val")){
	    		json.put("num", num.getString("val"));
	    	}
	    }else if(type.equals("0.5")){
	    	RecordSet rs = new RecordSet();
	    	String sql = num.getString("sql");
	      	sql = formatsql(sql,user,request);
	      	rs.executeSql(sql);
	    	if(rs.next()){
	    		json.put("num",rs.getString(1));
	    	}
	    } else{
	    	json.put("num",getNumByType(num,userid,"","",""));
	    }
	} catch (JSONException e) {
		e.printStackTrace();
	}
}
%>