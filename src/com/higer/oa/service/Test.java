package com.higer.oa.service;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import ln.TimeUtil;

public class Test {

	public static void main(String[] args) {
		List<Map<String,String>> list = new ArrayList<Map<String,String>>();
		Map<String,String> map = new HashMap<String,String>();
		map.put("aa","123");
		list.add(map);
		for(Map<String,String> map1:list) {
			deal(map1);
		}
		System.out.println(list.get(0).toString());

	}
	
	public static void deal(Map<String,String> map1) {
		map1.put("aaac","ccc");
	}

}
