package higer.portal.job;

import higer.portal.service.RequestOAServiceStub;
import higer.portal.service.RequestOAServiceStub.GetTasksForOa;
import higer.portal.service.RequestOAServiceStub.GetTasksForOaResponse;

public class GetJobWData {
	
	public String getServiceData(String loginid) throws Exception {
		RequestOAServiceStub ros = new RequestOAServiceStub();
		GetTasksForOa gtf =new RequestOAServiceStub.GetTasksForOa();
		gtf.setLoadUser(loginid);
		GetTasksForOaResponse res =ros.GetTasksForOa(gtf);
		return res.getGetTasksForOaResult();
	}
}
