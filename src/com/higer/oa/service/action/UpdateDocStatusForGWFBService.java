package com.higer.oa.service.action;

import java.util.Map;

import com.higer.oa.dao.UpdateDocStatusForGWFBDao;

import weaver.interfaces.workflow.action.Action;
import weaver.soa.workflow.request.RequestInfo;

public class UpdateDocStatusForGWFBService implements Action{

	@Override
	public String execute(RequestInfo info) {
		String workflowid = info.getWorkflowid();
		String requestid = info.getRequestid();
		UpdateDocStatusForGWFBDao udsf = new UpdateDocStatusForGWFBDao();
		String tableName = udsf.getWorkflowTableNameById(workflowid);
		Map<String, String> mainInfo = udsf.getMainInfo(requestid, tableName);
		String zw = mainInfo.get("zw"); 
		if(!"".equals(zw)) {
			udsf.UpdateStatus(zw);
		}		
		return SUCCESS;
	}

}
