<%@page import="java.io.*,java.util.*"%>
<%@page import="org.json.*"%>
<%@page import="weaver.general.*"%>
<%@page import="weaver.formmode.data.ModeDataIdUpdate,weaver.formmode.setup.CodeBuild,weaver.formmode.setup.ModeRightInfo"%>
<%@page import="weaver.conn.*,weaver.hrm.User,weaver.hrm.company.DepartmentComInfo,weaver.hrm.company.SubCompanyComInfo"%>
<%@page import="org.apache.commons.io.FileUtils"%>
<%@page import="weaver.hrm.resource.ResourceComInfo,weaver.workflow.request.RequestComInfo,weaver.docs.docs.DocComInfo"%>
<%@page import="weaver.docs.docs.DocImageManager"%>
<%!
//根据文件路径和json名获取json数组
public JSONArray getJSONArray(String folder,String jsonname){
	File filejson;
	try {
		filejson = new File(GCONST.getRootPath()+File.separator+"WEB-INF"+File.separator+"plugin"+File.separator+folder+File.separator+jsonname+".json");
		
        //读取文件
        String input = FileUtils.readFileToString(filejson, "UTF-8");
        //将读取的数据转换为JSONObject
        JSONArray arrs = new JSONArray(input);
        if (arrs != null) {
        	return arrs;
        }
	} catch (IOException e) {
		e.printStackTrace();
	} catch (JSONException e) {
		e.printStackTrace();
	}
	return new JSONArray();
}
//根据文件路径和json名获取json对象
public JSONObject getJSONObject(String folder,String jsonname){
	File filejson;
	try {
		filejson = new File(GCONST.getRootPath()+File.separator+"WEB-INF"+File.separator+"plugin"+File.separator+folder+File.separator+jsonname+".json");
		
        //读取文件
        String input = FileUtils.readFileToString(filejson, "UTF-8");
        //将读取的数据转换为JSONObject
        JSONObject obj = new JSONObject(input);
        if (obj != null) {
        	return obj;
        }
	} catch (IOException e) {
		e.printStackTrace();
	} catch (JSONException e) {
		e.printStackTrace();
	}
	return new JSONObject();
}

//自定义路径
public JSONObject getHigerJSONObject(String jsonname){
	File filejson;
	try {
		filejson = new File(GCONST.getRootPath()+File.separator+"higer"+File.separator+"portal"
					+File.separator+"file"+File.separator+"element"+File.separator+"iconblock"+File.separator+jsonname+".json");
		
        //读取文件
        String input = FileUtils.readFileToString(filejson, "UTF-8");
        //将读取的数据转换为JSONObject
        JSONObject obj = new JSONObject(input);
        if (obj != null) {
        	return obj;
        }
	} catch (IOException e) {
		e.printStackTrace();
	} catch (JSONException e) {
		e.printStackTrace();
	}
	return new JSONObject();
}
//根据文件路径json名称，key值获取对应json对象
public JSONObject getJsonValue(String folder,String jsonname,String key){
	File filejson;
	try {
		filejson = new File(GCONST.getRootPath()+File.separator+"WEB-INF"+File.separator+"plugin"+File.separator+folder+File.separator+jsonname+".json");
		
        //读取文件
        String input = FileUtils.readFileToString(filejson, "UTF-8");
        //将读取的数据转换为JSONObject
        JSONArray arrs = new JSONArray(input);
        if (arrs != null) {
        	if(arrs.length()>0){
    		  for(int i=0;i<arrs.length();i++){
    		    JSONObject json = arrs.getJSONObject(i);
    		    if(json.has("key") && json.getString("key").equals(key)){
    		    	return json;
    		    }
    		  }
    		}
        }
	} catch (IOException e) {
		e.printStackTrace();
	} catch (JSONException e) {
		e.printStackTrace();
	}
	return new JSONObject();
}

/**
 *  * 建模插入数据调用方法，传入表名，人员id和要更新内容的sql以及参数
 * @param tablename 需要插入数据的表名
 * @param userid 人员id
 * @param updateSql 需要更新数据的sql
 * @param params updateSql需要的参数，最后一参数id不需要传
 * @return
 */
public boolean formInsert(String tablename,int userid,String updateSql){
	RecordSet rs = new RecordSet();
	int modeId = 0;
	int formId = 0;
	String sql = "SELECT  t2.id modeid, t2.formid "+
		"FROM    workflow_bill t "+
		"JOIN    modeinfo t2 ON t.id = t2.formid "+
		"WHERE   tablename = '"+tablename+"'";
	rs.executeSql(sql);
	boolean result = false;
	if(rs.next()){
		modeId = rs.getInt("modeid");
		formId = rs.getInt("formid");
		
		ModeDataIdUpdate modeDataIdUpdate = new ModeDataIdUpdate(); 
		int billid = modeDataIdUpdate.getModeDataNewId(tablename,modeId,userid,0,TimeUtil.getCurrentDateString(),TimeUtil.getOnlyCurrentTimeString());
		if(rs.executeSql(updateSql+billid)){
			CodeBuild cbuild = new CodeBuild(modeId);
			cbuild.getModeCodeStr(formId,billid);//生成编号
			new ModeRightInfo().editModeDataShare(userid,modeId,billid);//新建的时候添加共享	
			result = true;
		}else{//更新失败，删除当前数据
			sql = "delete from " + tablename + " where id = " + billid;
			rs.executeSql(sql);
		}
	}
	return result;
}

