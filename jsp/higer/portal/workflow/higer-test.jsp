<%@page import="weaver.general.TimeUtil"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
  int userid = user.getUID();    
  String tmp_jobtitle = "";
  String tmp_seclevel = "";
  String tmp_departmentid = "";
  String tmp_subcompanyid1 = "";
  String sql = "select * from hrmresource where id = " + userid;
  rs.executeSql(sql);
  if(rs.next()){
      tmp_jobtitle = Util.null2String(rs.getString("jobtitle")); 
      tmp_seclevel = Util.null2String(rs.getString("seclevel")); 
      tmp_departmentid = Util.null2String(rs.getString("departmentid")); 
      tmp_subcompanyid1 = Util.null2String(rs.getString("subcompanyid1")); 
  }
  sql = "select resourceid,roleid from hrmrolemembers where resourceid = " + userid;
  rs.executeSql(sql);
  String tmp_roles = "0";
  while(rs.next()){
      String tmp_xx = Util.null2String(rs.getString("roleid")); 
      tmp_roles = tmp_roles + "," + tmp_xx;
  }  

  sql =  "select typename from workflow_type where id in (select  distinct to_char(workflowtype) as typeid from workflow_base where id in("
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
         +" or (type = 2 and isbelong = 1 and trunc(content/10) in(" + tmp_roles + ") ) or (type = 2 and isbelong = 2 and trunc(content/10) not in(" + tmp_roles + ") ) ) )"
         +" union all "
         +" select distinct wftype  from uf_other_WF_START "
         +" where is_active = 0 and (ftype = 0 or (ftype = 1 and roles in(" + tmp_roles + ") ) )) order by dsporder asc";
out.print(sql);

%>