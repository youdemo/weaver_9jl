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
				
			</div>
		</div>
		<script type="text/javascript" src="/higer/portal/file/element/js/main/main.js"></script>
		<script type="text/javascript">
			$(function(){
				var jsonNames = <%=jsonNames%>;
				//获取数据
				$.post("Operation.jsp",jsonNames,function(data){
					if(data && data.status == "0"){
						var datas = data.selfJson;
						var baseUrl = data.baseUrl;
						var style = data.style;
						var colnum = Number(data.colnum);
						var width = (100 / colnum);
						
						var linex = "linex1";
						var liney = "liney1";
						if(style=="0"){
							linex = "linex2";
							liney = "liney2";
						}else if(style=="1"){
							linex = "linex1";
							liney = "liney1";
						}else if(style=="2"){
							linex = "linex3";
							liney = "liney3";
						}
						var url = "";
						var cursor = "auto";
						datas.map(function(elt, i) {
							if(elt.outkey && elt.outkey!=""){
								url = baseUrl+elt.outkey;
								cursor = "pointer";
							}else{
								url = "";
								cursor = "auto";
							}
							var title = elt.departmentmark;
							var item = "<div class='block-item' url='"+url+"' title='"+title+"' style='width:"+width+"%;cursor:"+cursor+"'> "+
								"	<img alt='' class='block-item-icon' "+
								"		src='"+elt.icon+"'> "+
								"	<div class='block-item-content'> "+
								"		<div class='block-item-title'> "+
								"			<a href=\"javascript:void(0);\" style=\"cursor:"+cursor+"\"  title='查看"+title+"'>"+title+"</a> "+
								"		</div> "+
								"	</div> "+
								"	<div class='"+linex+"'></div>"+
								getLine(colnum,liney)+
								"</div> ";
							$(".containerdiv").append(item);	
						});
					}
				},"json");
			});
			
			$(".block-item").live("click",function(){
				var url = $(this).attr("url");
				if(url && url!=""){
					window.open(url);
				}
			})
			
			var linenum = 1;
			function getLine(colnum,liney){
				var line = "<div class='"+liney+"'></div>";
				if(linenum++ == colnum){
					linenum = 1;
					line = "";
				}
				return line;
			}
		</script>
	</body>
</html>