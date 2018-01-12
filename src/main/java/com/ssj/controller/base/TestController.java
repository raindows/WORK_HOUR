package com.ssj.controller.base;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.ssj.entity.Page;
import com.ssj.util.PageData;

@RestController
public class TestController extends BaseController{

	@RequestMapping("/testGrid")
	public Map<String,Object> testGrid(Page page){
		PageData pd = this.getPageData();
		//第几页
		System.out.println("======第几页====="+pd.get("page"));
		//每页记录数
		System.out.println("======每页记录数====="+pd.get("rows"));		
		List<Map<String,String>> list = new ArrayList<Map<String,String>>();
		for(int i = 0 ; i < 50;i++){
		Map<String,String> map = new HashMap<String, String>();
		map.put("itemid", pd.get("page")+"_00"+i);
		map.put("productid", "FI-SW-0"+i);
		map.put("listprice", "1000$");
		list.add(map);
		}
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("total", 100);
		map.put("rows", list);
		return map;
	}
	@RequestMapping("/index")
	public ModelAndView testPage(){
		ModelAndView md = new ModelAndView();
		md.setViewName("/system/main");
		return md;
	}
	
	@RequestMapping("/demo1")
	public ModelAndView demo1(){
		ModelAndView md = new ModelAndView();
		md.setViewName("/demo/demo1");
		return md;
	}
}
