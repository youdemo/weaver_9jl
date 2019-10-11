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
<html>
<head>
	<title></title>
</head>
<style type="text/css">
	*{
		padding:0px;
		margin:0px;
	}
	.masonry { 
		-moz-column-count:4; 
        -webkit-column-count:4; 
        column-count:4;
        -moz-column-gap: 2em;
        -webkit-column-gap: 2em;
        column-gap: 2em;
        width: 90%;
		margin:1em auto;
		min-width:1300px;
    }
    .item { 
        padding: 2em;
       	margin-bottom: 2em;
        -moz-page-break-inside: avoid;
       	-webkit-column-break-inside: avoid;
       	break-inside: avoid;
       	background-color: rgb(245,245,245);

    }
	
	.content-lar{
		color: #7a7a7a;
		margin-top: 10px;
		font-size: 13.5px;	
	}
	.workflow_title{
		text-align: left;
		border-top: 3px solid red;
		margin-bottom: 10px;
		color: #000;
		font-size: 18px;
		width: 100%;
		height: 40px;
		margin:0px auto;
		margin-top: -20px;
		margin-bottom: 45px;
	}
	.workflow_title div{
		width: 33px;
		float: left;
		margin-left: 30%;
		margin-top: 20px;
	}
	.workflow_img{
		height: 35px;
		width: 35px;
	}
	.workflow_title img{
		width: 100%;
		height: 100%;
	}
	#workflow_title_glt{
		width: 50%;
		margin-left: 10px;
		line-height: 35px;
		color :#292929;
		font-size: 16px;
	}
	.itemcolor:hover{
		color:#87CEFA;
	}
</style>
<%
	String[] color={"#B37BFA","#8DCE36","#FF9537","#FFC62E","#00FFFF","#DAA520"};
	String[] imgsrc={"work.png","qd.png","rs.png","xs.png","xz.png","zc.png"};

%>

<body>
	<div class="masonry"> 
			<%
						int userid = user.getUID();
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
						int count=0;
		
		%>
		<%		
						sql = "select id,typename from workflow_type where id in("+workflowtypes+") order by dsporder asc";
						rs.execute(sql);
						while(rs.next()){
							String typename = Util.null2String(rs.getString("typename"));
							List<Map> flowlist = typeflowMap.get(typename);
							int choosetype = count%6;
		%>
    	<div class="item"> 
        	<div class="item_content content-lar workflow_title" style="border-top: 3px solid <%=color[choosetype]%>">
        		<div class = "workflow_img"><img src = "/higer/portal/workflow/img/<%=imgsrc[choosetype]%>" /></div>
        		<div id = "workflow_title_glt"><%=typename%></div>
        	</div>
        	<div style="clear: both;"></div>
			<%
										
							for(Map<String,String> mapflow:flowlist){
			%>	
            <a href='<%=mapflow.get("url")%>' target="_blank"><div class="item_content content-lar itemcolor"><%=mapflow.get("workflowname")%></div></a>
        
		<%
							}
		%>
			</div>
		<%	
		count++;
						}
		
		%>
        
    </div>        
</body>
</html>
