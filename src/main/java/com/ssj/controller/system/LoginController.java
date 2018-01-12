package com.ssj.controller.system;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.subject.Subject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.ssj.controller.base.BaseController;
import com.ssj.service.system.UserManger;
import com.ssj.util.PageData;

@Controller
public class LoginController extends BaseController{
	
	@Resource(name="userService")
	private UserManger userService;
	/**
	 * 请求登录，身份验证
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/login", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String login(){
		Map<String, String> map = new HashMap<String, String>();
		try
		{
			PageData pd = this.getPageData();
			String userName = pd.getString("e_userName");
			String password = pd.getString("password");
			PageData user = userService.findUserByUserName(pd);
			if(user != null){
				if(password.equals(user.getString("password"))){
					//判断员工是否离职
					if("在职".equals(user.getString("state"))){
						Subject subject = SecurityUtils.getSubject();
						subject.getSession().setAttribute("user", user);
						UsernamePasswordToken token = new UsernamePasswordToken(userName, password);
						try {
							subject.login(token);						
							map.put("target", "success");
							map.put("msg", "登录成功！");
						} catch (AuthenticationException e) {
							token.clear();
							map.put("target", "error");
							map.put("msg", "身份验证失败！");
						}
					}else{
						map.put("target", "error");
						map.put("msg", "非在职员工不可进入系统");
					}
				}else{
					map.put("target", "error");
					map.put("msg", "密码错误");
				}
			}else{
				map.put("target", "error");
				map.put("msg", "账号不存在！");
			}
					
		}catch(Exception ex){
			ex.printStackTrace();
			map.put("target", "error");
			map.put("msg", ex.getMessage());
		}
		return JSONObject.fromObject(map).toString();
	}
	
	
	//主页
	@RequestMapping("/system/main")
	public ModelAndView main(){
		ModelAndView mv = this.getModelAndView();
		mv.setViewName("system/main");
		return mv;
	}
	//主页
	@RequestMapping("/system/home")
	public ModelAndView home(){
		ModelAndView mv = this.getModelAndView();
		mv.setViewName("system/home");
		return mv;
	}
	
	//注销登陆
	@RequestMapping("/system/logout")
	public void mainLogout(HttpServletRequest  request,HttpServletResponse response) throws IOException{
		SecurityUtils.getSubject().logout();
		response.sendRedirect(request.getContextPath() + "/index.jsp");
	}
	
	//修改密码
	@RequestMapping("/system/change_pwd")
	@ResponseBody
	public String change_pwd(){
		Map<String, String> map = new HashMap<String, String>();
		try{
			PageData pd = this.getPageData();
			PageData user=(PageData) SecurityUtils.getSubject().getSession().getAttribute("user");
			if(user.getString("password").equals(pd.getString("old_pwd"))){//修改密码
				pd.put("EID", user.get("EID"));
				if(userService.changePwd(pd)){
					map.put("target", "success");
					map.put("msg", "密码修改成功！");
				}else{
					map.put("target", "error");
					map.put("msg", "未更新到记录");
				}
				
			}else{
				map.put("target", "error");
				map.put("msg", "旧密码匹配错误");
			}
		}catch(Exception ex){
			ex.printStackTrace();
			map.put("target", "error");
			map.put("msg", ex.getMessage());
		}
		return JSONObject.fromObject(map).toString();
	}
}
