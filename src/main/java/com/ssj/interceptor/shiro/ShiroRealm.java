package com.ssj.interceptor.shiro;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.AuthenticationInfo;
import org.apache.shiro.authc.AuthenticationToken;
import org.apache.shiro.authc.SimpleAuthenticationInfo;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.authz.AuthorizationInfo;
import org.apache.shiro.authz.SimpleAuthorizationInfo;
import org.apache.shiro.cache.Cache;
import org.apache.shiro.realm.AuthorizingRealm;
import org.apache.shiro.subject.PrincipalCollection;
import org.apache.shiro.subject.Subject;

/**
 * @author fh 2015-3-6
 */
public class ShiroRealm extends AuthorizingRealm {

	/*
	 * 登录信息和用户信息验证 在这里返回当前某个用户的简单信息的一个对象，后续会对其进行权限关联	 * 
	 */
	@Override
	protected AuthenticationInfo doGetAuthenticationInfo(AuthenticationToken token) throws AuthenticationException {
		UsernamePasswordToken authcToken = (UsernamePasswordToken) token;	
		
		SimpleAuthenticationInfo smp = new SimpleAuthenticationInfo(
				authcToken.getUsername(), authcToken.getPassword(), getName());
		return smp;
	}

	// 清除缓存
	public void clearAllCachedAuthorizationInfo() {
		Cache<Object, AuthorizationInfo> cache = getAuthorizationCache();
		if (cache != null) {
			for (Object key : cache.keys()) {
				System.out.println(key + "====================");
				cache.remove(key);
			}
		}
	}

	/*
	 * 授权函数
	 * */
	@Override
	protected AuthorizationInfo doGetAuthorizationInfo(PrincipalCollection pc) {		
		Subject curUser = SecurityUtils.getSubject();		
		SimpleAuthorizationInfo info=null;		
		// 先看权限信息是否加载过了
		if (curUser.getSession().getAttribute("AuthorizationInfo") == null) {			
//			WebApplicationContext webctx = ContextLoader.getCurrentWebApplicationContext();		
				info = new SimpleAuthorizationInfo();
				curUser.getSession().setAttribute("AuthorizationInfo", info);
		} else {
			info = (SimpleAuthorizationInfo) curUser.getSession().getAttribute(	"AuthorizationInfo");
		}
		return info;
	}
	
	@Override
	public String getName() {
		return getClass().getName();
	}
}
