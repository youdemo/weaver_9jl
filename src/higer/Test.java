package com.higer;

import java.util.HashMap;
import java.util.Map;

import javax.xml.namespace.QName;
import javax.xml.rpc.ParameterMode;

import org.apache.axis.client.Call;
import org.apache.axis.client.Service;
import org.apache.axis.encoding.XMLType;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

public class Test {

    private static final String WSDL_URL = "http://192.168.200.205:8086/services/HigerWorkflowService";

    private static final String WINDCHILL_USER = "sysadmin";

    private static final String WINDCHILL_PWD = "1";

    public static void main(String[] args) throws Exception {
        testWebService();
    }

    public static void testWebService() {
        try {
            Service service = new Service();
            Call call = (Call) service.createCall();
            call.setTargetEndpointAddress(WSDL_URL);
            call.setOperationName(new QName(WSDL_URL, "createWorkflow"));
            call.setUsername(WINDCHILL_USER);
            call.setPassword(WINDCHILL_PWD);
            call.addParameter("workflowInfo", XMLType.SOAP_STRING, ParameterMode.IN);
            call.setReturnClass(String.class);
            JSONObject workflowInfo = new JSONObject();
            workflowInfo.put("workflow", "test_test");
            workflowInfo.put("creator", "luolf");
            workflowInfo.put("isNext", "1");
            JSONObject mainTableData = new JSONObject();
            // mainTableData.put("zt", "通过接口创建流程Test——流程主题1");
            // mainTableData.put("zbmc", "通过接口");
            mainTableData.put("spr", "35400");
            workflowInfo.put("mainTableData", mainTableData);
            // workflowInfo.put("detailDatas", "0");

            JSONArray detailTableDatas1 = new JSONArray();
            JSONObject detailTableData = new JSONObject();
            detailTableData.put("mxbmc", "名称1");
            detailTableDatas1.add(detailTableData);

            detailTableData = new JSONObject();
            detailTableData.put("mxbmc", "名称2");
            detailTableDatas1.add(detailTableData);

            JSONObject detailTableDatas = new JSONObject();
            detailTableDatas.put("dt1", detailTableDatas1);

            workflowInfo.put("detailDatas", detailTableDatas);

            String result = (String) call.invoke(new Object[] { workflowInfo.toString() });
            System.out.println(result);
            Map<Integer,Integer> map = new HashMap<Integer,Integer>();
        } catch (Exception e) {
            e.printStackTrace();
        }
        System.out.println("END");
    }
}
