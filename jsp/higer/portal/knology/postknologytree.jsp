<%@page import="weaver.general.TimeUtil"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page language="java" contentType="text/html; charset=GB2312" %> 

<%
response.setHeader("Pragma", "No-cache"); 
	response.setDateHeader("Expires", 0); 
	response.setHeader("Cache-Control", "no-cache"); 
%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<html>
<head>
<title>岗位知识树</title>
<script type="text/javascript" src="jquery_wev8.js"></script>
<style>
	body{
		margin:0;
		padding:0;
		font-size: 12px;
    }
    *{
    	font-family: '微软雅黑';
    }
    a {
		text-decoration: none;
	}
    .top {
		height: 74px;
		margin: 0 0 0 50px;
		border-bottom: 1px solid #CFCFCF;
	}

	.titleDiv{
		font-size: 18px;
		line-height: 108px;
		font-weight: bold;
		text-align: center;
		text-indent: -200px;
		height: 75px;
	}

    .bg-light.lt, .bg-light .lt {
	}
	.cgs-sbox {
		height: 120px;
		position: relative;
	}
	.cgs-sline {
		height: 1px;
		line-height: 1px;
		font-size: 0;
		border: 0 none;
		position: absolute;
		top: 61px;
		left: 4%;
		right: 4%;
		z-index: -1;
		border-bottom: 2px dashed #cacaca;
	}
	.cgs-slist {
		width: 86%;
		padding: 0;
		margin-left: auto;
		margin-right: auto;
		position: absolute;
		left: 0px;
		z-index: 1;
	}
	.cgs-slist li {
		list-style: none;
		float: left;
		width: 14.285%;
		text-align: center;
		font-size: 14px;
		font-weight: bold;
		height: 100px;
	}
	.stepI {
		display: block;
		width: 10px;
		height: 10px;
		background: url('./d.png') no-repeat;
		margin-left: auto;
		margin-right: auto;
		position: absolute;
		top: 58px;
		left: 38px;
		z-index: -1;
	}
	.stepSpanSelect {
		color: #fb6b5b;
	}
	.stepDiv{
		width:86px;
		height: 100px;
		line-height: 20px;
		margin: 0 auto;
		cursor: pointer;
		position: relative;
		padding-top: 5px;
	}
	.stepSelect,.stepSelectHover {
		background: url('./bg.png') 0 0 no-repeat;
		opacity: 0.8;
	}
    .stepDiv:hover{

        background: url('./bg.png') 0 0 no-repeat;
		opacity: 0.8;
    
    }
	.remarkComtainer{
		width: 998px;
		height: auto;
		padding: 30px 0;
		margin: 0 auto;
	}
    .leftMove,.rightMove{
    	width:30px;
    	float: left;
    	height:120px;
    }

    .moveImgShow{
    	opacity: 1;
    }
    .moveFlag {
		display: none;
	}
    .tep-play-list{
		width: 100%;
		margin-left: auto;
		margin-right: auto;
		border-top: 0;
		position: relative;
    }
    .step-item-container{
    }
	.showdivcss{
		font-size:14px;
		font-family: 微软雅黑;
	}
</style>
</head>
<body>
	
<%
			String sql = "select t.gwbm,t2.jobtitlename,t1.id,t1.gwzslb,t1.gwzsfj,t1.gwzsfjms from ecology.uf_post_knowledge t left join ecology.uf_post_knowledge_DT1 t1 on t.id=t1.mainid left join ecology.hrmjobtitles  t2 on t.gwbm=t2.id where t.gwbm="+request.getParameter("gwbm")+" order by id";
			String strCss="stepDiv stepSelect";
			String strFlowstring="";
			String strShowstring="";
			String strShowCss="";
			String strJobName="";
			rs.execute(sql);
			
			while(rs.next()){
				strJobName=rs.getString("jobtitlename");
				//导航树
				strFlowstring=strFlowstring+"<li title='"+ rs.getString("gwzslb") + "' style='width: 100px;'>";
				strFlowstring=strFlowstring+"<div class='"+strCss+"'adurl='"+rs.getString("id")+"'>";
				strFlowstring=strFlowstring+"<div style='margin: 0 2px;'>";
				strFlowstring=strFlowstring+"<span>"+rs.getString("gwzslb")+"</span>";
				strFlowstring=strFlowstring+"</div><div><i class='stepI'></i></div></div></li>";
				if(strCss=="stepDiv stepSelect") { strCss="stepDiv"; }

				//展现层
				strShowstring=strShowstring+"<div id='"+rs.getString("id")+"' "+ strShowCss +"  class='showdivcss' ><b>"+rs.getString("gwzsfjms")+"</b><br><br>";

				String [] sp=rs.getString("gwzsfj").split(",");
				strShowstring=strShowstring+"<table width='1060px'  style='font-size:14px;font-family: 微软雅黑;' border='0' cellspacing='0' cellpadding='0'><colgroup><col width='60%'><col width='20%'><col width='20%'></colgroup><tbody>";
				for(int i=0;i<sp.length;i++)
				{
					rs1.execute("select a.id,a.docsubject,a.doclastmoddate,c.lastname from ecology.DocDetail a  left join ecology.hrmresource c on a.doclastmoduserid=c.id where a.id="+sp[i]);
					while(rs1.next()){
						
						strShowstring=strShowstring+"<tr><td><a target='about:blank' href='../../../spa/document/index.jsp?id="+rs1.getString("id")+"&router=1'>"+rs1.getString("docsubject") +"</a></td>";
						strShowstring=strShowstring+"<td>"+rs1.getString("doclastmoddate")+"</td>";
						strShowstring=strShowstring+"<td>"+rs1.getString("lastname")+"</td></tr>";
					}
				}
				strShowstring=strShowstring+"</tbody></table>";
				strShowstring=strShowstring+"</div>";
				if(strShowCss=="") { strShowCss="style='display:none'"; }
			}
	%>				
	
