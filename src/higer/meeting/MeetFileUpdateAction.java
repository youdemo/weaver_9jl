package higer.meeting;

import weaver.conn.RecordSet;
import weaver.general.BaseBean;
import weaver.general.Util;
import weaver.interfaces.workflow.action.Action;
import weaver.soa.workflow.request.RequestInfo;

public class MeetFileUpdateAction implements Action{
	/**
	 * 会议子流程反馈文件更新会议主流程通知写入建模数据
	*/
	BaseBean log = new BaseBean();
	public String execute(RequestInfo info) {
		String workflowID = info.getWorkflowid();
		String requestid = info.getRequestid();		
		RecordSet rs = new RecordSet();
		String  tableName = "";
		String sql  = " Select tablename From Workflow_bill Where id in ("
				+ " Select formid From workflow_base Where id= "
				+ workflowID + ")";
		rs.execute(sql);
		if(rs.next()){
			tableName = Util.null2String(rs.getString("tablename"));
		}	
		sql = "select * from "+tableName + " where requestid="+requestid;
		rs.execute(sql);
		if(rs.next()){
			String hymc1 = Util.null2String(rs.getString("hymc1")); //主流程requestid
			String xgfj = Util.null2String(rs.getString("xgfj")); //相关附件
			String scr = Util.null2String(rs.getString("scr")); //上传人
			
			if(!"".equals(xgfj)) {
				//数据更新
				int idx = 0;
				sql = " select id as idx from uf_qdym_dt1 where fzr = '"+scr+"' and mainid in (select id from uf_qdym where lcid = '"+hymc1+"')";
				rs.execute(sql);
				if(rs.next()){
					idx = rs.getInt("idx");
				}
				if(idx!=0) {
					//有发言人则更新发言人议程附件
					sql = " update uf_qdym_dt1 set ycfj ='"+xgfj+"' where id ="+idx;
					rs.execute(sql);
					log.writeLog("Update meeting Document 1---"+sql);
				}else {
					sql = " update uf_qdym set xgfj = xgfj||',"+xgfj+"' where lcid = '"+hymc1+"' ";
					rs.execute(sql);
					log.writeLog("Update meeting Document 2---"+sql);
				}
			}
		}
		return SUCCESS;
	}
}
