package com.higer.oa.workflow.action;

import java.util.List;
import java.util.Map;

import com.higer.oa.workflow.dao.UpdateMeetingAgendaStatusDao;

import weaver.interfaces.workflow.action.Action;
import weaver.soa.workflow.request.RequestInfo;

public class UpdateMeetingAgendaStatus implements Action {

	@Override
	public String execute(RequestInfo info) {
		String workflowid = info.getWorkflowid();
		String requestid = info.getRequestid();
		UpdateMeetingAgendaStatusDao ad = new UpdateMeetingAgendaStatusDao();
		String tableName = ad.getWorkflowTableNameById(workflowid);
		Map<String, String> mainInfo = ad.getMainInfo(requestid, tableName);
		String glyc = mainInfo.get("glyc");
		String mainId = mainInfo.get("mainId");
		if (!"".equals(glyc)) {
			List<Map<String, String>> detailInfo = ad.getDetailInfo(mainId, tableName + "_dt1");
			String ycids = "";
			String flag = "";
			for (Map<String, String> map : detailInfo) {
				ycids = ycids + flag + map.get("mxid");
				flag = ",";
			}
			if (!"".equals(ycids)) {
				ad.UpdateAgendaStatus(glyc, ycids);
				List<Map<String, String>> glytList = ad.getGLYt(glyc, ycids);
				for (Map<String, String> map : glytList) {
					String ytids = map.get("ytgl");
					if (!"".equals(ytids)) {
						ad.UpdateYtStatus(ytids, "0");
					}
				}
				List<Map<String, String>> wglytList = ad.getWGLYt(glyc, ycids);
				for (Map<String, String> map : wglytList) {
					String ytids = map.get("ytgl");
					if (!"".equals(ytids)) {
						ad.UpdateYtStatus(ytids, "1");
					}
				}

			}
		}

		return SUCCESS;
	}

}
