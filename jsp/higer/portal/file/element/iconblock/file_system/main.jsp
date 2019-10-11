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
			<div class="containerdiv">
				<div class="level1">
					<div class="level2">
						<div class="level3 item"></div>
						<div class="level3 item"></div>
					</div>
					<div class="level2">
						<div class="level3 item"></div>
						<div class="level3 item"></div>
					</div>
				</div>
				<div class="level1">
					<div class="level2">
						<div class="level3 item"></div>
						<div class="level3 item"></div>
					</div>
					<div class="level2">
						<div class="level3 item"></div>
						<div class="level3 item"></div>
					</div>
				</div>
			</div>
		</div>
		<script type="text/javascript" src="/higer/portal/file/element/js/main/main.js"></script>
		<script type="text/javascript">
			$(function(){
				var jsonNames = <%=jsonNames%>;
				//获取数据
				$.post("Operation.jsp",jsonNames,function(data){
					if(data && data.status == "0"){
						var baseUrl = data.baseUrl
						if(data.list && data.list.length > 0){
							var size = data.list.length;
							data.list.map(function(elt, i) {
								var item = $(".item").eq(i);
								item.attr("_target",baseUrl+elt.link).text(elt.title).css({"background-image":"url("+elt.icon+")","background-color":elt.color}).show();
							});
							var num = 100/(Number(size)/4);
							$(".level1").width(num+"%");
						}
					}
					
					//添加点击事件
					$(".item").bind("click",function(){
						var url = $(this).attr('_target');
						if(url && url!=""){
							window.open(url);
							//openFullWindowHaveBar(url);
						}else{
							$(this).css("cursor","auto");
						}
					}).bind("mouseover",function(){
						$(this).css("opacity",0.6);
					}).bind("mouseout",function(){
						$(this).css("opacity",1);
					});
				},"json");
			});
		</script>
	</body>
</html>