package com.higer.oa.workflow.action;

import java.util.Map;

import com.higer.oa.workflow.dao.UpdateDocNameForGWFBDao;

import weaver.interfaces.workflow.action.Action;
import weaver.soa.workflow.request.RequestInfo;

public class UpdateDocNameForGWFB implements Action {

	@Override
	public String execute(RequestInfo info) {
		String workflowid = info.getWorkflowid();
		String requestid = info.getRequestid();
		UpdateDocNameForGWFBDao ud = new UpdateDocNameForGWFBDao();
		String tableName = ud.getWorkflowTableNameById(workflowid);
		Map<String, String> mainInfo = ud.getMainInfo(requestid, tableName);
		String official_doc_name = mainInfo.get("official_doc_name");
		String fblx1 = mainInfo.get("fblx1");
		String official_doc_attachment = mainInfo.get("official_doc_attachment");
		if(!"".equals(official_doc_attachment)) {
			String fblx1name = ud.getSelectValue("fblx1", fblx1, tableName);
			String newdocname = "";
			if("".equals(fblx1name)) {
				newdocname = official_doc_name;
			}else {
				newdocname = "【"+fblx1name+"】 "+official_doc_name;
			}
			ud.updateDocName(newdocname, official_doc_attachment);
		}

		return SUCCESS;
	}

}
