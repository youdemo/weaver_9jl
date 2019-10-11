package com.engine.demo.test.service;

import java.util.Map;

public interface DemoServiceTest {
    /**
     * 获取form表单
     * @param params
     * @return
     */
    Map<String, Object> weatableDemo(Map<String, Object> params);

    /**
     * 获取高级搜索条件
     * @param params
     * @return
     */
    Map<String,Object> weatableConditonDemo(Map<String, Object> params);
}
