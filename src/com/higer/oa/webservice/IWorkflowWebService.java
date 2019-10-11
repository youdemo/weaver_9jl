package com.higer.oa.webservice;

/**
 * 流程Webservice接口.
 *
 */
public interface IWorkflowWebService {

    /**
     * 创建流程.
     * 
     * @param workflowInfo
     *            流程信息.<br />
     *            格式说明 ： { "workflow" ： "12", "creator" : "11", "isNext" :
     *            "1","title":"流程标题","requestlevel":"紧急程度","remindtype":"xx",
     *            "detailDatas" : { "dt1" : [{ "b1" : "2", "a1" : "1" }, { "b2"
     *            : "22", "a2" : "12" } ], "dt2" : [{ "b2" : "22", "a2" : "11" }
     *            ] }, "mainTableData" : { "aa" : "aa2", "bb" : "bb2" } } <br />
     *            <li>workflow ：流程标识</li><br />
     *            <li>creator : 创建人账号(OA系统中对应人的loginId)</li><br />
     *            <li>isNext :0:不提交(默认),1:提交(流程会执行到下一个关卡)</li><br />
     *            <li>title ：标题,不设置时标题为:流程名称-创建人名称-创建日期(yyyy-MM-dd)</li><br />
     *            <li>requestlevel ：紧急程度</li><br />
     *            <li>remindtype ：remindtype</li><br />
     *            <li>detailDatas : 明细表数据</li><br />
     *            <li>dt1 :第一个明细表(必须以dt开头,且后面的数字必须连续)</li><br />
     *            <li>b1: 明细表的字段名称</li><br />
     *            <li>2: 字段b1的值.</li><br />
     *            <li>dt2:第二个明细表</li><br />
     *            <li>mainTableData:主表数据</li><br />
     *            <li>aa: 主表的字段名称</li><br />
     *            <li>aa2：字段aa2的值</li><br />
     * @return 创建结果.<br />
     *         格式说明 ：{ "success" : "false", "msg" : "返回信息", "resultCode" :
     *         "返回代码" }<br />
     *         <li>success: true:表示操作成功,false:表示操作失败</li><br />
     *         <li>msg:返回信息</li><br />
     *         <li>resultCode:OA的返回代码</li><br />
     */
    public String createWorkflow(String workflowInfo);

}
