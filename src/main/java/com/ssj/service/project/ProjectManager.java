package com.ssj.service.project;

import java.util.List;

import com.ssj.util.PageData;

public interface ProjectManager {
	
		//加载所有项目
		public List<PageData> listAll(PageData pd) throws Exception ;
		//添加项目信息
		public boolean addProject(PageData pd) throws Exception ;	
		//更新项目信息
		public boolean updateProject(PageData pd) throws Exception ;
		//删除项目信息
		public void deleteProject(PageData pd) throws Exception ;
		//查找项目
		public List<PageData> findProjectByNameAndType(PageData pd) throws Exception ;
}
