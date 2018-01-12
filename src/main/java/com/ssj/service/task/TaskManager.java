package com.ssj.service.task;

import java.util.List;

import com.ssj.util.PageData;

public interface TaskManager {

	//加载我下达的任务
	public List<PageData> loadMyCreateTask(PageData pd) throws Exception ;
	//已完成且需要我关闭的任务
	public List<PageData> loadCompleteAndNeedMyCloseTask(PageData pd) throws Exception ;
	//加载给我的任务且未完成的
	public List<PageData> loadMyTask(PageData pd) throws Exception ;
	//添加任务
	public boolean addTask(PageData pd) throws Exception ;	
	//更新我下达的任务信息
	public boolean updateTask(PageData pd) throws Exception ;
	//任务完成提交
	public boolean submitTask(PageData pd) throws Exception ;
	//关闭任务
	public boolean closeTask(PageData pd) throws Exception ;
	//任务退回重做
	public boolean redoTask(PageData pd) throws Exception ;
	//关闭所有任务
	public boolean closeAllTask(PageData pd) throws Exception ;
	//删除任务信息
	public void deleteTask(PageData pd) throws Exception ;
	//查找任务
	public PageData findTaskByID(PageData pd) throws Exception ;
	//我的当月已关闭任务
	public List<PageData> myCurrentMothCloseTask(PageData pd) throws Exception ;
	//当月任务完成率
	public List<PageData> myCurrentMothComplete(PageData pd) throws Exception ;
	//当年度每月工时统计
	public List<PageData> myCurrentYearMothWorkHour(PageData pd) throws Exception ;	
	//当年度每月工时统计
	public List<PageData> monthHour(PageData pd) throws Exception ;	
	//当年度每月工时统计明细
	public List<PageData> monthHourDetail(PageData pd) throws Exception ;
	
	
	
}