<div id="mainDiv" style="margin-right: 70px;">
<div id="mainTitleDiv">
	
		<div id="remarkComtainer" class="remarkComtainer" style="width: 998px;">
	       
	      <p style="text-align: center;">
	<span style="font-size:48px;"><span style="font-family:黑体;"><strong style="font-family: 黑体;">海格<%=strJobName%></strong></span></span></p>
<p style="text-align: center;">
	<span style="font-size:36px;"><span style="font-family:黑体;"><strong>岗位知识串</strong></span></span></p>

	   	</div>
		
	<div id="moveTitleDiv" style="margin: 0px auto; width: 1060px;">
		<div class="leftMove">
			<div class="leftMoveImg moveFlag"></div>
		</div>
		<div id="ulDiv" style="overflow: hidden; float: left; width: 1000px;">
			<div class="cgs-sbox bg-light lt position-relative">
				<ul class="cgs-slist cf" style="width: 1000px;">
					<div class="cgs-sline" style="left: 50px; right: 50px;"></div>
					<%=strFlowstring%>
				</ul>
				
			</div>
		</div>
		<div class="rightMove">
			<div class="rightMoveImg moveFlag"></div>
		</div>
		<div style="clear:both;"></div>
	</div>
</div>
<br>
<br>
<div style="position: relative;">
	<div id="step-play-list" class="tep-play-list" style="width: 998px;">
	    <div class="step-item-container">
		    <%=strShowstring%>
	    </div>
	   		 
	</div>
	<div style="height:20px;width: 100%"></div>
</div>
</div>	
<script type="text/javascript">
var num = 10;
jQuery(function(){
	jQuery(window).resize(function(){
		resetWidth();
	});
	resetWidth();
	
	jQuery(".step-item-container:first").show();
	
	
	//标题主div悬浮事件，显示隐藏左右移动按钮
	jQuery(".leftMoveImg").addClass("moveFlag");
	jQuery("#mainTitleDiv").hover(function(){
		if(!jQuery(".leftMoveImg").hasClass("moveFlag")){
			jQuery(".leftMoveImg").addClass("moveImgShow");
		}
		if(!jQuery(".rightMoveImg").hasClass("moveFlag")){
			jQuery(".rightMoveImg").addClass("moveImgShow");
		}
	},function(){
		jQuery(".leftMoveImg,.rightMoveImg").removeClass("moveImgShow");
	});
	
	//选择标题
	jQuery(".stepDiv").click(function(){
		var thisdiv="#"+jQuery(".stepSelect").attr("adurl");
		jQuery(".stepSelect").removeClass("stepSelect");
		jQuery(this).addClass("stepSelect");
		var targetdiv="#"+jQuery(".stepSelect").attr("adurl");
		jQuery(thisdiv).attr("style","display:none");
		jQuery(targetdiv).attr("style","display:");
	}).hover(function(){
		jQuery(this).addClass("stepSelectHover");
	},function(){
		jQuery(this).removeClass("stepSelectHover");
	});
});

var liWidth = 100;
var ulWidth = 0;
var boxWidth = 0;
//重设ul的宽度
function resetWidth(){
	//页面宽度减去两边的移动按钮为中间部分宽度
	boxWidth = jQuery(window).width()-(30*2)-120;
	//宽度超过1000时取1000，避免过宽难看
	boxWidth = boxWidth>1000?1000:boxWidth;
	//ul宽度默认为li的个数*100
	ulWidth = num*100;
	if(ulWidth > boxWidth){//ul宽度比中间部分大
		jQuery(".rightMoveImg").removeClass("moveFlag");
		liWidth = 100;
	}else{//ul宽度比中间部分小，li的宽为中间部分宽/li个数
		jQuery(".rightMoveImg").addClass("moveFlag");
		liWidth = boxWidth/num;
		ulWidth = boxWidth;
	}
	//中间存放ul的div宽度为页面宽度减去两边的按钮
	jQuery("#ulDiv").width(boxWidth+"px");
	jQuery(".cgs-slist").width(ulWidth+"px");
	jQuery(".cgs-slist li").width(liWidth+"px");
	
	//设置步骤详情页面的宽度和高度
	var stepListH = jQuery(window).height()-150-30;
	jQuery("#moveTitleDiv").width(boxWidth+60+"px")
	jQuery("#step-play-list").width(boxWidth-2+"px");
	jQuery("#remarkComtainer").width(boxWidth-2+"px");
// 	jQuery("#step-play-list").width(boxWidth-2+"px").height(stepListH-20+"px");
// 	jQuery(".step-item-container").height(stepListH-36+"px");
	//中间线设置距离左右各li宽度的一半
	var lineL = liWidth/2;
	jQuery(".cgs-sline").css({"left":lineL+"px","right":lineL+"px"});
}


function iFrameHeight(obj,i) { 
	   var iframe = obj; 
		try{ 
     var bHeight =   iframe.contentWindow.document.body.scrollHeight; 
     var dHeight = iframe.contentWindow.document.documentElement.scrollHeight; 
     var height = Math.max(bHeight, dHeight); 
     iframe.height =  height; 
     if(i != 0){
    	 jQuery(obj).parent().hide();
     }
     jQuery(".leftFrameDiv").height(jQuery("#mainDiv").height());
		 }catch (ex){} 
	}
</script>    


</body></html>