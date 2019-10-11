package com.higer.oa.workflow.action;

import java.util.Map;

import com.higer.oa.workflow.dao.CreateOrUpdateDocDao;
import com.sun.media.Log;

import weaver.docs.webservices.DocInfo;
import weaver.docs.webservices.DocServiceImpl;
import weaver.general.BaseBean;
import weaver.general.Util;
import weaver.hrm.User;
import weaver.interfaces.workflow.action.Action;
import weaver.soa.workflow.request.RequestInfo;

public class CreateOrUpdateDocAction implements Action {

	@Override
	public String execute(RequestInfo info) {
		String operaterid = info.getRequestManager().getUser().getUID() + "";
		String workflowid = info.getWorkflowid();
		String requestid = info.getRequestid();
		CreateOrUpdateDocDao cudd = new CreateOrUpdateDocDao();
		String tableName = cudd.getWorkflowTableNameById(workflowid);
		Map<String, String> mainInfo = cudd.getMainInfo(requestid, tableName);
		String official_doc_name = mainInfo.get("official_doc_name");
		String fblx1 = mainInfo.get("fblx1");
		String official_doc_attachment = mainInfo.get("official_doc_attachment");
		String zwfj = mainInfo.get("zwfj");
		String zw = mainInfo.get("zw");
		Map<String, String> selectMap = cudd.getSelectValue("fblx1", fblx1, tableName);
		String selectname = selectMap.get("selectname");
		String doccategory = selectMap.get("doccategory");
		String newdocname = "";
		if ("".equals(selectname)) {
			newdocname = official_doc_name;
		} else {
			newdocname = "【" + selectname + "】 " + official_doc_name;
		}
		if (!"".equals(zw)) {
			cudd.deleteDoc(zw);
			cudd.UpdateZw(requestid, tableName, "");

		}

		String docid = "";
		try {
			docid = getDocId(newdocname, "", operaterid, doccategory);
		} catch (Exception e) {
			info.getRequestManager().setMessagecontent("生成文档失败,请联系你得管理员");
			info.getRequestManager().setMessageid("01");
		}
		zw = docid;
		if (!"".equals(zw)) {
			cudd.UpdateZw(requestid, tableName, zw);
			String zwfjs[] = zwfj.split(",");
			for (String zwdocid : zwfjs) {
				if (!"".equals(zwdocid)) {
					cudd.copyFile(zw, zwdocid);
				}
			}
			String att[] = official_doc_attachment.split(",");
			for (String attdocid : att) {
				if (!"".equals(attdocid)) {
					cudd.copyFile(zw, attdocid);
				}
			}
		}
		if (!"".equals(zw)) {
			cudd.UpdateStatus(zw);
		}

		return SUCCESS;
	}

	private String getDocId(String name, String value, String createrid, String seccategory) throws Exception {
		String docId = "";
		DocInfo di = new DocInfo();
		CreateOrUpdateDocDao cudd = new CreateOrUpdateDocDao();
		di.setMaincategory(0);
		di.setSubcategory(0);
		di.setSeccategory(Util.getIntValue(seccategory));
		di.setDocSubject(name);
		di.setDocStatus(0);
//        DocAttachment doca = new DocAttachment();
//        doca.setFilename(name);
//        byte[] buffer = new BASE64Decoder().decodeBuffer(value);
//        String encode = Base64.encode(buffer);
//        doca.setFilecontent(encode);
//        DocAttachment[] docs = new DocAttachment[1];
//        docs[0] = doca;
//        di.setAttachments(docs);
		String departmentId = "-1";
		departmentId = cudd.getDepartmentid(createrid);
		if ("".equals(departmentId)) {
			departmentId = "-1";
		}
		User user = new User();

		user.setUid(Util.getIntValue(createrid));
		user.setUserDepartment(Util.getIntValue(departmentId));
		user.setLanguage(7);
		user.setLogintype("1");
		user.setLoginip("127.0.0.1");
		DocServiceImpl ds = new DocServiceImpl();
		try {
			docId = String.valueOf(ds.createDocByUser(di, user));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return docId;
	}

}
