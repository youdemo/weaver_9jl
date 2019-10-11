<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page import="java.util.*"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="WorkflowCount" class="weaver.page.element.WorkflowCount" scope="page" />
<%
String userid = user.getUID()+"";
String portalNo = request.getParameter("portalNo");
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>门户</title>
    <link href="css/style.css" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" href="css/pageSwitch.min.css">
    <script src="js/jquery-1.7.2.min.js" type="text/javascript"></script>
    <style type="text/css">
    *{
        padding: 0;
        margin: 0;
    }
    html,body{
        height: 100%;
    }
    #container {
        width: 100%;
        height: 250px;
        overflow: hidden;
    }
    .sections,.section {
        height:100%;
    }
    #container,.sections {
        position: relative;
    }
    .section {
        background-color: #000;
        background-size: 100% 100%;
        background-position: 50% 50%;
        text-align: center;
        color: white;
    }
	/* 门户菜单样式  IPD*/
	.ipdPortalMenuCls{
		background-color:#f7f7f7;
		height:35px;
		line-height:35px;
	}
	.ipdPortalMenuCls .nav{
		margin-left: 10px;
		color:#000;
	}
	.ipdPortalMenuCls .nav a{
		color:#000;
	}
	.ipdPortalMenuCls .nav .sub{
		background-color:#f7f7f7;
		top:35px;
	}
	/* 门户菜单样式  IPD  结束*/
