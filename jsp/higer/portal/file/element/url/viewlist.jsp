<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="net.sf.json.JSONArray"%>
<%@ page import="org.apache.commons.io.FileUtils"%>
<%@ page import="java.io.*"%>
<%@ page import="weaver.general.GCONST"%>
<%@ page import="weaver.conn.RecordSet"%>
<%@ page import="weaver.file.*"%>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%
   String path = GCONST.getRootPath();
   path = path +"plugin"+ File.separatorChar+"element"+ File.separatorChar+"url";
   File file = new File(path);
   File[] fs = file.listFiles();
   String name = "";
   String str ="";
   JSONArray jsonArray = new JSONArray();
   if(fs!=null && fs.length>0){
	   for(File fi : fs){
		   if(fi.exists()){
			   name = fi.getName();
			   if(name.endsWith(".json")){
				   str= FileUtils.readFileToString(fi, "UTF-8");
				   JSONObject jsonObject = JSONObject.fromObject(str);   
				   jsonArray.add(jsonObject);
			   }
		   }
	   }
   }
%>
<html>
<head>
<style type="text/css">
	.maindiv{
	    width:100%;
	}
	.head {
		height: 52px;
		background-color: #f9f9f9;
		border-bottom: 1px solid #eaeaea;
		position: relative;
	}
	
	.title {
		height: 52px;
		line-height: 52px;
		padding-left: 20px;
	}
	
	.headtr {
		line-height: 40px;
		background: #f7f7f7;
	}
	
	.table {
		width: 98%;
		line-height: 38px;
		border-collapse: collapse;
		overflow-y: auto;
		margin:0 auto;
		margin-top: 20px;
		border:1px solid #e9e9e9;
	}
	
	.table tr {
		border-bottom: 1px solid #e9e9e9;
	}
	
	.table tr:hover {
		background: #E9F7FF;
	}
	
	.table tr:hover td {
		background: none;
	}
	
	.table td {
		padding: 0 10px 0 15px;
	}
	
	.sign {
		margin-right: 5px;
		font-weight: bold;
	}
</style>
</head>
<body>
	<div class="maindiv">
		<div class="head">
			<span class="icon-coms-news"></span> <span class="title">元素列表</span>
		</div>
		<table class="table">
			<colgroup>
				<col width="30%" />
				<col width="40%" />
				<col width="30%" />
			</colgroup>
			<tr class="headtr">
				<td>元素名称</td>
				<td>访问地址</td>
				<td>创建时间</td>
			</tr>
			<%
			for(int i= 0;i<jsonArray.size();i++){
				  JSONObject jsonData = jsonArray.getJSONObject(i);  
				  String name1 = jsonData.getString("name");
				  String url = jsonData.getString("url");
				  String date = jsonData.getString("date");
				    %>
			<tr>
				<td style="cursor: pointer;" onclick="jump('<%=url %>')"><span class="sign">.</span><%=name1 %></td>
				<td><%=url %></td>
				<td><%=date %></td>
			</tr>
			<%
			}
			%>
		</table>
	</div>
	<script type="text/javascript">
	   function jump(url){
		   window.open(url);
	   }
	   $(function(){
		   var theight = window.innerHeight;
		   $(".table").height(theight-100);
	   })
	</script>
</body>
</html>