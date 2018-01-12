<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>工时任务管理系统</title>
	<base href="<%=basePath%>">
	<link rel="stylesheet" type="text/css" href="static/themes/default/easyui.css">
	<link rel="stylesheet" type="text/css" href="static/themes/icon.css">
	<link rel="stylesheet" type="text/css" href="static/static/css/demo.css">
	<link rel="stylesheet" href="static/font-awesome-4.7.0/css/font-awesome.min.css">
	<script type="text/javascript" src="static/jquery.min.js"></script>
	<script type="text/javascript" src="static/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="static/easyui-lang-zh_CN.js"></script>
	<script type="text/javascript" src="static/jquery.form.min.js"></script>
	<script type="text/javascript" src="static/datagrid-groupview.js"></script>
	<script type="text/javascript" src="static/datagrid-detailview.js"></script>
	<style type="text/css">
	.datagrid-cell, .datagrid-cell-group, .datagrid-header-rownumber, .datagrid-cell-rownumber
       {
        text-overflow: ellipsis;
       }
	</style>
</head>
<body class="easyui-layout" style="padding: 2px;">
	<table id="dg" class="easyui-datagrid" style="height:100%;display: none"
		data-options="singleSelect:true,pageSize:50" 
		fitColumns="true"
		rownumbers="true"
		title="月工时统计" toolbar="#tb" pagination="true" sortName="WORK_HOUR" sortOrder="desc">
	<thead>
		<tr>			
			<th field="PERSON_LIABLE" align="center" width=1>姓名</th>
			<th field="WORK_HOUR" align="center"  width=1>月有效总工时(天)</th>
		</tr>
	</thead>
</table>
<!--开始 datagrid 工具栏-->
<div id="tb" style="display:none">
	<div>
		开始日期: <input class="easyui-datebox" editable="false" style="width:100px" id="START_TIME" value="${START_TIME }">
		至: <input class="easyui-datebox" editable="false" style="width:100px" id="END_TIME" value="${END_TIME }">
		<a href="javascript:void(0)" id="searchBtn" class="easyui-linkbutton" iconCls="icon-search">查询</a>
		<!--  
		<a href="javascript:void(0)" id="exportBtn" class="easyui-linkbutton" iconCls="icon-search">导出Excel</a>
		-->
	</div>
</div>
<!--结束 datagrid 工具栏-->
 <script type="text/javascript" src="static/datagrid-filter.js"></script>
<script type="text/javascript">

	$(function(){		
		//查询事件
		$("#searchBtn").on("click",function(){
			//默认不加载，查询时再加载
			$('#dg').datagrid('options').url="task/task_monthHour";
			$('#dg').datagrid('load',{
				START_TIME: $("#START_TIME").val(),
				END_TIME: $("#END_TIME").val(),
			});
		})
		//结束查询事件
		
		//开始 dataGrid 明细行记录
		 $('#dg').datagrid({
             view: detailview,
             detailFormatter:function(index,row){
                 return '<div style="padding:2px;position:relative;"><table class="ddv"></table></div>';
             },
             onExpandRow: function(index,row){
                 var ddv = $(this).datagrid('getRowDetail',index).find('table.ddv');               
                 ddv.datagrid({                     
                     fitColumns:true,
                     singleSelect:true,
                     view:groupview,
                     groupFormatter:function(value,rows){
                         return value + '(' + rows.length+')';
                     },
                     groupField:'PROJECT_NAME',
                     rownumbers:true,
                     loadMsg:'正在处理,请稍后....',
                     height:'auto',
                     frozenColumns:[[
						{field:'PROJECT_NAME',title:'项目'},
						{field:'TASK_CONTENT',title:'任务',width:"200px",formatter:formatTASK_CONTENT},      
							]],
                     columns:[[
                         
                         {field:'TASK_CREATE_TIME',title:'任务下达时间'},
                         {field:'REAL_COMPLETE_TIME',title:'实际完成时间'},
                         {field:'TASK_CLOSE_TIME',title:'任务关闭时间'},
                         {field:'ESTIMATED_WORK_HOUR',title:'预估工时(天)'},
                         {field:'TASK_CREATE_PERSON',title:'派工人员'},
                         {field:'PRIORITY',title:'优先级',formatter:formatPRIORITY},                         
                         {field:'TASK_TYPE',title:'任务类型'},
                         {field:'TASK_STATE',title:'任务类型',formatter:formatTASK_STATE}
                     ]],
                     onResize:function(){
                         $('#dg').datagrid('fixDetailRowHeight',index);
                     },
                     onLoadSuccess:function(){
                    	 ddv.datagrid('collapseGroup'); //collapseGroup 折叠一个分组  
                    	 showTip();
                         setTimeout(function(){
                             $('#dg').datagrid('fixDetailRowHeight',index);
                         },0);
                     }
                 });
                 ddv.datagrid('options').url="task/task_monthHour_detail";
                 ddv.datagrid('load',{
     				START_TIME: $("#START_TIME").val(),
     				END_TIME: $("#END_TIME").val(),
     				PERSON_LIABLE:row.PERSON_LIABLE
     			});
                $('#dg').datagrid('fixDetailRowHeight',index);
             }
         });
		//结束 dataGrid 明细行记录
		
	});
	
	//格式化紧急度
	function formatPRIORITY(val,row){
		if (val !='一般'){
			return '<span style="color:red;">'+val+'</span>';
		} else {
			return val;
		}
	}
	function formatTASK_STATE(val,row){
		if (val =='已完成'){
			return '<span class="l-btn-left l-btn-icon-left">'+
					'<span class="l-btn-text">'+val+'</span>'+
					'<span class="l-btn-icon icon-ok">&nbsp;</span>'+
					'</span>';
		}else if(val =='已关闭'){
			return '<span class="l-btn-left l-btn-icon-left" style="color:red">'+
			'<span class="l-btn-text" >'+val+'</span>'+
			'<span class="l-btn-icon icon-lock">&nbsp;</span>'+
			'</span>';
		}else if(val =='退回重做'){
			return '<span class="l-btn-left l-btn-icon-left" style="color:#EEAEEE">'+
			'<span class="l-btn-text" >'+val+'</span>'+
			'<span class="l-btn-icon icon-redo">&nbsp;</span>'+
			'</span>';
		}		
		else {
			return val;
		}
	}
	function showTip(){
		 $('.task_content').tooltip({
             position:'top',
             onShow: function(){
                 $(this).tooltip('tip').css({
                     backgroundColor: '#fff000',
                     borderColor: '#ff0000',
                     boxShadow: '1px 1px 3px #292929'
                 });
             },
             onPosition: function(){
                 $(this).tooltip('tip').css('left', $(this).offset().left);
                 $(this).tooltip('arrow').css('left', 20);
             }
         });
	}
	function formatTASK_CONTENT(val,row){
		var reg=new RegExp("\r\n","g");
		var str=val.replace(/\n|\r\n/g,"<br>"); 
		return "<span  title='"+str+"' class='easyui-panel easyui-tooltip task_content' >"+val+"</span>";
	}
	
</script>
</body>