//根据类型获取不同内容的子查询sql
public String getcolsql(String type){
	String col = "";
	if(type.equals("1")){//人员名称
		col = ",t2.lastname";
	}else if(type.equals("2")){//岗位
		col = ",( SELECT    jobtitlename "+
			"     FROM      hrmjobtitles "+
			"     WHERE     id = t2.jobtitle "+
			"   ) jobtitlename";
	}else if(type.equals("3")){//部门
		col = ",( SELECT    departmentname "+
			"     FROM      HrmDepartment "+
			"     WHERE     id = t2.departmentid "+
			"   ) deptname";
	}else if(type.equals("4")){//分部
		col = ",( SELECT    subcompanyname "+
			"     FROM      HrmSubCompany "+
			"     WHERE     id = t2.subcompanyid1 "+
			"   ) subname";
	}
	return col;
}

//格式化sql
public String formatsql(String sql,User user,HttpServletRequest request){
	try{
		Enumeration pNames = request.getParameterNames();//替换request url 中的参数
		while(pNames.hasMoreElements()){
		    String name=(String)pNames.nextElement();
		    String value= request.getParameter(name);
		    if(value.length() > 0){
		    	sql = sql.replaceAll("\\$"+name+"\\$", value);
		    }
		}
		
		//替换系统参数
		sql = sql.replaceAll("\\$Userid\\$", user.getUID()+"");
		
		String deptid = user.getUserDepartment()+"";
		sql = sql.replaceAll("\\$Departmentld\\$", deptid);
		if(sql.indexOf("$AllDepartmentld$") != -1){
			sql = sql.replaceAll("\\$AllDepartmentld\\$", DepartmentComInfo.getAllChildDepartId(deptid,deptid));
		}
		
		String subcompanyid = user.getUserSubCompany1()+"";
		sql = sql.replaceAll("\\$Subcompanyld\\$", subcompanyid);
		if(sql.indexOf("$AllSubcompanyld$") != -1){
			sql = sql.replaceAll("\\$AllSubcompanyld\\$", SubCompanyComInfo.getAllChildSubcompanyId(subcompanyid,subcompanyid));
		}

		sql = sql.replaceAll("\\$date\\$", TimeUtil.getCurrentDateString()); 
	}catch(Exception e){
		e.printStackTrace();
	}
	return sql;
}

//格式化sql (兼容老版本 没有request参数)
public String formatsql(String sql,User user){
	try{
		//替换系统参数
		sql = sql.replaceAll("\\$Userid\\$", user.getUID()+"");
		
		String deptid = user.getUserDepartment()+"";
		sql = sql.replaceAll("\\$Departmentld\\$", deptid);
		if(sql.indexOf("$AllDepartmentld$") != -1){
			sql = sql.replaceAll("\\$AllDepartmentld\\$", DepartmentComInfo.getAllChildDepartId(deptid,deptid));
		}
		
		String subcompanyid = user.getUserSubCompany1()+"";
		sql = sql.replaceAll("\\$Subcompanyld\\$", subcompanyid);
		if(sql.indexOf("$AllSubcompanyld$") != -1){
			sql = sql.replaceAll("\\$AllSubcompanyld\\$", SubCompanyComInfo.getAllChildSubcompanyId(subcompanyid,subcompanyid));
		}

		sql = sql.replaceAll("\\$date\\$", TimeUtil.getCurrentDateString()); 
	}catch(Exception e){
		e.printStackTrace();
	}
	return sql;
}

