package com.ssj.controller.project;

import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;

import org.apache.commons.lang.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.Subject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.ssj.controller.base.BaseController;
import com.ssj.service.task.TaskManager;
import com.ssj.util.JsonDateValueProcessor;
import com.ssj.util.PageData;

@Controller
public class TaskController extends BaseController{

	@Resource(name="taskService")
	TaskManager taskService;
	//进入下达任务页面
	@RequestMapping("/task/to_task_add")
	public ModelAndView toTaskAdd(){
		ModelAndView mv = this.getModelAndView();
		mv.setViewName("task/task_add");
		return mv;
	}
	
	//添加任务
	@RequestMapping("/task/task_add")
	@ResponseBody
	public String addTask(){
		PageData pd = this.getPageData();
		Map<String, Object> map = new HashMap<String, Object>();
		try{
			if(StringUtils.isNotBlank(pd.getString("PTID")))//update
			{
				if(taskService.updateTask(pd)){
					map.put("target", "success");
					map.put("msg",pd);
				}else{
					map.put("target", "error");
					map.put("msg","该记录已经被删除，无法更新");
				}
			}else{
				Subject subject = SecurityUtils.getSubject();
				PageData user = (PageData) subject.getSession().getAttribute("user");
				pd.put("TASK_CREATE_PERSON", user.get("e_name"));
				if(taskService.addTask(pd)){						
					map.put("target", "success");
					map.put("msg",pd);
				}else{
					map.put("target", "error");
					map.put("msg","影响行数为0,请联系管理员");
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			map.put("target", "error");
			map.put("msg","异常："+e.getMessage());
		}	
		JsonConfig jConfig = new JsonConfig();
		jConfig.registerJsonValueProcessor(Date.class, new JsonDateValueProcessor("yyyy-MM-dd"));
		return JSONObject.fromObject(map,jConfig).toString();
	}
	
	//加载我下达的任务
	@RequestMapping("/task/loadMyCreateTask")
	@ResponseBody
	public String loadMyCreateTask(){
		PageData pd = this.getPageData();		
		Map<String, Object> map = new HashMap<String, Object>();
		try{
			Subject subject = SecurityUtils.getSubject();
			PageData user = (PageData) subject.getSession().getAttribute("user");
			pd.put("TASK_CREATE_PERSON", user.get("e_name"));
			List<PageData> list= taskService.loadMyCreateTask(pd);					
			map.put("total", list.size());
			map.put("rows", list);
		} catch (Exception e) {
			e.printStackTrace();
			map.put("total", 0);
			map.put("rows", Collections.emptyList());
		}	
		JsonConfig jConfig = new JsonConfig();
		jConfig.registerJsonValueProcessor(Date.class, new JsonDateValueProcessor("yyyy-MM-dd"));
		return JSONObject.fromObject(map,jConfig).toString();
	}
	
	//加载我下达的任务
	@RequestMapping("/task/loadMyTask")
	@ResponseBody
	public String loadMyTask(){
		PageData pd = this.getPageData();		
		Map<String, Object> map = new HashMap<String, Object>();
		try{
			Subject subject = SecurityUtils.getSubject();
			PageData user = (PageData) subject.getSession().getAttribute("user");
			pd.put("PERSON_LIABLE", user.get("e_name"));
			List<PageData> list= taskService.loadMyTask(pd);					
			map.put("total", list.size());
			map.put("rows", list);
		} catch (Exception e) {
			e.printStackTrace();
			map.put("total", 0);
			map.put("rows", Collections.emptyList());
		}	
			JsonConfig jConfig = new JsonConfig();
			jConfig.registerJsonValueProcessor(Date.class, new JsonDateValueProcessor("yyyy-MM-dd"));
			return JSONObject.fromObject(map,jConfig).toString();
		}
	//进入我的任务
	@RequestMapping("/task/to_loadMyTask")
	public ModelAndView toLoadMyTask(){
		ModelAndView mv = this.getModelAndView();
		mv.setViewName("task/loadMyTask");
		return mv;
	}
	//完成任务提交
	@RequestMapping("/task/task_submitTask")
	@ResponseBody
	public String task_submitTask(){
		PageData pd = this.getPageData();		
		Map<String, Object> map = new HashMap<String, Object>();
		try{			
			if(taskService.submitTask(pd)){
				map.put("target", "success");
				map.put("msg","任务提交成功");
			}else{
				map.put("target", "error");
				map.put("msg","影响行数为0,请联系管理员");
			}
		} catch (Exception e) {
			map.put("target", "error");
			map.put("msg","影响行数为0,请联系管理员");
		}	
		JsonConfig jConfig = new JsonConfig();
		jConfig.registerJsonValueProcessor(Date.class, new JsonDateValueProcessor("yyyy-MM-dd"));
		return JSONObject.fromObject(map,jConfig).toString();
	}
	
	//进入任务关闭页面
	@RequestMapping("/task/to_closeTask")
	public ModelAndView toCloseTask(){
		ModelAndView mv = this.getModelAndView();
		mv.setViewName("task/toCloseTask");
		return mv;
	}
	@RequestMapping("/task/loadCompleteAndNeedMyCloseTask")
	@ResponseBody
	public String loadCompleteAndNeedMyCloseTask(){
		PageData pd = this.getPageData();		
		Map<String, Object> map = new HashMap<String, Object>();
		try{
			Subject subject = SecurityUtils.getSubject();
			PageData user = (PageData) subject.getSession().getAttribute("user");
			pd.put("TASK_CREATE_PERSON", user.get("e_name"));
			List<PageData> list= taskService.loadCompleteAndNeedMyCloseTask(pd);					
			map.put("total", list.size());
			map.put("rows", list);
		} catch (Exception e) {
			e.printStackTrace();
			map.put("total", 0);
			map.put("rows", Collections.emptyList());
		}	
		JsonConfig jConfig = new JsonConfig();
		jConfig.registerJsonValueProcessor(Date.class, new JsonDateValueProcessor("yyyy-MM-dd"));
		return JSONObject.fromObject(map,jConfig).toString();
	}
	
	//关闭任务
	@RequestMapping("/task/task_closeTask")
	@ResponseBody
	public String task_closeTask(){
		PageData pd = this.getPageData();		
		Map<String, Object> map = new HashMap<String, Object>();
		try{	
			String[] PTIDS = pd.getString("PTIDS").split(",");
			pd.put("PTIDS", PTIDS);
			if(taskService.closeTask(pd)){
				map.put("target", "success");
				map.put("msg","任务关闭成功");
			}else{
				map.put("target", "error");
				map.put("msg","影响行数为0,请联系管理员");
			}
		} catch (Exception e) {
			e.printStackTrace();
			map.put("target", "error");
			map.put("msg","影响行数为0,请联系管理员");
		}	
		JsonConfig jConfig = new JsonConfig();
		jConfig.registerJsonValueProcessor(Date.class, new JsonDateValueProcessor("yyyy-MM-dd"));
		return JSONObject.fromObject(map,jConfig).toString();
	}
	
	//任务退回重做
	@RequestMapping("/task/task_redoTask")
	@ResponseBody
	public String task_redoTask(){
		PageData pd = this.getPageData();		
		Map<String, Object> map = new HashMap<String, Object>();
		try{	
			String[] PTIDS = pd.getString("PTIDS").split(",");
			pd.put("PTIDS", PTIDS);
			if(taskService.redoTask(pd)){
				map.put("target", "success");
				map.put("msg","任务退回成功");
			}else{
				map.put("target", "error");
				map.put("msg","影响行数为0,请联系管理员");
			}
		} catch (Exception e) {
			e.printStackTrace();
			map.put("target", "error");
			map.put("msg","影响行数为0,请联系管理员");
		}	
		JsonConfig jConfig = new JsonConfig();
		jConfig.registerJsonValueProcessor(Date.class, new JsonDateValueProcessor("yyyy-MM-dd"));
		return JSONObject.fromObject(map,jConfig).toString();
	}
	
	//关闭所有任务
	@RequestMapping("/task/task_closeAllTask")
	@ResponseBody
	public String task_closeAllTask(){
	PageData pd = this.getPageData();		
	Map<String, Object> map = new HashMap<String, Object>();
	try{	
		Subject subject = SecurityUtils.getSubject();
		PageData user = (PageData) subject.getSession().getAttribute("user");
		pd.put("TASK_CREATE_PERSON", user.get("e_name"));
		if(taskService.closeAllTask(pd)){
			map.put("target", "success");
			map.put("msg","任务关闭成功");
		}else{
			map.put("target", "error");
			map.put("msg","影响行数为0,请联系管理员");
		}
	} catch (Exception e) {
		e.printStackTrace();
		map.put("target", "error");
		map.put("msg","影响行数为0,请联系管理员");
	}	
	JsonConfig jConfig = new JsonConfig();
	jConfig.registerJsonValueProcessor(Date.class, new JsonDateValueProcessor("yyyy-MM-dd"));
	return JSONObject.fromObject(map,jConfig).toString();
	}
	
	//加载我下达的任务
	@RequestMapping("/task/myCurrentMothCloseTask")
	@ResponseBody
	public String myCurrentMothCloseTask(){
		PageData pd = this.getPageData();		
		Map<String, Object> map = new HashMap<String, Object>();
		try{
			Subject subject = SecurityUtils.getSubject();
			PageData user = (PageData) subject.getSession().getAttribute("user");
			pd.put("PERSON_LIABLE", user.get("e_name"));
			//当月第一天和最后一天
			SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd"); 
			String firstday, lastday;
			// 获取前月的第一天
			Calendar  cale = Calendar.getInstance();  			
		    cale.add(Calendar.MONTH, 0);  
		    cale.set(Calendar.DAY_OF_MONTH, 1);  
		    firstday = format.format(cale.getTime());
		    // 获取前月的最后一天  
	        cale = Calendar.getInstance();  
	        cale.add(Calendar.MONTH, 1);  
	        cale.set(Calendar.DAY_OF_MONTH, 0);  
	        lastday = format.format(cale.getTime()); 
	        pd.put("START_TIME", firstday);
	        pd.put("END_TIME", lastday);
			List<PageData> list= taskService.myCurrentMothCloseTask(pd);					
			map.put("total", list.size());
			map.put("rows", list);
			} catch (Exception e) {
				e.printStackTrace();
				map.put("total", 0);
				map.put("rows", Collections.emptyList());
			}	
			JsonConfig jConfig = new JsonConfig();
			jConfig.registerJsonValueProcessor(Date.class, new JsonDateValueProcessor("yyyy-MM-dd"));
			return JSONObject.fromObject(map,jConfig).toString();
		}	
	
		//首页统计图
		@RequestMapping("/task/home_sum")
		@ResponseBody
		public String home_sum(){
			PageData pd = this.getPageData();		
			Map<String, Object> map = new HashMap<String, Object>();
			try{
				Subject subject = SecurityUtils.getSubject();
				PageData user = (PageData) subject.getSession().getAttribute("user");
				pd.put("PERSON_LIABLE", user.get("e_name"));
				//当月第一天和最后一天
				SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd"); 
				String firstday, lastday;
				// 获取前月的第一天
				Calendar  cale = Calendar.getInstance();  			
			    cale.add(Calendar.MONTH, 0);  
			    cale.set(Calendar.DAY_OF_MONTH, 1);  
			    firstday = format.format(cale.getTime());
			    // 获取前月的最后一天  
		        cale = Calendar.getInstance();  
		        cale.add(Calendar.MONTH, 1);  
		        cale.set(Calendar.DAY_OF_MONTH, 0);  
		        lastday = format.format(cale.getTime()); 
		        pd.put("START_TIME", firstday);
		        pd.put("END_TIME", lastday);
				List<PageData> complete_list= taskService.myCurrentMothComplete(pd);		
				//已完成数
				Double hasComplete=0d,sumTask=0d;
				for(int i =0;i<complete_list.size();i++){
					PageData temp = complete_list.get(i);
					sumTask += Double.parseDouble(temp.get("WORK_HOUR").toString());
					if("已关闭".equals(temp.getString("TASK_STATE"))){
						hasComplete += Double.parseDouble(temp.get("WORK_HOUR").toString());
					}
				}
				map.put("hasComplete", hasComplete);
				map.put("noComplete", sumTask-hasComplete);
				
				//核算本年度每月关闭工时
				List<PageData> veryMonth_list= taskService.myCurrentYearMothWorkHour(pd);
				//默认每个月为0
				for(int i =1 ; i <=12 ; i ++){
					if(i < 10){
						map.put("M_0"+ i, 0);
					}else{
						map.put("M_"+ i, 0);
					}
				}
				//分析统计数据
				for(int i =0; i < veryMonth_list.size();i++){
					PageData temp = veryMonth_list.get(i);
					map.put("M_"+temp.get("MONTH_"), temp.get("WORK_HOUR"));
				}
				map.put("target", "success");
				} catch (Exception e) {
					e.printStackTrace();
					map.put("target", "error");
				}	
				JsonConfig jConfig = new JsonConfig();
				jConfig.registerJsonValueProcessor(Date.class, new JsonDateValueProcessor("yyyy-MM-dd"));
				return JSONObject.fromObject(map,jConfig).toString();
		}
	
		//统计月工时
	@RequestMapping("/task/task_monthHour")
	@ResponseBody
	public String monthHour(){
		PageData pd = this.getPageData();		
		Map<String, Object> map = new HashMap<String, Object>();
		try{
				if(StringUtils.isBlank(pd.getString("START_TIME"))){
					map.put("total", 0);
					map.put("rows", Collections.emptyList());
				}else{
					List<PageData> list= taskService.monthHour(pd);					
					map.put("total", list.size());
					map.put("rows", list);
				}
			
			} catch (Exception e) {
				e.printStackTrace();
				map.put("total", 0);
				map.put("rows", Collections.emptyList());
			}	
			JsonConfig jConfig = new JsonConfig();
			jConfig.registerJsonValueProcessor(Date.class, new JsonDateValueProcessor("yyyy-MM-dd"));
			return JSONObject.fromObject(map,jConfig).toString();
	}
	@RequestMapping("/task/task_monthHour_detail")
	@ResponseBody
	public String task_monthHour_detail(){
		PageData pd = this.getPageData();		
		Map<String, Object> map = new HashMap<String, Object>();
		try{
				if(StringUtils.isBlank(pd.getString("START_TIME"))){
					map.put("total", 0);
					map.put("rows", Collections.emptyList());
				}else{
					List<PageData> list= taskService.monthHourDetail(pd);					
					map.put("total", list.size());
					map.put("rows", list);
				}
			
			} catch (Exception e) {
				e.printStackTrace();
				map.put("total", 0);
				map.put("rows", Collections.emptyList());
			}	
			JsonConfig jConfig = new JsonConfig();
			jConfig.registerJsonValueProcessor(Date.class, new JsonDateValueProcessor("yyyy-MM-dd"));
			return JSONObject.fromObject(map,jConfig).toString();
	}
	//进入月工时统计表页面
	@RequestMapping("/task/task_to_mothHour")
	public ModelAndView toMonthHour(){
		ModelAndView mv =new ModelAndView("task/monthHour");
		//当月第一天和最后一天
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd"); 
		String firstday, lastday;
		// 获取前月的第一天
		Calendar  cale = Calendar.getInstance();  			
	    cale.add(Calendar.MONTH, 0);  
	    cale.set(Calendar.DAY_OF_MONTH, 1);  
	    firstday = format.format(cale.getTime());
	    // 获取前月的最后一天  
        cale = Calendar.getInstance();  
        cale.add(Calendar.MONTH, 1);  
        cale.set(Calendar.DAY_OF_MONTH, 0);  
        lastday = format.format(cale.getTime()); 
        mv.addObject("START_TIME", firstday);
        mv.addObject("END_TIME", lastday);
		return mv;
	}
}
