package com.ssj.controller.project;

import java.sql.Date;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.ssj.controller.base.BaseController;
import com.ssj.service.project.ProjectManager;
import com.ssj.util.JsonDateValueProcessor;
import com.ssj.util.PageData;

@Controller
public class ProjectManangerController extends BaseController{
	@Resource(name="projectService")
	private ProjectManager projectService;
	//所有项目档案
		@RequestMapping("/project/listAll")
		@ResponseBody()
		public String project(){
			Map<String, Object> map = new HashMap<String, Object>();
			try {
				PageData pd = this.getPageData();
				List<PageData> list = projectService.listAll(pd);			
				map.put("total", list.size());
				map.put("rows", list);
			} catch (Exception e) {
				map.put("total", 0);
				map.put("rows", Collections.emptyList());
			}		
			JsonConfig jConfig = new JsonConfig();
			jConfig.registerJsonValueProcessor(Date.class, new JsonDateValueProcessor("yyyy-MM-dd"));
			return JSONObject.fromObject(map,jConfig).toString();
		}
		
		//项目档案编辑页面
		@RequestMapping("/project/project_edit")
		public ModelAndView project_edit(){
			ModelAndView mv = this.getModelAndView();
			mv.setViewName("project/project_edit");
			return mv;
		}
		
		//添加项目档案
		@RequestMapping("/project/project_add")
		@ResponseBody()
		public String add_project(){
			PageData pd = this.getPageData();
			Map<String, Object> map = new HashMap<String, Object>();
			try {
				if(StringUtils.isNotBlank(pd.getString("PID")))//update
				{
					if(projectService.updateProject(pd)){
						map.put("target", "success");
						map.put("msg",pd);
					}else{
						map.put("target", "error");
						map.put("msg","该记录已经被删除，无法更新");
					}
				}else{//新增
					if(projectService.findProjectByNameAndType(pd).size() >0){//项目已存在
						map.put("target", "error");
						map.put("msg","项目名已存在");
					}else {
						if(projectService.addProject(pd)){					
							map.put("target", "success");
							map.put("msg",pd);
						}else{
							map.put("target", "error");
							map.put("msg","影响行数为0,请联系管理员");
						}
					}
					
				}
				
			} catch (Exception e) {
				e.printStackTrace();
				map.put("target", "error");
				map.put("msg","异常："+e.getMessage());
			}		
			return JSONObject.fromObject(map).toString();
		}
		
		//删除项目档案
		@RequestMapping("/project/project_delete")
		@ResponseBody()
		public String delete_project(){
			PageData pd = this.getPageData();
			Map<String, Object> map = new HashMap<String, Object>();
			try {
				projectService.deleteProject(pd);		
				map.put("target", "success");
				map.put("msg","删除成功");
			} catch (Exception e) {
				map.put("target", "error");
				map.put("msg","异常："+e.getMessage());
			}		
			return JSONObject.fromObject(map).toString();
		}		
		
		//项目档案管理页面
		@RequestMapping("/project/project")
		public ModelAndView listAll(){
			ModelAndView mv = this.getModelAndView();
			mv.setViewName("system/project");
			return mv;
		}
}