//  兼容老版本 没有request参数
public JSONArray formatHrefforList(JSONArray list,User user){
	 try{
		 if (list != null && list.length()>0) {
	 		  for(int i=0;i<list.length();i++){
	 		    JSONObject json = list.getJSONObject(i);
	 		    if(json.has("href")){
	 		    	json.put("href", formatsql(json.getString("href"),user));
	 		    }
	 		    if(json.has("link")){
	 		    	json.put("link", formatsql(json.getString("link"),user));
	 		    }
	 		    if(json.has("subs")){
	 		    	JSONArray arry = json.getJSONArray("subs");
	 		    	 if (arry != null && arry.length()>0) {
	 			 		  for(int j=0;j<arry.length();j++){
	 			 			   JSONObject json1 = arry.getJSONObject(j);
	 			 			    if(json1.has("href")){
	 			 			    	json1.put("href", formatsql(json1.getString("href"),user));
	 				 		    }
	 			 		  }
	 		    	 }	  
	 		    }
	 		  }
	     }
	 }catch(Exception e){
			e.printStackTrace();
		}
	 return list; 
}
 //重载  formatHrefforList
 public JSONArray formatHrefforList(JSONArray list,User user,HttpServletRequest request){
	 try{
		 if (list != null && list.length()>0) {
	 		  for(int i=0;i<list.length();i++){
	 		    JSONObject json = list.getJSONObject(i);
	 		    if(json.has("href")){
	 		    	json.put("href", formatsql(json.getString("href"),user,request));
	 		    }
	 		    if(json.has("link")){
	 		    	json.put("link", formatsql(json.getString("link"),user,request));
	 		    }
	 		    if(json.has("subs")){
	 		    	JSONArray arry = json.getJSONArray("subs");
	 		    	 if (arry != null && arry.length()>0) {
	 			 		  for(int j=0;j<arry.length();j++){
	 			 			   JSONObject json1 = arry.getJSONObject(j);
	 			 			    if(json1.has("href")){
	 			 			    	json1.put("href", formatsql(json1.getString("href"),user,request));
	 				 		    }
	 			 		  }
	 		    	 }	  
	 		    }
	 		  }
	     }
	 }catch(Exception e){
			e.printStackTrace();
		}
	 return list;
 }

 public JSONObject formatHrefforObject(JSONObject json,User user,HttpServletRequest request){
	 try{
		 if(json.has("href")){
		    	json.put("href", formatsql(json.getString("href"),user,request));
		    }
	 }catch(Exception e){
			e.printStackTrace();
		}
	 return json;
 }

 //兼容老版本么有request 参数
 public JSONObject formatHrefforObject(JSONObject json,User user){
	 try{
		 if(json.has("href")){
		    	json.put("href", formatsql(json.getString("href"),user));
		    }
	 }catch(Exception e){
			e.printStackTrace();
		}
	 return json;
 }
 

private ResourceComInfo rescominfo = null;
private RequestComInfo reqcominfo = null;

private DocComInfo doccominfo = null;

private RecordSet rs = new RecordSet();

//根据类型获取链接
public String getlink(String type,String ids){
	
	String str = "";
	if(type.equals("1")){//人员
		if(ids != null && !"".equals(ids)){
			if(rescominfo == null){
				try{
					rescominfo = new ResourceComInfo(); 
				}catch(Exception e){
					e.printStackTrace();
				}
			}
			List idList = Util.TokenizerString(ids, ",");
			for (int i = 0; i < idList.size(); i++) {
				str += "<a href='/hrm/resource/HrmResource.jsp?id=" + (String)idList.get(i)+"' target='_blank'>"+ rescominfo.getLastname((String)idList.get(i))+"</a>&nbsp;";
			}
		}
	}else if(type.equals("2")){//流程
		if(ids != null && !"".equals(ids)){
			if(reqcominfo == null){
				try{
					reqcominfo = new RequestComInfo();
				}catch(Exception e){
					e.printStackTrace();
				}
			}
			List idList = Util.TokenizerString(ids, ",");
			for (int i = 0; i < idList.size(); i++) {
				str += "<a href='/workflow/request/ViewRequest.jsp?requestid=" + idList.get(i)+"' target='_blank'>"+ reqcominfo.getRequestname((String)idList.get(i))+"</a>&nbsp;";
			}
		}
	}else if(type.equals("3")){//文档
		if(ids != null && !"".equals(ids)){
			if(doccominfo == null){
				doccominfo = new DocComInfo(); 
			}
			List idList = Util.TokenizerString(ids, ",");
			for (int i = 0; i < idList.size(); i++) {
				str += "<a href='/docs/docs/DocDsp.jsp?id=" + idList.get(i)+"' target='_blank' >"+ doccominfo.getDocname((String)idList.get(i))+"</a>&nbsp;";
			}
		}
	}else if(type.equals("4")){//客户
		if(ids != null && !"".equals(ids)){
			rs.executeSql("SELECT id,name FROM CRM_CustomerInfo WHERE id IN("+ids+")");
			while(rs.next()){
				str += "<a href='/CRM/data/ViewCustomer.jsp?CustomerID=" + rs.getString("id") +"' target='_blank' >"+ rs.getString("name") +"</a>&nbsp;";
			}
		}
	}else{
		str = ids;
	}
	return str;
}

