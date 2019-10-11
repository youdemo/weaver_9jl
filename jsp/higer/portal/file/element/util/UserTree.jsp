<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<%
	int hassub = Util.getIntValue(request.getParameter("hassub"),0);
%>
<HTML>
	<HEAD>
		<link href="/performance/css/jquery.jscrollpane.css" rel="stylesheet" />
		
		<link type='text/css' rel='stylesheet' href='/secondwev/tree/js/treeviewAsync/eui.tree.css' />
		<link type='text/css' rel='stylesheet' href='/workrelate/plan/css/tree.css' />
		<script type='text/javascript' src='/secondwev/tree/js/treeviewAsync/jquery.treeview.js'></script>
		<script type='text/javascript' src='/secondwev/tree/js/treeviewAsync/jquery.treeview.async.js'></script>
		
		<style type="text/css">
			.tab{width: 100%;float: left;line-height: 26px;height: 26px;text-align: center;cursor: pointer;background-color: #ECECEC;}
			.tab1{background: url('/performance/images/org_tab1.png') center no-repeat;background-color: #ECECEC;}
			.tab1_click{background: url('/performance/images/org_tab1_click.png') center no-repeat;background-color: #656565;color: #fff;}
			.tab2{background: url('/performance/images/org_tab2.png') center no-repeat;background-color: #ECECEC;}
			.tab2_click{background: url(/performance/images/org_tab2_click.png') center no-repeat;background-color: #656565;color: #fff;}
			.frmCenterOpen{background: url('/performance/images/fopen.png') center no-repeat;}
			.frmCenterClose{background: url('/performance/images/fclose.png') center no-repeat;}
		</style>
	<%@ include file="/secondwev/common/head.jsp" %>
	</head>
	<body style="margin: 0px;overflow: hidden;" id="body">
		<div style="width: 180px;height: 100%;float:left;" id="dleft">
			<%
				if(hassub==1){
			%>
			<table style="width: 100%;" cellpadding="0" cellspacing="0" border="0">
				<tr>
					<td width="50%"><div id="tab1" class="tab tab1 tab1_click" _index="1"></div></td>
					<td width="50%"><div id="tab2" class="tab tab2" _index="2"></div></td>
				</tr>
			</table>
			<%	} %>
			<div class="mine"><a href="javascript:doClick(<%=user.getUID() %>,4)">本人</a></div>
			<%if(hassub==1){%>
			<div id="subOrgDiv" class="divorg" style="width: 100%;height: 100%;"></div>
			<div id="hrmOrgDiv" class="divorg" style="width: 100%;height: 100%;display: none;"></div>
			<%}else{%>
			<div id="subOrgDiv" class="divorg" style="width: 100%;height: 100%;"></div>
			<%} %>
		</div>
		<div id="showFrame" class="frmCenterOpen" show="true"
	      onclick="mnToggleleft(this)"  style="overflow: hidden;background-repeat: no-repeat;overflow: hidden;
	      background-color: #D6D6D6;border: 0px;width:8px;height:100%;float:left;">
		</div>
		<script type="text/javascript">
			jQuery(document).ready(function() {
				setHeight();
				<%if(hassub==1){%>
				$("div.tab").bind("click",function(){
					var _index = $(this).attr("_index");
					if(_index==1){
						$(this).addClass("tab1_click");
						$("#tab2").removeClass("tab2_click");
						$("#subOrgDiv").show();
						$("#hrmOrgDiv").hide();
					}else{
						$(this).addClass("tab2_click");
						$("#tab1").removeClass("tab1_click");
						$("#subOrgDiv").hide();
						$("#hrmOrgDiv").show();
					}
				});
			    jQuery("#hrmOrgDiv").append('<ul id="hrmOrgTree" class="hrmOrg" style="width:100%;outline:none;"></ul>');
				jQuery("#hrmOrgTree").treeview({
			       url:"/secondwev/tree/hrmOrgTree.jsp"
			    });
				<%}%>
				jQuery("#subOrgDiv").append('<ul id="subOrgTree" class="hrmOrg" style="width:100%;outline:none;"></ul>');
				jQuery("#subOrgTree").treeview({
			       url:"/secondwev/tree/hrmOrgTree.jsp",
			       root:"hrm|<%=user.getUID()%>"
			    });
			    
			});
			function doClick(orgId, type, obj) {
				if(parent.pageRight){
					parent.doClick(orgId,type);
				}
				if (obj) {
					jQuery(obj).css("font-weight", "normal");
					jQuery(obj).parent().parent().find(".selected").removeClass(
							"selected");
					jQuery(obj).parent().addClass("selected");
				}
			}
			jQuery(window).resize(function(){
				setHeight();
			});
			function setHeight(){
				var h = document.body.clientHeight-24;
				<%if(hassub==1){%> 
				h = document.body.clientHeight-50;
				<%}%>
				jQuery("#subOrgDiv").height(h);
				jQuery("#hrmOrgDiv").height(h);
			}
			function mnToggleleft(obj){
				var bodyId = $(window.parent.document).find("#bodyId");
				if(bodyId==null || bodyId==undefined || bodyId=="undefined"){
					bodyId = $("#body")
				}
				var dRight = $(window.parent.document).find("#dRight");
				var dLeft = $(window.parent.document).find("#dLeft");
				if($("#showFrame").attr("show")=="true"){
						$("#showFrame").removeClass("frmCenterOpen");
						$("#showFrame").addClass("frmCenterClose");
						if(dLeft.length>0){
							dLeft.width("8px");
						}
						$("#dleft").width("0px");
						$(".mine").hide();
						$("#showFrame").attr("show","false");
				}else{
						$("#showFrame").removeClass("frmCenterClose");
						$("#showFrame").addClass("frmCenterOpen");
						if(dLeft.length>0){
							dLeft.width("188px");
						}
						$("#dleft").width("180px");
						$(".mine").show();
						$("#showFrame").attr("show","true");
				}
				if(dRight.length>0){
					dRight.width(bodyId.width()-dLeft.width());
				}
			}
		</script>
	</body>
</html>
