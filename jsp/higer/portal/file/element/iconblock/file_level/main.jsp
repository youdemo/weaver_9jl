<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="org.json.JSONObject"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	String key = Util.null2String(request.getParameter("key"));
	Enumeration pNames=request.getParameterNames();
	JSONObject jsonNames = new JSONObject();
	while(pNames.hasMoreElements()){
	    String name=(String)pNames.nextElement();
	    String value=request.getParameter(name);
	    jsonNames.put(name, value);
	}
%>
<html>
	<head>
		<link rel="stylesheet" href="/higer/portal/file/element/css/main.css" type="text/css" />
		<link rel="stylesheet" href="css/base.css" type="text/css" />
		<style type="text/css">
		</style>
	</head>
	<body>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%
	
	%>
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<%
		%>
		<div class="maindiv">
			<%
			if(key.length() == 0){
				%>
				<div class="errormsg">key不能为空！</div>
				<%
				return;
			}
			%>
			<div id="wea_temp14" class="containerdiv">
				
			</div>
		</div>
		<script type="text/javascript" src="/higer/portal/file/element/js/main/main.js"></script>
		<script type="text/javascript">
			// 发送请求加载配置项
			$(function(){
				var jsonNames = <%=jsonNames%>;
				//获取数据
				var url = "javascript:void(0);";
				var opentype ="";
				var cursor = "auto";
				$.post("Operation.jsp",jsonNames,function(data){
					if(data && data.status == "0"){
						var brand = data.brand;
						var center = data.center;
						var top = data.top;
						var left = data.left;
						var right = data.right;
						var bottom = data.bottom;
						var _html = "";
							_html +="<div class=\"wea-temp14-pieChart wea-temp-shodow\" style=\"border-color: "+top.color+" "+right.color+" "+bottom.color+" "+left.color+"\">";
							if(center.href && center.href!=""){
								url = center.href ;
								opentype = "target=\"_blank\"";
								cursor = "pointer";
							}else{
								
							}
							_html +="<a class=\"wea-temp14-circle\" "+opentype+" style=\"background-color: "+center.color+";cursor:"+cursor+"\" href=\""+url+"\" >"+center.name+"</a>";
							if(left.href && left.href!=""){
								url = left.href ;
								opentype = "target=\"_blank\"";
								cursor = "pointer";
							}else{
								url = "javascript:void(0);";
								opentype ="";
								cursor = "auto";
							}
							_html +="<a class=\"wea-temp14-left\" href=\""+url+"\" "+opentype+" style=\"cursor:"+cursor+"\">"+left.name+"</a>";
							if(top.href && top.href!=""){
								url = top.href ;
								opentype = "target=\"_blank\"";
								cursor = "pointer";
							}else{
								url = "javascript:void(0);";
								opentype ="";
								cursor = "auto";
							}
							_html +="<a class=\"wea-temp14-top\" href=\""+url+"\" "+opentype+" style=\"cursor:"+cursor+"\">"+top.name+"</a>";
							if(right.href && right.href!=""){
								url = right.href ;
								opentype = "target=\"_blank\"";
								cursor = "pointer";
							}else{
								url = "javascript:void(0);";
								opentype ="";
								cursor = "auto";
							}
							_html +="<a class=\"wea-temp14-right\" href=\""+url+"\" "+opentype+" style=\"cursor:"+cursor+"\">"+right.name+"</a>";
							if(bottom.href && bottom.href!=""){
								url = bottom.href ;
								opentype = "target=\"_blank\"";
								cursor = "pointer";
							}else{
								url = "javascript:void(0);";
								opentype ="";
								cursor = "auto";
							}
							_html +="<a class=\"wea-temp14-bottom\" href=\""+url+"\" "+opentype+" style=\"cursor:"+cursor+"\">"+bottom.name+"</a></div>";
						$("#wea_temp14").append(_html);
					}
				},"json");
			});
		</script>
	</body>
</html>