//根据类型获取统计数据
public String getNumByType(JSONObject json,String userid){
	String num = "0";
	if(json != null){
		try{
			String type = (String)json.get("type");
			String sql = "";
			if(type.equals("1")){//流程统计
				String workflowid = (String)json.get("workflowid");//流程类型
				String wftype = (String)json.get("wftype");//操作类型
				
				String sqlwhere = "";
				if(workflowid.length() > 0){
					sqlwhere = " AND t2.workflowid IN ("+workflowid+") ";
				}
				
				if(wftype.equals("1")){//待办
					sql = "SELECT  COUNT(DISTINCT t1.requestid) num "+
						"FROM    workflow_requestbase t1 , "+
						"        workflow_currentoperator t2 , "+
						"        workflow_base t3 "+
						"WHERE   t1.requestid = t2.requestid "+
						"        AND ( t2.isremark = '0' "+
						"              AND ( takisremark IS NULL "+
						"                    OR takisremark = 0 "+
						"                  ) "+
						"              OR t2.isremark = '1' "+
						"              OR t2.isremark = '5' "+
						"              OR t2.isremark = '8' "+
						"              OR t2.isremark = '9' "+
						"              OR t2.isremark = '7' "+
						"            ) "+
						"        AND t2.islasttimes = 1 "+
						"        AND t2.userid IN ( "+userid+" ) "+
						"        AND t2.usertype = 0 "+
						"        AND ( t1.deleted = 0 "+
						"              OR t1.deleted IS NULL "+
						"            ) "+
						"        AND t3.id = t2.workflowid "+
						"        AND ( t3.isvalid = '1' "+
						"              OR t3.isvalid = '3' "+
						"            ) "+
						"        AND ( t1.currentstatus <> 1 "+
						"              OR t1.currentstatus IS NULL "+
						"            ) ";
				}else if(wftype.equals("2")){//已办
					sql = "SELECT  COUNT(DISTINCT t1.requestid) num "+
						"FROM    workflow_requestbase t1 , "+
						"        workflow_currentoperator t2 , "+
						"        workflow_base t3 "+
						"WHERE   t1.requestid = t2.requestid "+
						"        AND ( t2.isremark = 2 "+
						"              OR ( t2.isremark = '0' "+
						"                   AND takisremark = -2 "+
						"                 ) "+
						"            ) "+
						"        AND t2.iscomplete = 0 "+
						"        AND t2.islasttimes = 1 "+
						"        AND t2.userid IN ( "+userid+" ) "+
						"        AND t2.usertype = 0 "+
						"        AND ( t1.deleted = 0 "+
						"              OR t1.deleted IS NULL "+
						"            ) "+
						"        AND t3.id = t2.workflowid "+
						"        AND ( t3.isvalid = '1' "+
						"              OR t3.isvalid = '3' "+
						"            ) "+
						"        AND ( t1.currentstatus <> 1 "+
						"              OR t1.currentstatus IS NULL "+
						"            ) ";
				}else if(wftype.equals("3")){//办结
					sql = "SELECT  COUNT(DISTINCT t1.requestid) num "+
						"FROM    workflow_requestbase t1 , "+
						"        workflow_currentoperator t2 , "+
						"        workflow_base t3 "+
						"WHERE   t1.requestid = t2.requestid "+
						"        AND ( t2.isremark IN ( '2', '4' ) "+
						"              OR ( t2.isremark = '0' "+
						"                   AND takisremark = -2 "+
						"                 ) "+
						"            ) "+
						"        AND iscomplete = 1 "+
						"        AND t1.currentnodetype = '3' "+
						"        AND t2.islasttimes = 1 "+
						"        AND t2.userid IN ( "+userid+" ) "+
						"        AND t2.usertype = 0 "+
						"        AND ( t1.deleted = 0 "+
						"              OR t1.deleted IS NULL "+
						"            ) "+
						"        AND t3.id = t2.workflowid "+
						"        AND ( t3.isvalid = '1' "+
						"              OR t3.isvalid = '3' "+
						"            ) "+
						"        AND ( t1.currentstatus <> 1 "+
						"              OR t1.currentstatus IS NULL "+
						"            ) ";
				}
				sql += sqlwhere;
			}else if(type.equals("2")){//文档统计
				String catalog = (String)json.get("catalog");//文档目录
				sql = "SELECT COUNT(*)num FROM docdetail WHERE (subcategory in ("+catalog+") OR seccategory in ("+catalog+") OR seccategory in ("+catalog+")) AND docstatus IN(1,2,5)";
			}
			
			if(sql.length() > 0){
				rs.executeSql(sql);
				if(rs.next()){
					num = rs.getString("num");
				}
			}
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	return num;
}



//根据类型获取统计数据
public String getNumByType(JSONObject json,String userid,String index,String startdate,String enddate){
	// index 1:本月   2:本季度  3:本年
	String num = "0";
	if(json != null){
		try{
			String type = (String)json.get("type");
			String sql = "";
			if(type.equals("1")){//流程统计
				String workflowid = (String)json.get("workflowid");//流程类型
				String wftype = (String)json.get("wftype");//操作类型
				
				String sqlwhere = "";
				if(workflowid.length() > 0){
					sqlwhere = " AND t2.workflowid IN ("+workflowid+") ";
				}
				
				if(wftype.equals("1")){//待办
					sql = "SELECT  COUNT(DISTINCT t1.requestid) num "+
						"FROM    workflow_requestbase t1 , "+
						"        workflow_currentoperator t2 , "+
						"        workflow_base t3 "+
						"WHERE   t1.requestid = t2.requestid "+
						"        AND ( t2.isremark = '0' "+
						"              AND ( takisremark IS NULL "+
						"                    OR takisremark = 0 "+
						"                  ) "+
						"              OR t2.isremark = '1' "+
						"              OR t2.isremark = '5' "+
						"              OR t2.isremark = '8' "+
						"              OR t2.isremark = '9' "+
						"              OR t2.isremark = '7' "+
						"            ) "+
						"        AND t2.islasttimes = 1 "+
						"        AND t2.userid IN ( "+userid+" ) "+
						"        AND t2.usertype = 0 "+
						"        AND ( t1.deleted = 0 "+
						"              OR t1.deleted IS NULL "+
						"            ) "+
						"        AND t3.id = t2.workflowid "+
						"        AND ( t3.isvalid = '1' "+
						"              OR t3.isvalid = '3' "+
						"            ) "+
						"        AND ( t1.currentstatus <> 1 "+
						"              OR t1.currentstatus IS NULL "+
						"            ) ";
				}else if(wftype.equals("2")){//已办
					sql = "SELECT  COUNT(DISTINCT t1.requestid) num "+
						"FROM    workflow_requestbase t1 , "+
						"        workflow_currentoperator t2 , "+
						"        workflow_base t3 "+
						"WHERE   t1.requestid = t2.requestid "+
						"        AND ( t2.isremark = 2 "+
						"              OR ( t2.isremark = '0' "+
						"                   AND takisremark = -2 "+
						"                 ) "+
						"            ) "+
						"        AND t2.iscomplete = 0 "+
						"        AND t2.islasttimes = 1 "+
						"        AND t2.userid IN ( "+userid+" ) "+
						"        AND t2.usertype = 0 "+
						"        AND ( t1.deleted = 0 "+
						"              OR t1.deleted IS NULL "+
						"            ) "+
						"        AND t3.id = t2.workflowid "+
						"        AND ( t3.isvalid = '1' "+
						"              OR t3.isvalid = '3' "+
						"            ) "+
						"        AND ( t1.currentstatus <> 1 "+
						"              OR t1.currentstatus IS NULL "+
						"            ) ";
				}else if(wftype.equals("3")){//办结
					sql = "SELECT  COUNT(DISTINCT t1.requestid) num "+
						"FROM    workflow_requestbase t1 , "+
						"        workflow_currentoperator t2 , "+
						"        workflow_base t3 "+
						"WHERE   t1.requestid = t2.requestid "+
						"        AND ( t2.isremark IN ( '2', '4' ) "+
						"              OR ( t2.isremark = '0' "+
						"                   AND takisremark = -2 "+
						"                 ) "+
						"            ) "+
						"        AND iscomplete = 1 "+
						"        AND t1.currentnodetype = '3' "+
						"        AND t2.islasttimes = 1 "+
						"        AND t2.userid IN ( "+userid+" ) "+
						"        AND t2.usertype = 0 "+
						"        AND ( t1.deleted = 0 "+
						"              OR t1.deleted IS NULL "+
						"            ) "+
						"        AND t3.id = t2.workflowid "+
						"        AND ( t3.isvalid = '1' "+
						"              OR t3.isvalid = '3' "+
						"            ) "+
						"        AND ( t1.currentstatus <> 1 "+
						"              OR t1.currentstatus IS NULL "+
						"            ) ";
				}
				sql += sqlwhere;
			}else if(type.equals("2")){//文档统计
				String catalog = (String)json.get("catalog");//文档目录
				sql = "SELECT COUNT(*)num FROM docdetail WHERE (subcategory in ("+catalog+") OR seccategory in ("+catalog+") OR seccategory in ("+catalog+")) AND docstatus IN(1,2,5)";
				String whereSql = getWhereSql(index,"doccreatedate",startdate,enddate);
				sql += whereSql;
			}else if(type.equals("3")){//工作轨迹-流程
				String wftype = (String)json.get("wftype");//类型
				if("1".equals(wftype)){//发起流程
					sql = " select count(requestid) as num from workflow_requestbase where creater="+userid+" ";
					String whereSql = getWhereSql(index,"createdate",startdate,enddate);
					sql += whereSql;
				}else if("2".equals(wftype)){//处理流程 
					sql = "select count(requestid) as num from workflow_requestLog where operator="+userid+" ";
					String whereSql = getWhereSql(index,"operatedate",startdate,enddate);
					sql += whereSql;
				}
			}else if(type.equals("4")){//工作轨迹-文档
				String wftype = (String)json.get("wftype");//类型
				if("1".equals(wftype)){//新建文档
					sql = " select count(id) as num from DocDetail where isreply<>1 and doccreaterid="+userid+"  ";
					String whereSql = getWhereSql(index,"doccreatedate",startdate,enddate);
					sql += whereSql;
				}else if("2".equals(wftype)){//查看文档 
					sql = "select count(docid) as num from DocDetailLog where operateuserid="+userid+"  ";
					String whereSql = getWhereSql(index,"operatedate",startdate,enddate);
					sql += whereSql;
				}else if("3".equals(wftype)){//回复文档  
					sql = "select count(id) as num from DocDetail where isreply=1 and doccreaterid="+userid+"   ";
					String whereSql = getWhereSql(index,"doccreatedate",startdate,enddate);
					sql += whereSql;
				}
			}else if(type.equals("5")){//工作轨迹-协作
				String wftype = (String)json.get("wftype");//类型
				if("1".equals(wftype)){//发起协作  
					sql = "select count(coworkid) as num from cowork_log where type=1 and modifier="+userid+" ";
					String whereSql = getWhereSql(index,"modifydate",startdate,enddate);
					sql += whereSql;
				}else if("2".equals(wftype)){//查看协作  
					sql = "select count(coworkid) as num from cowork_log where type=2 and modifier="+userid+"  ";
					String whereSql = getWhereSql(index,"modifydate",startdate,enddate);
					sql += whereSql;
				}else if("3".equals(wftype)){//回复协作  
					sql = "select count(coworkid) as num from cowork_discuss where discussant="+userid+" ";
					String whereSql = getWhereSql(index,"createdate",startdate,enddate);
					sql += whereSql;
				}
			}else if(type.equals("6")){//工作轨迹-日程
				String wftype = (String)json.get("wftype");//类型
				if("1".equals(wftype)){//发起日程
					sql = "select count(t1.workPlanId) as num from WorkPlanViewLog t1 join WorkPlan t2 on t1.workPlanId=t2.id where t1.viewType=1 and t2.type_n<>3 and t1.userType=1 and t1.userId="+userid+"  ";
					String whereSql = getWhereSql(index,"logDate",startdate,enddate);
					sql += whereSql;
				}else if("2".equals(wftype)){//查看日程 
					sql = "select count(t1.workPlanId) as num from WorkPlanViewLog t1 join WorkPlan t2 on t1.workPlanId=t2.id where t1.viewType=3 and t2.type_n<>3 and t1.userType=1 and t1.userId="+userid+"  ";
					String whereSql = getWhereSql(index,"logDate",startdate,enddate);
					sql += whereSql;
				}else if("3".equals(wftype)){//反馈日程 
					sql = "select count(t1.sortid) as num from Exchange_Info t1 join WorkPlan t2 on t1.sortid=t2.id where t1.type_n='WP' and t2.type_n<>3 and t1.creater="+userid+"  ";
					String whereSql = getWhereSql(index,"createDate",startdate,enddate);
					sql += whereSql;
				}
			}else if(type.equals("7")){//工作轨迹-客户
				String wftype = (String)json.get("wftype");//类型 
				if("1".equals(wftype)){//新建客户
					sql = "select count(customerid) as num from CRM_Log where logtype='n' and submiter="+userid+" ";
					String whereSql = getWhereSql(index,"submitdate",startdate,enddate);
					sql += whereSql;
				}else if("2".equals(wftype)){//联系客户
					sql = "select count(id) as num from WorkPlan where createrid="+userid+" ";
					String whereSql = getWhereSql(index,"createdate",startdate,enddate);
					sql += whereSql;
				}
			}else if(type.equals("8")){//新建项目 
				sql = "select count(id) as num from prj_projectinfo where creater="+userid+"  ";
				String whereSql = getWhereSql(index,"createdate",startdate,enddate);
				sql += whereSql;
			}else if(type.equals("9")){//填写微博 
				sql = " select count(id) as num from blog_discuss where userid="+userid+"  ";
				String whereSql = getWhereSql(index,"createdate",startdate,enddate);
				sql += whereSql;
			}else if(type.equals("10")){//新建任务 
				sql = " select count(id) as num from TM_TaskInfo where creater="+userid+"  ";
				String whereSql = getWhereSql(index,"createdate",startdate,enddate);
				sql += whereSql;
			}
			
			if(sql.length() > 0){
				rs.executeSql(sql);
				if(rs.next()){
					num = rs.getString("num");
				}
			}
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	return num;
}

public String getWhereSql(String index,String timefiled,String startDate,String endDate){
	RecordSet rs = new RecordSet();
	String sqlWhere = "";
	try{
		if("1".equals(index)){//本月
			if(rs.getDBType().equals("oracle")){
				sqlWhere = " and to_char(to_date("+timefiled+",'yyyy-mm-dd'),'mm')=to_char(sysdate,'mm')  ";
			}else{
				sqlWhere = " and  datediff(mm,"+timefiled+",getdate()) = 0 ";
			}
		}else if("2".equals(index)){//本季度
			if(rs.getDBType().equals("oracle")){
				sqlWhere = "  and  to_char(to_date("+timefiled+",'yyyy-mm-dd'),'q')=to_char(sysdate,'q') ";
			}else{
				String startTime = TimeUtil.getFirstDayOfSeason();
				String endTime = TimeUtil.getLastDayDayOfSeason();
				sqlWhere = " and  "+timefiled+" BETWEEN '"+startTime+"' AND '"+endTime+"' ";
			}
		}else if("3".equals(index)){//本年
			if(rs.getDBType().equals("oracle")){
				sqlWhere = " and  to_char(to_date("+timefiled+",'yyyy-mm-dd'),'yyyy')=to_char(sysdate,’yyyy’)  ";
			}else{
				sqlWhere = " and datediff(year,"+timefiled+",getdate())=0 ";
			}
		}else if("4".equals(index)){//自定义
			if(!"".equals(startDate)){
				sqlWhere += " and "+timefiled+" >= '"+startDate+"' ";	
			}
			if(!"".equals(endDate)){
				sqlWhere += " and "+timefiled+" <= '"+endDate+"' ";	
			}
		}
	} catch (Exception e) {
		e.printStackTrace();
	}
	return sqlWhere;
}

/**
 * 得到相关附件
 * @param ids
 * @return
 */
public static List<Map<String,String>> getFileDocList(String ids) throws Exception{
	List<Map<String,String>> list = new ArrayList<Map<String,String>>();
	if(ids != null && !"".equals(ids)){
		List fileidList = Util.TokenizerString(ids,",");
		Map<String,String> map = null;
		DocImageManager dm = new DocImageManager();
		for(int i=0;i<fileidList.size();i++){
			if(!"0".equals(fileidList.get(i)) && !"".equals(fileidList.get(i))){
				dm.resetParameter();
				dm.setDocid(Integer.parseInt((String)fileidList.get(i)));
				dm.selectDocImageInfo();
				dm.next();
	            String docImagefileid = dm.getImagefileid();
	            int docImagefileSize = dm.getImageFileSize(Util.getIntValue(docImagefileid));
	            String docImagefilename = dm.getImagefilename();
	            map = new HashMap<String,String>();
				map.put("id", Util.null2String(fileidList.get(i)));
				map.put("name",docImagefilename);
				map.put("size",(docImagefileSize/1000)+"k");
				list.add(map);
			}
	     }
	}
	return list;
}

public static List<Map<String,String>> getWorkFlowSelectList(String tablename,String fieldname){
	List<Map<String,String>> list = new ArrayList<Map<String,String>>();
	String sql = "SELECT t3.selectvalue,t3.selectname FROM  workflow_billfield t JOIN workflow_bill t2 ON t.billid = t2.id"
			+ " JOIN workflow_SelectItem t3 ON t.id = t3.fieldid WHERE tablename = '"+tablename+"' AND fieldname = '"+fieldname+"' and t3.cancel != 1 ORDER BY listorder ";
	RecordSet rs = new RecordSet();
	rs.executeQuery(sql);
	Map<String,String> map = null;
	while(rs.next()){
		map = new HashMap<String,String>();
		map.put("name", Util.null2String(rs.getString("selectname")));
		map.put("key", Util.null2String(rs.getString("selectvalue")));
		list.add(map);
	}
	return list;
}
public static Map<String,String> getWorkFlowSelectMap(String tablename,String fieldname){
	Map<String,String> selectmap = new HashMap<String,String>();
	String sql = "SELECT t3.selectvalue,t3.selectname FROM  workflow_billfield t JOIN workflow_bill t2 ON t.billid = t2.id"
			+ " JOIN workflow_SelectItem t3 ON t.id = t3.fieldid WHERE tablename = '"+tablename+"' AND fieldname = '"+fieldname+"' ORDER BY listorder ";
	RecordSet rs = new RecordSet();
	rs.executeQuery(sql);
	Map<String,String> map = null;
	while(rs.next()){
		selectmap.put(Util.null2String(rs.getString("selectvalue")), Util.null2String(rs.getString("selectname")));
	}
	return selectmap;
}
/** sqlserver 分页
*   retrun 返回值{sql,iTotal,totalPage}
*	pageSize  一页多少条
*	pageNum
*	sqlBase
*	fromSql  需包含from关键字
*	whereSql 需包含where关键字
*	orderby  需包含order by关键字
*/
public static Map<String,Object>TablePage(int pageSize,int pageNum,String sqlBase,String fromSql,String whereSql,String orderby){
	Map<String,Object>map = new HashMap<String,Object>();
	try{
		RecordSet rs = new RecordSet();
		String countSql = " SELECT COUNT(1)  "+fromSql+ whereSql+" ";
		int iTotal = 0;
		int totalPage = 0;
		rs.executeQuery(countSql);
		if (rs.next()) {
			iTotal = rs.getInt(1);
		}
		totalPage = iTotal / pageSize;
		if (iTotal % pageSize > 0)
			totalPage += 1;
		int iNextNum = pageNum * pageSize;
		int ipageset = pageSize;
		if (iTotal - iNextNum + pageSize < pageSize)ipageset = iTotal - iNextNum + pageSize;
		if (iTotal < pageSize)ipageset = iTotal;
		
		 String orderby1 = orderby;
		 String orderby2 = "";
		 if(orderby.contains(" asc")){
			 orderby2 = orderby.replaceAll(" asc", " desc");
		 }else if(orderby.contains(" desc")){
			 orderby2 = orderby.replaceAll(" desc", " asc");
		 }
		 String orderby3 = orderby;
		 String sql = "";
	 	 sql = "select top " + ipageset + " A.* from (select top "+ iNextNum  + sqlBase + fromSql + whereSql  + orderby1 +" ) A "+ orderby2;
		 sql = "select top " + ipageset + " B.* from (" + sql + ") B "+ orderby3;

	      map.put("sql", sql);
	      map.put("iTotal", iTotal);
	      map.put("totalPage", totalPage);
	}catch(Exception e){
		e.printStackTrace();
	}
	return map;
}

/** oracle分页
*   retrun 返回值{sql,iTotal,totalPage}
*	pageSize  一页多少条
*	pageNum
*	sqlBase
*	fromSql  需包含from关键字
*	whereSql 需包含where关键字
*	orderby  需包含order by关键字
*/
public static Map<String,Object>TablePageOracle(int pageSize,int pageNum,String sqlBase,String fromSql,String whereSql,String orderby){
	Map<String,Object>map = new HashMap<String,Object>();
	try{
		RecordSet rs = new RecordSet();
		String countSql = " SELECT COUNT(1)  "+fromSql+ whereSql+" ";
		int iTotal = 0;
		int totalPage = 0;
		rs.executeQuery(countSql);
		if (rs.next()) {
			iTotal = rs.getInt(1);
		}
		totalPage = iTotal / pageSize;
		if (iTotal % pageSize > 0)
			totalPage += 1;
		int iNextNum = pageNum * pageSize;
		int ipageset = pageSize;
		if (iTotal - iNextNum + pageSize < pageSize)ipageset = iTotal - iNextNum + pageSize;
		if (iTotal < pageSize)ipageset = iTotal;
		
		 String sql = "";
		 sql = "select "+sqlBase+",rownum" + fromSql + whereSql  + orderby + "";
		 sql = "select A.*,rownum rn from (" + sql + ") A where rownum <= " +  iNextNum ;
		 sql = "select B.* from (" + sql + ") B where rn > " + (iNextNum - pageSize) ;
		 
	      map.put("sql", sql);
	      map.put("iTotal", iTotal);
	      map.put("totalPage", totalPage);
	}catch(Exception e){
		e.printStackTrace();
	}
	return map;
}


/**
 * 得到图片附件
 * @param ids
 * @return
 */
public static String getFileIMGId(String id) throws Exception{
	if(id == null || id.length() == 0){
		return "";
	}
	Map<String,String> map = null;
	DocImageManager dm = new DocImageManager();
	dm.resetParameter();
	dm.setDocid(Integer.parseInt(id));
	dm.selectDocImageInfo();
	dm.next();
    String docImagefileid = dm.getImagefileid();
	return docImagefileid;
}

/**
 * 获取系统数据
 * @return
 */
public static Map getModelMsg(String tablename,String systype){
	Map map = new HashMap();
	try{
		RecordSet rs = new RecordSet();
		String sql = "select t2.id modeid,t2.formid from workflow_bill t join modeinfo t2 on t.id = t2.formid where tablename = '"+tablename+"'";
	    boolean flag = rs.executeQuery(sql);
	    String formid = "";
		if(rs.next()){
			map.put("modeid",Util.null2String(rs.getString("modeid")));
			formid = Util.null2String(rs.getString("formid"));
			map.put("formid",formid);
		}
		
		sql = "SELECT id fieldid,fieldname from workflow_billfield where billid = "+formid+" ";
		boolean flag1 = rs.executeQuery(sql);
		while(rs.next()){
			String filename = Util.null2String(rs.getString("fieldname"));
			if(!"".equals(filename)){
				map.put(filename,Util.null2String(rs.getString("fieldid")));
			}
		}
		if("9".equals(systype)){
			map.put("createurl","/spa/cube/index.html#/main/cube/card");
			map.put("listurl", "/spa/cube/index.html#/main/cube/search");
		}else{
			map.put("createurl","/formmode/view/AddFormMode.jsp");
			map.put("listurl", "/formmode/search/CustomSearchBySimple.jsp");
		}
	}catch(Exception e){
			e.printStackTrace();
	}
	return map;
}

%>