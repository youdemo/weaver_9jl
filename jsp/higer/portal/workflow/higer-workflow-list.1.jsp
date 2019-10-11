<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="java.util.*,weaver.hrm.appdetach.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<script type="text/javascript" src="/appres/hrm/js/mfcommon_wev8.js"></script>
		<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
		<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
		<SCRIPT language="JavaScript" src="/js/weaver_wev8.js"></SCRIPT>
		<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
		<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
		 <SCRIPT language="javascript" src="/proj/js/common_wev8.js"></SCRIPT>
		<style>
		body{
			overflow:auto;
			overflow-x:hidden;
			}
		.checkbox {
			display: none
		}
		</style>
		   <style>
           .listbox2 ul {
             margin: 0 0 0 0;
             padding: 0px;
             list-style: none;
      /**       border-top: 1px solid #ccc;**/
            }

            .listbox2 {
             width:99%;
          /**   border: 1px solid #ccc; **/
			 margin-bottom: 32px;
			 margin-right:0px;
             }

            .listbox2 .titleitem{
			height: 26px;
            line-height: 26px;
         /**   background: #F7F7F7;**/
            font-weight: bold;
		/**	padding-left: 10px;**/
			border-bottom: 2px solid #e4e4e4;
			}
         
       /**    .listbox2 .opimg{
			vertical-align: middle;
			margin-right:10px;
			}**/

		    TABLE.ViewForm TD {
              padding: 0 0 0 5;
			  BACKGROUND-COLOR: white;
            }

		    .listbox2 ul li a{
		     color: black;
			 margin-left:8px;
			 margin-right:12px;
		    }

          .listbox2 ul li {
             height: 30px;
             line-height: 30px;
			 border-bottom:1px dashed #f0f0f0;
			 padding-left: 0px;
		/**	 background-image:url(http://localhost:9090/images/ecology8/top_icons/1-1_wev8.png);
			 background-position:0px 50%;
			 background-repeat:no-repeat no-repeat;**/
            }
          

		   TABLE.ViewForm A:link {
			  COLOR: grey;
	/*		  TEXT-DECORATION: none;*/
			  vertical-align: middle;
			  line-height: 24px;
           }
		  TABLE.ViewForm A:visited {
				COLOR: grey; 
				TEXT-DECORATION: none
			}

           .ViewForm .commonitem{
			 /**  border: 1px solid #ccc;**/
			   margin-bottom: 32px;
			   width: 99.7%;
		 
		   }

			TABLE.ViewForm TD {
				padding: 0px;
				BACKGROUND-COLOR: white;
			}
			
			.ViewForm .commonitem .commonitemtitle{
				height: 26px;
				line-height: 26px;
			/**	background: #F7F7F7;**/
				font-weight: bold;
				border-bottom: 2px solid #e4e4e4;
			/**	padding-left: 10px;**/
			}
			
			.ViewForm .increamentinfo{
			  color:grey;
			  margin-left: 10px;
			}
			#warn{
				width: 260px;
				height: 65px;
				line-height:65px;
				background-color: gray;
				position: absolute;
				display:none;
				text-align:center;
				background: url("/images/ecology8/addWorkGround_wev8.png");
			}
			.titlecontent{
				float:left;
				color:#232323;
			/**	margin-top: 0.5px;**/
			}
			.commian{
				float:left;
				color:#232323;
			/**	margin-top: 0.5px;**/
				border-bottom:2px solid #9e17b6;
			}

			TABLE.ViewForm TR {
           height: 30px  !important;
            }	
				 
		    .middlehelper {
					display: inline-block;
					height: 100%;
					vertical-align: middle;
				}

			.autocomplete-suggestions { border: none;background: #F5F5F5;}
			.autocomplete-suggestion { padding: 2px 5px; color:#5b5b5b;white-space: nowrap; overflow: hidden;height:30px;line-height:30px;cursor: pointer;text-overflow:ellipsis;border-bottom:1px solid #e2e3e4;}
			.autocomplete-selected { border-bottom:1px solid #99cdf8;color:#292828; }

			.autocomplete-suggestions strong { font-weight: normal; color: #292828; }
 
            /*代理菜单样式*/
            .agentitem{

				padding: 2px;
				
			}
            
			.chosen{
			   background:#3399ff;
			   color:white;
			   cursor:pointer;
			}

			.agentitem a:hover{
			color:#ffffff !important;
			}

           .menuitem{

		    margin-bottom:5px;
		   
		   
		   }
		
         
			/*动态计算浮动签字栏距离top的距离*/
		  .flowmenuitem {
			  /* IE5.5+/Win - this is more specific than the IE 5.0 version */
			  right: auto; bottom: auto;
			  top: expression( ( -0.1 - this.offsetHeight + ( document.documentElement.clientHeight ? document.documentElement.clientHeight : document.body.clientHeight ) + ( ignoreMe = document.documentElement.scrollTop ? document.documentElement.scrollTop : document.body.scrollTop ) ) + 'px' );
			  BACKGROUND-COLOR: #F7F7F7;

			}

			 .wrapper{
			  position: absolute;
				width: 100%;
				height: 42px;
				top: 0;
				left: 0;
				background: #999999;
				z-index: -1;
			 
			 }

		</style>
		<link href="/css/ecology8/request/requestTypeShow_wev8.css" type="text/css" rel="STYLESHEET">	    
	</head>
	<%
	int language =user.getLanguage();
	Calendar now = Calendar.getInstance();
	
	int userid = user.getUID();
	 String imagefilename = "/images/hdReport_wev8.gif";
	String titlename =SystemEnv.getHtmlLabelName(20536,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
	boolean flagaccount = weaver.general.GCONST.getMOREACCOUNTLANDING();
	String out_pageId="jllcportal";

	%>
	<BODY>
		<div id="tabDiv">
			<span class="toggleLeft" id="toggleLeft" title="<%=SystemEnv.getHtmlLabelName(32814,user.getLanguage()) %>"><%=SystemEnv.getHtmlLabelName(20536,user.getLanguage()) %></span>
		</div>
		<div id="dialog">
			<div id='colShow'></div>
		</div>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
		RCMenu += "{刷新,javascript:refersh(),_self} " ;
		//RCMenu += "{导出,javascript:_xtable_getAllExcel(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<FORM id=report name=report action="/higer/portal/workflow/higer-workflow-list.jsp" method=post>
			<input type="hidden" name="requestid" value="">
			<table id="topTitle" cellpadding="0" cellspacing="0">
				<tr>
					<td></td>
					<td class="rightSearchSpan" style="text-align:right;">
						<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</tr>
			</table>
			<div class="advancedSearchDiv" id="advancedSearchDiv" ></div>
	<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(18375,user.getLanguage())%>' attributes="{'groupDisplay':'none'}">
		<wea:item attributes="{'isTableList':'true'}">
		<%
		String[] color={"#166ca5","#953735","#01b0f1","#767719","#f99d52","#cf39a4"};
		%>
			<table class="ViewForm" style="margin-left:10px!important;margin-right:10px!important;">
				<tbody>
				
					<%
					
						String tmp_jobtitle = "";
						String tmp_seclevel = "";
						String tmp_departmentid = "";
						String tmp_subcompanyid1 = "";
						String sql = "select * from hrmresource where id = " + userid;
						rs.execute(sql);
						if(rs.next()){
							tmp_jobtitle = Util.null2String(rs.getString("jobtitle")); 
							tmp_seclevel = Util.null2String(rs.getString("seclevel")); 
							tmp_departmentid = Util.null2String(rs.getString("departmentid")); 
							tmp_subcompanyid1 = Util.null2String(rs.getString("subcompanyid1")); 
						}
						sql = "select resourceid,roleid from hrmrolemembers where resourceid = " + userid;
						rs.execute(sql);
						String tmp_roles = "0";
						while(rs.next()){
							String tmp_xx = Util.null2String(rs.getString("roleid")); 
							tmp_roles = tmp_roles + "," + tmp_xx;
						}  
						Map<String,List<Map>> typeflowMap = new HashMap<String,List<Map>>();
						Map<String,String> typemap = new HashMap<String,String>();
						sql =  "select id,workflowname,workflowtype,(select typename from workflow_type where id=t.workflowtype) as typename,'0' as systype from workflow_base t where id in("
								+" select workflowid from shareinnerwfcreate where workflowid  in(select id from workflow_base where isvalid = 1) and ( "
								+" (type = 4 and min_seclevel <= " + tmp_seclevel + " and max_seclevel >= " + tmp_seclevel + " ) "
								+" or (type = 3 and content = " + userid + ") "
								+" or (type = 1 and isbelong = 1 and content in(" + tmp_departmentid + ") and bhxj in(1)) or (type = 1 and isbelong = 2 and content not in(" + tmp_departmentid + ") and bhxj in(1)) "
								+" or (type = 1 and isbelong = 1 and content = " + tmp_departmentid + " and bhxj in(0)) or (type = 1 and isbelong = 2 and content != " + tmp_departmentid + " and bhxj in(0))   "
								+" or (type = 30 and isbelong = 1 and content in(" + tmp_subcompanyid1 + ") and bhxj in(1)) or (type = 30 and isbelong = 2 and content not in(" + tmp_subcompanyid1 + ") and bhxj in(1)) "
								+" or (type = 30 and isbelong = 1 and content = " + tmp_subcompanyid1 + " and bhxj in(1)) or (type = 30 and isbelong = 2 and content != " + tmp_subcompanyid1 + " and bhxj in(1)) "
								+" or (type = 58 and min_seclevel = 2 and isbelong = 1 and content = " + tmp_jobtitle + ") or (type = 58 and min_seclevel = 2 and isbelong = 2 and content != " + tmp_jobtitle+ " ) "
								+" or (type = 58 and min_seclevel = 0 and isbelong = 1 and content = " + tmp_jobtitle + " and max_seclevel = " + tmp_departmentid + ") or (type = 58 and min_seclevel = 0 and isbelong = 2 and content != " + tmp_jobtitle+ " and max_seclevel != " + tmp_departmentid + ") "
								+" or (type = 58 and min_seclevel = 1 and isbelong = 1 and content = " + tmp_jobtitle+ " and max_seclevel = " + tmp_subcompanyid1 + ") or (type = 58 and min_seclevel = 1 and isbelong = 2 and content != " + tmp_jobtitle+ " and max_seclevel != " + tmp_subcompanyid1 + ") "
								+" or (type = 2 and isbelong = 1 and trunc(content/10) in(" + tmp_roles + ") ) or (type = 2 and isbelong = 2 and trunc(content/10) not in(" + tmp_roles + ") ) ) ) order by dsporder asc";
						rs.execute(sql);
						
						while(rs.next()){
							String workflowid = Util.null2String((rs.getString("id")));
							String workflowname = Util.null2String(rs.getString("workflowname"));
							String workflowtype = Util.null2String(rs.getString("workflowtype"));
							String typename = Util.null2String(rs.getString("typename"));
							String systype = Util.null2String(rs.getString("systype"));
							typemap.put(typename, workflowtype);
							Map<String,String> flowmap = new HashMap<String,String>();
							//flowmap.put("workflowid", workflowid);
							flowmap.put("workflowname", workflowname);
							flowmap.put("url", "/spa/workflow/index_form.jsp#/main/workflow/req?iscreate=1&workflowid="+workflowid+"&isagent=0&beagenter=0&f_weaver_belongto_userid=&f_weaver_belongto_usertype=0");
							if(typeflowMap.get(typename) == null) {
								typeflowMap.put(typename, new ArrayList<Map>());
							}
							typeflowMap.get(typename).add(flowmap);
							
						}
						sql="select wfname,wfurl,wftype,(select typename from workflow_type where id=a.wftype) as typename,'1' as systype from uf_other_WF_START a where is_active = 0 and (ftype = 0 or (ftype = 1 and  FUN_INSTR_CONTAINS(roles,'"+tmp_roles+",')>0 ) ) order by seqno asc";
						rs.execute(sql);
						while(rs.next()){
							String workflowname = Util.null2String(rs.getString("wfname"));
							String workflowtype = Util.null2String(rs.getString("wftype"));
							String typename = Util.null2String(rs.getString("typename"));
							String systype = Util.null2String(rs.getString("systype"));
							String wfurl = Util.null2String(rs.getString("wfurl"));
							typemap.put(typename, workflowtype);
							Map<String,String> flowmap = new HashMap<String,String>();
							//flowmap.put("workflowid", "0");
							flowmap.put("workflowname", workflowname);
							flowmap.put("url", wfurl);
							if(typeflowMap.get(typename) == null) {
								typeflowMap.put(typename, new ArrayList<Map>());
							}
							typeflowMap.get(typename).add(flowmap);
							
						}
						String workflowtypes = "-1";
						Iterator typei = typemap.keySet().iterator();
						while(typei.hasNext()) {
							String key = (String)typei.next();
							String value = typemap.get(key);
							workflowtypes = workflowtypes+","+value;							
						}
						int count=1;
			
				%>
					<tr class=field>
				<%		
						sql = "select id,typename from workflow_type where id in("+workflowtypes+") order by dsporder asc";
						rs.execute(sql);
						while(rs.next()){
							String typename = Util.null2String(rs.getString("typename"));
							List<Map> flowlist = typeflowMap.get(typename);
				%>
						
					<td width="32%" align=left valign=top num=1>
			
						<div class="listbox2" >
									<div class='titleitem'>
										<div class="titlecontent" style="border-bottom:2px solid <%=color[0] %>;"><label><%=typename%></label></div>								
									</div>
									<div class="mainItem">
									<%
										
										for(Map<String,String> mapflow:flowlist){
									%>	
									<div class="centerItem" >
										<div class="fontItem" >
										<img name="esymbol" src="/images/ecology8/request/workflowTitle_wev8.png" style="vertical-align: middle;">
											<a href='<%=mapflow.get("url")%>' target="_blank"><%=mapflow.get("workflowname")%></a>
										</div>
										
									</div>
									<%	
										}
									%>
									<div style="height:20px!important;"></div>															
									</div>
										
							</div>	
					</td>
					<%	
						if(count%3==0){
					%>
					</tr>
					<tr class=field>
					<%		
						}
						count++;
					}				
					%>
					</tr>
					
				
				</tbody>
			</table>
		</wea:item>
	</wea:group>
	</wea:layout>	
			
		 
		</FORM>
		
	<script type="text/javascript">
	
	  
   </script>
		<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
	<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
	<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
	
</BODY>
</HTML>