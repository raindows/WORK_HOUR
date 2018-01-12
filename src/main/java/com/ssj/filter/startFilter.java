package com.ssj.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;

import com.ssj.controller.base.BaseController;
import com.ssj.util.QuartzManager;

/**
 * 启动tomcat时运行此类
 * 创建人： 史硕俊
 * 创建时间：2016年2月17日
 * @version
 */
public class startFilter extends BaseController implements Filter{
	
	/**
	 * 初始化
	 */
	public void init(FilterConfig fc) throws ServletException {
		
	}
	
	
	public void destroy() {
		QuartzManager.shutdownJobs();
	}
	
	public void doFilter(ServletRequest arg0, ServletResponse arg1,
			FilterChain arg2) throws IOException, ServletException {
		
	}
	
}
