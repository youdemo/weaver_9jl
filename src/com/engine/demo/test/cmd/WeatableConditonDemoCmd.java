package com.engine.demo.test.cmd;

import com.api.browser.bean.SearchConditionGroup;
import com.api.browser.bean.SearchConditionItem;
import com.api.browser.bean.SearchConditionOption;
import com.api.browser.util.ConditionFactory;
import com.api.browser.util.ConditionType;
import com.engine.common.biz.AbstractCommonCommand;
import com.engine.common.entity.BizLogContext;
import com.engine.core.interceptor.CommandContext;
import weaver.hrm.HrmUserVarify;
import weaver.hrm.User;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/*
 * @Author      :wyl
 * @Date        :2019/4/11  9:46
 * @Version 1.0
 * @Description :获取高级搜索条件
 **/
public class WeatableConditonDemoCmd extends AbstractCommonCommand<Map<String,Object>> {

    public WeatableConditonDemoCmd(User user, Map<String,Object> params) {
        this.user = user;
        this.params = params;
    }

    @Override
    public BizLogContext getLogContext() {
        return null;
    }

    @Override
    public Map<String, Object> execute(CommandContext commandContext) {

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
}
