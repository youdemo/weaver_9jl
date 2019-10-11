package com.engine.demo.test.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;

import com.api.browser.bean.SearchConditionGroup;
import com.api.browser.bean.SearchConditionItem;
import com.api.browser.bean.SearchConditionOption;
import com.api.browser.util.ConditionFactory;
import com.api.browser.util.ConditionType;
import com.cloudstore.eccom.constant.WeaBoolAttr;
import com.cloudstore.eccom.pc.table.WeaTable;
import com.cloudstore.eccom.pc.table.WeaTableColumn;
import com.cloudstore.eccom.result.WeaResultMsg;

import weaver.general.PageIdConst;
import weaver.general.Util;
import weaver.hrm.HrmUserVarify;
import weaver.hrm.User;

public class DemoActionImplTest {
	public Map<String, Object> getCondition(User user,Map<String, Object> params) {

        Map<String, Object> apidatas = new HashMap<String, Object>();
        if(!HrmUserVarify.checkUserRight("LogView:View", user)){
            apidatas.put("hasRight", false);
            return apidatas;
        }

        apidatas.put("hasRight", true);

        ConditionFactory conditionFactory = new ConditionFactory(user);

        //条件组
        List<SearchConditionGroup> addGroups = new ArrayList<SearchConditionGroup>();

        List<SearchConditionItem> conditionItems = new ArrayList<SearchConditionItem>();

        //文本输入框
        SearchConditionItem workcode = conditionFactory.createCondition(ConditionType.INPUT,502327, "workcode");
        workcode.setColSpan(2);//定义一行显示条件数，默认值为2,当值为1时标识该条件单独占一行
        workcode.setFieldcol(16);	//条件输入框所占宽度，默认值18
        workcode.setLabelcol(8);
        workcode.setViewAttr(2);  //	 编辑权限  1：只读，2：可编辑， 3：必填   默认2
        workcode.setLabel("工号"); //设置文本值  这个将覆盖多语言标签的值
        //workcode.setRules("required");
        workcode.setRules("required");
       // workcode.setIsQuickSearch(true);
        conditionItems.add(workcode);


        //文本输入框
        SearchConditionItem ry = conditionFactory.createCondition(ConditionType.BROWSER,502327, "ry","17");
        ry.setColSpan(2);//定义一行显示条件数，默认值为2,当值为1时标识该条件单独占一行
        ry.setFieldcol(16);	//条件输入框所占宽度，默认值18
        ry.setLabelcol(8);
        ry.setViewAttr(2);  //	 编辑权限  1：只读，2：可编辑， 3：必填   默认2
        ry.setLabel("人员"); //设置文本值  这个将覆盖多语言标签的值
        conditionItems.add(ry);

        //下拉选择框类
        SearchConditionItem sex = conditionFactory.createCondition(ConditionType.SELECT,502327,"sex");
        List<SearchConditionOption> selectOptions = new ArrayList <>();  //设置选项值
        selectOptions.add(new SearchConditionOption("","",true));
        selectOptions.add(new SearchConditionOption("0","男"));
        selectOptions.add(new SearchConditionOption("1","女"));
        sex.setOptions(selectOptions);
        sex.setColSpan(2);
        sex.setFieldcol(16);
        sex.setLabelcol(8);
        sex.setLabel("性别");
        conditionItems.add(sex);

        //下拉选择框类
        SearchConditionItem bm = conditionFactory.createCondition(ConditionType.BROWSER,502327, "bm","4");
        bm.setColSpan(2);//定义一行显示条件数，默认值为2,当值为1时标识该条件单独占一行
        bm.setFieldcol(16);	//条件输入框所占宽度，默认值18
        bm.setLabelcol(8);
        bm.setViewAttr(2);  //	 编辑权限  1：只读，2：可编辑， 3：必填   默认2
        bm.setLabel("部门"); //设置文本值  这个将覆盖多语言标签的值
        conditionItems.add(bm);
        
        SearchConditionItem fb = conditionFactory.createCondition(ConditionType.BROWSER,502327, "fb","164");
        fb.setColSpan(2);//定义一行显示条件数，默认值为2,当值为1时标识该条件单独占一行
        fb.setFieldcol(16);	//条件输入框所占宽度，默认值18
        fb.setLabelcol(8);
        fb.setViewAttr(2);  //	 编辑权限  1：只读，2：可编辑， 3：必填   默认2
        fb.setLabel("分部"); //设置文本值  这个将覆盖多语言标签的值
        conditionItems.add(fb);

        addGroups.add(new SearchConditionGroup("",true,conditionItems));

        apidatas.put("condition",addGroups);

        return apidatas;

    }
	
