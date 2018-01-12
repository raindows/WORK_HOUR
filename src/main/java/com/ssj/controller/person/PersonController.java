package com.ssj.controller.person;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.ssj.controller.base.BaseController;
import com.ssj.service.system.UserManger;
import com.ssj.util.PageData;

@Controller
public class PersonController extends BaseController{
	@Resource(name="userService")
	private UserManger userService;
	//所有人员档案
		@RequestMapping("/system/listAll")
		@ResponseBody()
		public String person(){
			Map<String, Object> map = new HashMap<String, Object>();
			try {
				PageData pd = this.getPageData();
				List<PageData> list = userService.listAll(pd);			
				map.put("total", list.size());
				map.put("rows", list);
			} catch (Exception e) {
				map.put("total", 0);
				map.put("rows", Collections.emptyList());
			}		
			return JSONObject.fromObject(map).toString();
		}
		
		//用户档案编辑页面
		@RequestMapping("/system/person_edit")
		public ModelAndView person_edit(){
			ModelAndView mv = this.getModelAndView();
			mv.setViewName("system/person_edit");
			return mv;
		}
		
		//添加人员档案
		@RequestMapping("/system/person_add")
		@ResponseBody()
		public String add_person(){
			PageData pd = this.getPageData();
			Map<String, Object> map = new HashMap<String, Object>();
			try {
				if(StringUtils.isNotBlank(pd.getString("EID")))//update
				{
					if(userService.updateUser(pd)){
						map.put("target", "success");
						map.put("msg",pd);
					}else{
						map.put("target", "error");
						map.put("msg","该记录已经被删除，无法更新");
					}
				}else{//新增
					if(userService.findUserByUserName(pd) != null){//用户已存在
						map.put("target", "error");
						map.put("msg","用户名已存在");
					}else {
						if(userService.addUser(pd)){					
							map.put("target", "success");
							map.put("msg",pd);
						}else{
							map.put("target", "error");
							map.put("msg","影响行数为0,请联系管理员");
						}
					}
					
				}
				
			} catch (Exception e) {
				map.put("target", "error");
				map.put("msg","异常："+e.getMessage());
			}		
			return JSONObject.fromObject(map).toString();
		}
		
		//删除人员档案
		@RequestMapping("/system/person_delete")
		@ResponseBody()
		public String delete_person(){
			PageData pd = this.getPageData();
			Map<String, Object> map = new HashMap<String, Object>();
			try {
				userService.deleteUser(pd);		
				map.put("target", "success");
				map.put("msg","删除成功");
			} catch (Exception e) {
				map.put("target", "error");
				map.put("msg","异常："+e.getMessage());
			}		
			return JSONObject.fromObject(map).toString();
		}
		
		//密码重置
		@RequestMapping("/system/person_repwd")
		@ResponseBody()
		public String person_repwd(){
			PageData pd = this.getPageData();
			Map<String, Object> map = new HashMap<String, Object>();
			try {
				if(userService.resetPwd(pd)){	
					map.put("target", "success");
					map.put("msg","重置成功");
				}else{
					map.put("target", "error");
					map.put("msg","重置失败，记录可能已经被删除");
				}	
			} catch (Exception e) {
				map.put("target", "error");
				map.put("msg","异常："+e.getMessage());
			}		
			return JSONObject.fromObject(map).toString();
		}		
		//用户档案管理页面
		@RequestMapping("/system/person")
		public ModelAndView listAll(){
			ModelAndView mv = this.getModelAndView();
			mv.setViewName("system/person");
			return mv;
		}
}
