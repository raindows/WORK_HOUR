package com.ssj.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.SecurityUtils;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

/**
 * 
* 类名称：登录过滤，权限验证
* 类描述： 
* @author 史硕俊
* 作者单位： 
* 联系方式：
* 创建时间：2015年11月2日
* @version 1.6
 */
public class LoginHandlerInterceptor extends HandlerInterceptorAdapter{

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

		String path = request.getServletPath();
		if(path.matches(".*/((login)|(logout)|(static)).*|(themes)")){
			return true;
		}
		if(!SecurityUtils.getSubject().isAuthenticated()){
			
			response.sendRedirect(request.getContextPath() + "/index.jsp");
			return false;
		}
				return true;
	}
	
}