	 public Map<String, Object> getTables(User user,Map<String, Object> params) {
	        Map<String, Object> apidatas = new HashMap<String, Object>();
	        if(!HrmUserVarify.checkUserRight("LogView:View", user)){
	            apidatas.put("hasRight", false);
	            return apidatas;
	        }

	        try {
	            //返回消息结构体
	            WeaResultMsg result = new WeaResultMsg(false);

	            String pageID = "0d4f39a5-804d-4578-8a73-aad48490f658";
	            String pageUid = pageID + "_" + user.getUID();
	            String pageSize = PageIdConst.getPageSize(pageID, user.getUID());
	            String sqlwhere = " 1=1 ";

	            //新建一个weatable
	            WeaTable table = new WeaTable();
	            table.setPageUID(pageUid);
	            table.setPageID(pageID);
	            table.setPagesize(pageSize);

	            String fileds = " lastname,sex,workcode,departmentid,subcompanyid1,(select subcompanyname from hrmsubcompany where id=a.subcompanyid1)  as subcompanyname";
	            table.setBackfields(fileds);

	            //搜索条件,这里可以放高级搜索的的条件
	            String workcode =  Util.null2String(params.get("workcode"));
	            if (StringUtils.isNotBlank(workcode)) {
	                sqlwhere += " and workcode like '%" + workcode + "%' ";
	            }

	            //创建人
	            String ry =  Util.null2String(params.get("ry"));
	            if (StringUtils.isNotBlank(ry)) {
	                sqlwhere += " and id='"+ry+"' ";
	            }

	            //性别
	            String sex =  Util.null2String(params.get("sex"));
	            if (StringUtils.isNotBlank(sex)) {
	                sqlwhere += " and sex = '" + sex + "' ";
	            }

	            //类型
	            String bm =  Util.null2String(params.get("bm"));
	            if (StringUtils.isNotBlank(bm) ) {
	                sqlwhere += " and departmentid = '" + bm + "' ";
	            }

	            String fb =  Util.null2String(params.get("fb"));
	            if(StringUtils.isNotBlank(fb)){
	            	sqlwhere += " and subcompanyid1 = '" + fb + "' ";
	            }

	            table.setSqlform(" hrmresource a ");
	            table.setSqlwhere(sqlwhere);
	            table.setSqlorderby("id");
	            table.setSqlprimarykey("id");
	            table.setSqlisdistinct("false");
	            table.getColumns().add(new WeaTableColumn("id").setDisplay(WeaBoolAttr.FALSE));   //设置为不显示
	            table.getColumns().add(new WeaTableColumn("20%", "姓名", "lastname","lastment"));
	            table.getColumns().add(new WeaTableColumn("20%", "性别", "sex","sex","com.engine.demo.test.cmd.WeaTableTransMethod.getSex"));
	            table.getColumns().add(new WeaTableColumn("20%", "工号", "workcode","workcode"));
	            table.getColumns().add(new WeaTableColumn("20%", "部门", "departmentid","departmentid","weaver.hrm.company.DepartmentComInfo.getDepartmentname"));
	            table.getColumns().add(new WeaTableColumn("20%", "分部", "subcompanyname","subcompanyname"));

	            //设置左侧check默认不存在
	            table.setCheckboxList(null);
	            table.setCheckboxpopedom(null);

	            result.putAll(table.makeDataResult());
	            result.put("hasRight", true);
	            result.success();
	            apidatas = result.getResultMap();

	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	        return apidatas;
	    }
}
