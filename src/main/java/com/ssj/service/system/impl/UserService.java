package com.ssj.service.system.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.ssj.dao.DaoSupport;
import com.ssj.service.system.UserManger;
import com.ssj.util.PageData;

@Service("userService")
public class UserService implements UserManger {
	
	@Resource(name = "daoSupport")
	private DaoSupport dao;
	
	@Override
	public PageData findUserByUserName(PageData pd) throws Exception {		
		return (PageData)dao.findForObject("UserMapper.findUserByUserName", pd);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<PageData> listAll(PageData pd) throws Exception {		
		return (List<PageData>)dao.findForList("UserMapper.listAll", pd);
	}

	@Override
	public boolean addUser(PageData pd) throws Exception {
		return  dao.save("UserMapper.save", pd) == 1;
	}

	@Override
	public boolean updateUser(PageData pd) throws Exception {
		return  dao.update("UserMapper.update", pd) >= 1;
	}

	@Override
	public void deleteUser(PageData pd) throws Exception {
		dao.delete("UserMapper.delete", pd);
		
	}

	@Override
	public boolean resetPwd(PageData pd) throws Exception {
		return  dao.update("UserMapper.resetpwd", pd) >= 1;
	}

	@Override
	public boolean changePwd(PageData pd) throws Exception {
		return  dao.update("UserMapper.changePwd", pd) >= 1;
	}

	
}