</style>
</head>
<body> 
	<%
		if(portalNo == null || "".equals(portalNo)){
			return;
		}
		String defualtUrl = "";
	%>
    <div class="banner" style = "height: 250px;width:100%">
        <div id="container">
            <div class="sections">
			<%
				String qryHeadPicSql = "select a.config_item,config_value from uf_portal_config a,uf_portal_def b where a.portal_id = b.id and  b.portal_no = '"+portalNo+"'";
				rs.execute(qryHeadPicSql);
				String picNamesStr = "";
				Map<String,String> configInfoMap = new HashMap<>();
				while(rs.next()){
					configInfoMap.put(Util.null2String(rs.getString("config_item")),Util.null2String(rs.getString("config_value")));
				}
				if(configInfoMap.containsKey("headPics")){
					picNamesStr = configInfoMap.get("headPics");
				}
				String[] picNameArr = picNamesStr.split(",");
				for(String picName:picNameArr){
			%>
                <div class="section" style="background-image:url('<%=picName%>')"></div>
			<%
				}
			%>
            </div>
        </div>
    </div>
    <div class="navBar ipdPortalMenuCls">
        <ul class="nav clearfix">
		<%
			String sql = "select c.id,c.menu_name,c.menu_url,a.fat_menu_id,c.display_type from uf_portal_menu_rela a,uf_portal_def b,uf_portal_menu_def c where a.portal_id = b.id and a.menu_id = c.id and b.portal_no = '"+portalNo+"' order by a.fat_menu_id desc, a.seq";
			rs.execute(sql);
			Map<String,Map<String,Object>> menuInfosMap = new HashMap<>();
			List<Map<String,Object>> rootMenuInfoList = new ArrayList<>();
			List<Map<String,Object>> notFoundFatMenuInfoList = new ArrayList<>();
			while(rs.next()){
				Map<String,Object> menuInfo = new HashMap<>();
				String  id = Util.null2String(rs.getString("id"));
				String fatMenuId = Util.null2String(rs.getString("fat_menu_id"));
				menuInfo.put("id",id);
				menuInfo.put("menuName",Util.null2String(rs.getString("MENU_NAME")));
				menuInfo.put("menuUrl",Util.null2String(rs.getString("MENU_URL")));
				menuInfo.put("menuType",Util.null2String(rs.getString("display_type")));
				menuInfo.put("fatMenuId","");
				if(fatMenuId == null || "".equals(fatMenuId)){
					rootMenuInfoList.add(menuInfo);
				}else{
					String[] fatMenuIds = fatMenuId.split("_");
					if(fatMenuIds.length > 1){
						fatMenuId = fatMenuIds[fatMenuIds.length-1];
					}
					menuInfo.put("fatMenuId",fatMenuId);
					if(menuInfosMap.containsKey(fatMenuId)){
						Map<String,Object> fatMenuInfoMap = menuInfosMap.get(fatMenuId);
						List<Map<String,Object>> subMenuInfosList = new ArrayList<>();
						if(fatMenuInfoMap.containsKey("children")){
							subMenuInfosList = (List<Map<String,Object>>)fatMenuInfoMap.get("children");
						}
						subMenuInfosList.add(menuInfo);
						fatMenuInfoMap.put("children",subMenuInfosList);
					}else{
						notFoundFatMenuInfoList.add(menuInfo);
					}
				}
				menuInfosMap.put(id,menuInfo);
			}
			for(Map<String,Object> menuInfoMap:notFoundFatMenuInfoList){
				String fatMenuId = menuInfoMap.get("fatMenuId").toString();
				if(!menuInfosMap.containsKey(fatMenuId)){
					continue;
				}
				Map<String,Object> fatMenuInfoMap = menuInfosMap.get(fatMenuId);
				List<Map<String,Object>> subMenuInfosList = new ArrayList<>();
				if(fatMenuInfoMap.containsKey("children")){
					subMenuInfosList = (List<Map<String,Object>>)fatMenuInfoMap.get("children");
				}
				subMenuInfosList.add(menuInfoMap);
				fatMenuInfoMap.put("children",subMenuInfosList);
			}
			for(Map<String,Object> menuInfo:rootMenuInfoList){
				String menuName = (String)menuInfo.get("menuName");
				String menuUrl = (String)menuInfo.get("menuUrl");
				String menuType = (String)menuInfo.get("menuType");
				if("".equals(defualtUrl) && !"".equals(menuUrl)){
					defualtUrl = menuUrl;
				}
		%>
		<li class="m">
                <h3><a style="cursor:pointer" onclick="change('<%=menuUrl%>','<%=menuType%>','<%=menuName%>')" ><%=menuName%></a></h3>
		<ul class="sub" style="display: none;">
		<%
				List<Map<String,Object>> subMenuInfosList = new ArrayList<>();
				if(menuInfo.containsKey("children")){
					subMenuInfosList = (List<Map<String,Object>>)menuInfo.get("children");
				}
				for(Map<String,Object> subMenuInfoMap:subMenuInfosList){
					String subMenuName = (String)subMenuInfoMap.get("menuName");
					String subMenuUrl = (String)subMenuInfoMap.get("menuUrl");
					String subMenuType = (String)subMenuInfoMap.get("menuType");
					if("".equals(defualtUrl) && !"".equals(subMenuUrl)){
						defualtUrl = subMenuUrl;
					}
					List<Map<String,Object>> subSubMenuInfosList = new ArrayList<>();
					if(subMenuInfoMap.containsKey("children")){
						subSubMenuInfosList = (List<Map<String,Object>>)subMenuInfoMap.get("children");
					}
					if(subSubMenuInfosList.isEmpty()){
		%>
				<li><a style="cursor:pointer" onclick="change('<%=subMenuUrl%>','<%=subMenuType%>','<%=subMenuName%>')"><%=subMenuName%></a></li>
		<%
					
						continue;
					}
		%>
				<li class="two"><a style="cursor:pointer" onclick="change('<%=subMenuUrl%>','<%=subMenuType%>','<%=subMenuName%>')"><%=subMenuName%></a></li>
					<div class="three" style="visibility: hidden;">
                         <ul class="sub2">
		<%
					for(Map<String,Object> subSubMenuInfoMap:subSubMenuInfosList){
						String subSubMenuName = (String)subSubMenuInfoMap.get("menuName");
						String subSubMenuUrl = (String)subSubMenuInfoMap.get("menuUrl");
						String subSubMenuType = (String)subSubMenuInfoMap.get("menuType");
						if("".equals(defualtUrl) && !"".equals(subSubMenuUrl)){
							defualtUrl = subSubMenuUrl;
						}
		%>
					<li><a style="cursor:pointer" onclick="change('<%=subSubMenuUrl%>','<%=subSubMenuType%>','<%=subSubMenuName%>')"><%=subSubMenuName%></a></li>
		<%
					}
		%>
						</ul>
                     </div>	
		<%
				}
		%>
				</ul>
            </li>
            <li class="s">|</li>
		<%
			}
		%>
          </div>
		 <%
			if(configInfoMap.containsKey("defaultPageUrl")){
				defualtUrl = configInfoMap.get("defaultPageUrl");
			}
		 %>
    <div style="margin:0px 10px">
        <iframe onload="changeFrameHeight()" class="context" src="<%=defualtUrl%>" frameborder="0" scrolling="auto" id="midFraim" style="width:100%;min-height:900px"></iframe>
    </div>
    </div>
    <script type="text/javascript" src="js/SuperSlide.2.1.js"></script>
    <script src="js/daimabiji.js" type="text/javascript"></script>
    <script type="text/javascript">
        function changeFrameHeight() {
            var ifm = document.getElementById("midFraim");
            console.log("clientHeight:" + $("#midFraim").contents().find("body").height());
            ifm.height = $("#midFraim").contents().find("body").height();
            console.log("clientHeight:" + document.documentElement.clientHeight);
            console.log("body:" + $("#midFraim").contents().find("body").height());

        }
        window.onresize = function() {
            changeFrameHeight();
        }
        function change(url,menuType,windowTitle) {
			if( menuType == "newPage"){
				if(!windowTitle || windowTitle == ''){
					windowTitle = '门户弹出窗口';
				}
				var fulls = "left=30px,screenX=30px,top=30px,screenY=30px,scrollbars=1";    //定义弹出窗口的参数
			  if (window.screen) {
				 var ah = screen.availHeight - 100;
				 var aw = screen.availWidth - 100;
				 fulls += ",height=" + ah;
				 fulls += ",innerHeight=" + ah;
				 fulls += ",width=" + aw;
				 fulls += ",innerWidth=" + aw;
				 fulls += ",resizable"
			 } else {
				 fulls += ",resizable"; // 对于不支持screen属性的浏览器，可以手工进行最大化。 manually
			 }
				window.open(url,windowTitle,fulls)
			}else{
				var ifm = document.getElementById("midFraim").src = url;
			}
        }
		$(".two").mouseenter(function() {
             $(".three").css({"visibility":"hidden"});
             $(this).next().css({"visibility":"visible"});
        });
    </script>
    <script src="js/pageSwitch.min.js"></script>
    <script>
        $("#container").PageSwitch({
            direction:'horizontal',
            easing:'ease-in',
            duration:20,
            autoPlay:true,
            loop:'false'
        });
    </script>
</body>

</html>
