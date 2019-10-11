package com.engine.demo.test.service.impl;

import java.util.Map;

import com.engine.core.impl.Service;
import com.engine.demo.test.cmd.WeaTableDemoCmd;
import com.engine.demo.test.cmd.WeatableConditonDemoCmd;
import com.engine.demo.test.service.DemoServiceTest;

/*
 * @Author      :wyl
 * @Date        :2019/4/19  11:47
 * @Version 1.0 :
 * @Description :
 **/
public class DemoServiceImplTest extends Service implements DemoServiceTest {

    @Override
    public Map<String, Object> weatableDemo(Map<String, Object> params) {
        return commandExecutor.execute(new WeaTableDemoCmd(user,params));
    }

    @Override
    public Map<String, Object> weatableConditonDemo(Map<String, Object> params) {
        return commandExecutor.execute(new WeatableConditonDemoCmd(user,params));
    }
}
