package com.ssj.service.project.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Component;

import com.ssj.dao.DaoSupport;
import com.ssj.service.project.ProjectManager;
import com.ssj.util.PageData;

@Component("projectService")
public class ProjectService implements ProjectManager{

	@Resource(name = "daoSupport")
	private DaoSupport dao;
	
	
	@SuppressWarnings("unchecked")
	@Override
	public List<PageData> listAll(PageData pd) throws Exception {
		// TODO Auto-generated method stub
		return (List<PageData>) dao.findForList("ProjectMapper.listAll", pd);
	}

	@Override
	public boolean addProject(PageData pd) throws Exception {
		// TODO Auto-generated method stub
		return  dao.save("ProjectMapper.addProject", pd)>=1;
	}

	@Override
	public boolean updateProject(PageData pd) throws Exception {		
		return  dao.update("ProjectMapper.updateProject", pd) >=1;
	}

	@Override
	public void deleteProject(PageData pd) throws Exception {
		dao.delete("ProjectMapper.deleteProject", pd);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<PageData> findProjectByNameAndType(PageData pd)
			throws Exception {
		return (List<PageData>)dao.findForList("ProjectMapper.findProjectByNameAndType", pd);				
	}
}
