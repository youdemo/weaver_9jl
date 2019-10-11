package com.higer.oa.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import weaver.conn.RecordSet;
import weaver.docs.docs.DocComInfo;
import weaver.general.Util;

public class CreateOrUpdateDocDao {
	 /**
     * 日志.
     */
   // private static Logger LOGGER = Logger.getLogger(CreateOrUpdateDocDao.class);

    /**
     * RecordSet.
     */
    private RecordSet rs;

    
    /**
     	* 构造方法.
     */
    public CreateOrUpdateDocDao() {
        rs = new RecordSet();
    }
    /**
     	*  根据workflowid获取表名
     * @param workflowid workflowid
     * @return
     */
    public String getWorkflowTableNameById(String workflowid) {
        rs.execute("select tablename from workflow_bill where id=(select formid from workflow_base where id=" + workflowid + ")");
        if (rs.next()) {
            return Util.null2String(rs.getString("tablename"));
        }
        return "";
    }
    /**
     * 获取流程主表数据
     * @param requestid
     * @param tableName
     * @return
     */
    public Map<String,String> getMainInfo(String requestid,String tableName) {
    	Map<String,String> map = new HashMap<String,String>();
    	 rs.execute("select official_doc_name,fblx1,official_doc_attachment,zwfj,zw from " + tableName + " where requestid = " + requestid);
         if (rs.next()) {
         	map.put("official_doc_name", Util.null2String(rs.getString("official_doc_name")));
         	map.put("fblx1", Util.null2String(rs.getString("fblx1")));
         	map.put("official_doc_attachment", Util.null2String(rs.getString("official_doc_attachment")));
         	map.put("zwfj", Util.null2String(rs.getString("zwfj")));
         	map.put("zw", Util.null2String(rs.getString("zw")));
         }
        return map;
    }
    /**
     * 获取流程明细数据
     * @param mainId 主表数据id
     * @param tableName 明细表名
     * @return
     */
    public List<Map<String,String>> getDetailInfo(String mainId,String tableName) {
    	List<Map<String,String>> list = new ArrayList<Map<String,String>>();
        rs.execute("select mxid from "+tableName+" where mainid="+mainId);
        while (rs.next()) {
        	Map<String,String> map = new HashMap<String,String>();
        	map.put("mxid", Util.null2String(rs.getString("mxid")));
        	list.add(map);
        }
        return list;
    }
    
    public String getDepartmentid(String ryid) {
    	String departmetnid = "";
        rs.execute("select departmentid from hrmresource where id="+ryid);
        if (rs.next()) {
        	departmetnid = Util.null2String(rs.getString("departmentid"));
        }
        return departmetnid;
    }
    
    public Map<String,String> getSelectValue(String fieldName,String fieldValue,String tableName) {
    	Map<String,String> map = new HashMap<String,String>();
        rs.execute("select selectname,c.doccategory from workflow_billfield a, workflow_bill b,workflow_selectitem c where a.billid=b.id and c.fieldid=a.id  and b.tablename='"+tableName+"' and a.fieldname='"+fieldName+"' and c.selectvalue='"+fieldValue+"' and cancel=0");
        if (rs.next()) {
        	map.put("selectname", Util.null2String(rs.getString("selectname")));
        	map.put("doccategory", Util.null2String(rs.getString("doccategory")));
        }
        return map;
    }
    
    public void copyFile(String docid,String zwdocid) {
    	String sql = "insert into docimagefile(id,docid,imagefileid,imagefilename,imagefiledesc,imagefilewidth,imagefileheight,imagefielsize,docfiletype,versionId,versionDetail,isextfile,hasUsedTemplet,signatureCount) " + 
    			"select (select currentid from SequenceIndex where indexdesc='docimageid') as id,"+docid+" as docid,imagefileid,imagefilename,imagefiledesc,imagefilewidth,imagefileheight,imagefielsize,docfiletype,(select currentid from SequenceIndex where indexdesc='versionid') as versionId,versionDetail,isextfile,hasUsedTemplet,signatureCount from docimagefile where docid="+zwdocid+" and rownum=1";
    	rs.execute(sql);
    	rs.execute("update SequenceIndex set currentid=currentid+1 where indexdesc='docimageid'");
    	rs.execute("update SequenceIndex set currentid=currentid+1 where indexdesc='versionid'");
    }
    
    public void UpdateZw(String requestId,String tableName,String zw) {
    	rs.execute("update "+tableName+" set zw='"+zw+"' where requestid="+requestId);
    }
    public void UpdateDoc(String docid,String name) {
    	rs.execute("update docdetail set docsubject='"+name+"' where id="+docid);  
    	rs.execute("delete from docimagefile where docid="+docid);
    }
    
    public void UpdateStatus(String docid) {
    	rs.execute("update docdetail set docstatus='0' where id="+docid); 
    }
	
	
	public void deleteDoc(String docid) {
		DocComInfo doccominfo = new DocComInfo(); 
		rs.execute("delete from DocDetail where id="+docid);
		rs.execute("delete from DocShare where docid="+docid);
		rs.execute("delete from ShareinnerDoc where sourceid="+docid);
		rs.execute("delete from ShareouterDoc where sourceid="+docid);
		rs.execute("delete from DocImageFile where docid="+docid);
		rs.execute("delete from docreadtag where docid="+docid);
		rs.execute("delete from DocDetailLog where docid="+docid);
		doccominfo.deleteDocInfoCache(docid);
	}
	

}
