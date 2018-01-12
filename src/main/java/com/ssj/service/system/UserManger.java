package com.ssj.service.system;

import java.util.List;

import com.ssj.util.PageData;

public interface UserManger {
	//查找人员信息，根据用户名
	public PageData findUserByUserName(PageData pd) throws Exception ;
	//加载所有用户
	public List<PageData> listAll(PageData pd) throws Exception ;
	//添加用户档案信息
	public boolean addUser(PageData pd) throws Exception ;	
	//更新用户档案信息
	public boolean updateUser(PageData pd) throws Exception ;
	//删除人员档案
	public void deleteUser(PageData pd) throws Exception ;
	//重置密码
	public boolean resetPwd(PageData pd) throws Exception ;
	//修改密码
	public boolean changePwd(PageData pd) throws Exception ;
	
}
