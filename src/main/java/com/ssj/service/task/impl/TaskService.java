package com.ssj.service.task.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.ssj.dao.DaoSupport;
import com.ssj.service.task.TaskManager;
import com.ssj.util.PageData;

@Service("taskService")
public class TaskService implements TaskManager{

	@Resource(name = "daoSupport")
	private DaoSupport dao;
	
	@Override
	public List<PageData> loadMyCreateTask(PageData pd) throws Exception {
		// TODO Auto-generated method stub
		return (List<PageData>)dao.findForList("TaskMapper.loadMyCreateTask", pd);
	}

	@Override
	public List<PageData> loadCompleteAndNeedMyCloseTask(PageData pd)
			throws Exception {
		return (List<PageData>)dao.findForList("TaskMapper.loadCompleteAndNeedMyCloseTask", pd);
	}

	@Override
	public boolean addTask(PageData pd) throws Exception {
		// TODO Auto-generated method stub
		return  dao.save("TaskMapper.addTask", pd)>=0;
	}

	@Override
	public boolean updateTask(PageData pd) throws Exception {
		// TODO Auto-generated method stub
		return   dao.update("TaskMapper.updateTask", pd)>=0;
	}

	@Override
	public boolean submitTask(PageData pd) throws Exception {
		// TODO Auto-generated method stub
		return   dao.update("TaskMapper.submitTask", pd)>=0;
	}

	@Override
	public boolean closeTask(PageData pd) throws Exception {
		return   dao.update("TaskMapper.closeTask", pd)>=0;
	}

	@Override
	public void deleteTask(PageData pd) throws Exception {
		   dao.delete("TaskMapper.deleteTask", pd);
	}

	@Override
	public PageData findTaskByID(PageData pd) throws Exception {
		// TODO Auto-generated method stub
		return (PageData)dao.findForObject("TaskMapper.findTaskByID", pd);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<PageData> loadMyTask(PageData pd) throws Exception {
		return (List<PageData>)dao.findForList("TaskMapper.loadMyTask", pd);
	}

	@Override
	public boolean closeAllTask(PageData pd) throws Exception {
		return   dao.update("TaskMapper.closeAllTask", pd)>=0;
	}

	@Override
	public boolean redoTask(PageData pd) throws Exception {
		return   dao.update("TaskMapper.redoTask", pd)>=0;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<PageData> myCurrentMothCloseTask(PageData pd) throws Exception {
		return (List<PageData>)dao.findForList("TaskMapper.myCurrentMothCloseTask", pd);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<PageData> myCurrentMothComplete(PageData pd) throws Exception {		
		return (List<PageData>)dao.findForList("TaskMapper.myCurrentMothComplete", pd);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<PageData> myCurrentYearMothWorkHour(PageData pd)
			throws Exception {
		return ((List<PageData>)dao.findForList("TaskMapper.myCurrentYearMothWorkHour", pd));
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<PageData> monthHour(PageData pd) throws Exception {
		return ((List<PageData>)dao.findForList("TaskMapper.monthHour", pd));
	}

	@Override
	public List<PageData> monthHourDetail(PageData pd) throws Exception {
		return ((List<PageData>)dao.findForList("TaskMapper.monthHourDetail", pd));
	}

}
