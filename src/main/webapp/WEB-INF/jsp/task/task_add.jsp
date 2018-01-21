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
	<style type="text/css">
	#ff td{
		padding:5px 0px; 
	}
	.datagrid-cell, .datagrid-cell-group, .datagrid-header-rownumber, .datagrid-cell-rownumber
       {
        text-overflow: ellipsis;
       }
	</style>
</head>
<body class="easyui-layout" style="padding: 2px;">
	<table id="dg" class="easyui-datagrid" style="height:100%;display: none" 
		data-options="singleSelect:true,pageSize:50,
		view:groupview,groupField:'PROJECT_NAME',
		nowrap:true,fit: true,
		onLoadSuccess:showTip,
		groupFormatter:function(value,rows){
                    return value + '(' + rows.length+')';
                },
        onHeaderContextMenu: function(e, field){
					e.preventDefault();
					if (!cmenu){
						createColumnMenu();
					}
					cmenu.menu('show', {
						left:e.pageX,
						top:e.pageY
					});
				}" 
		collapsible="true"				
		url="task/loadMyCreateTask"
		rownumbers="true"
		title="任务下达" toolbar="#tb" pagination="true">
	<thead data-options="frozen:true">
		<tr>
			<th field="PROJECT_NAME" align="center"  width="1" >项目名称</th>
			<th field="TASK_CONTENT" align="center" width="1" data-options="formatter:formatTASK_CONTENT" >任务</th>
			<th field="TASK_STATE" align="center" width="80px" data-options="formatter:formatTASK_STATE" >任务状态</th>			
		</tr>
	</thead>
	<thead>
		<tr>
			<th field="PTID"  hidden='true' align="center"  width="1">PTID</th>
			<th field="PERSON_LIABLE" align="center" width="60px">责任人</th>
			<th field="TASK_TYPE" align="center" width="100px" >任务类型</th>
			<th field="NEED_COMPLETE_TIME"  align="center" width="100px">要求完成时间</th>
			<th field="ESTIMATED_WORK_HOUR"  align="center" width="80px">预估工时(天)</th>
			<th field="REAL_WORK_HOUR"  align="center" width="80px"  hidden='true'>实际工时(天)</th>
			<th field="PRIORITY" data-options="formatter:formatPRIORITY" align="center" width="50px" >优先级</th>
			<th field="TASK_CREATE_TIME" align="center" width="100px" >任务下达时间</th>
			<th field="REAL_COMPLETE_TIME" align="center" width="1" >实际完成时间</th>
			<th field="TASK_CLOSE_TIME" align="center" width="1" >任务关闭时间</th>
		</tr>
	</thead>
</table>
<div id="tb" style="display:none">
	<a href="javascript:;" id="addBtn" class="easyui-linkbutton" iconCls="icon-add" plain="true">添加</a>
	<a href="javascript:;" id="editBtn"class="easyui-linkbutton" iconCls="icon-edit" plain="true">编辑</a>	
	<a href="javascript:;" id="deleteBtn" class="easyui-linkbutton" iconCls="icon-remove" plain="true">删除</a>
	<a href="javascript:;" id="reloadBtn" class="easyui-linkbutton" iconCls="icon-reload" plain="true">刷新</a>	
</div>

	<!-- 编辑窗口 -->
	<div id="win"  style="padding: 10px;display:none" >
		<form id="ff" class="easyui-form" action="task/task_add" method="post">
			<input type="hidden" name="PTID">
	    	<table cellpadding="5" style="width: 100%">
	    		<tr>
	    			<td style="width: 10%">项目名称:</td>
	    			<td style="width: 40%">
	    				<select class="easyui-combogrid"  style="width: 100%"  type="text"
	    				name="PROJECT_NAME" 
	    				data-options="required:true,
	    					validType:['length[0,100]'], 
				            panelWidth:450,
				            idField:'WH_PROJECT_NAME',    
				            textField:'WH_PROJECT_NAME',    
				            url:'project/listAll', 				            
				            columns:[[    
				            	{field:'PTID',title:'PTID',width:60,hidden:true},
				            	{field:'WH_PROJECT_NAME',title:'项目名称'},
				                {field:'PROJECT_LEADER',title:'项目经理'},    
				                {field:'PROJECT_TYPE',title:'项目类型'},    
				                {field:'UPTIME',title:'上线时间'},    
				                {field:'DELIVERY_CYLE',title:'上线周期(月)'}    
				            ]]    
				        ">
	    				</select>
	    			</td>
	    			
	    			<td style="width: 10%">预计工时:</td>
	    			<td style="width: 40%">
	    				<input class="easyui-textbox" type="number" name="ESTIMATED_WORK_HOUR"
	    				 data-options="required:true," buttonText="天" style="width: 100%"> 	    			
					</td>
	    		</tr>
	    		
	    		<tr>
	    			<td>要求完成时间:</td>
	    			<td>
	    				<input class="easyui-datebox" style="width: 100%" type="text" name="NEED_COMPLETE_TIME"
	    				 data-options="required:true" editable="false"></input>
	    			</td>
	    			
	    			<td>任务类型:</td>
	    			<td>
	    				 <select class="easyui-combobox"  style="width: 100%"  type="text" 
	    					name="TASK_TYPE"
	    					data-options="required:true,validType:['length[0,100]']">
	    					<option>开发</option>
	    					<option>Bug</option>
	    					<option>售前技术支持</option>
	    					<option>售后服务</option>
	    					<option>项目实施</option>
	    				</select>
					</td>
	    		</tr>	    		
	    		
	    		<tr>
	    			<td>责任人:</td>
	    			<td>
	    				<select class="easyui-combogrid"  style="width: 100%"  type="text"
	    				name="PERSON_LIABLE"
	    				data-options="required:true,
	    					validType:['length[0,50]'], 
				            panelWidth:380,
				            idField:'e_name',    
				            textField:'e_name',    
				            url:'system/listAll',    
				            columns:[[    
				            	{field:'EID',title:'id',width:60,hidden:true},
				            	{field:'e_userName',title:'用户名',width:60,hidden:true},
				                {field:'e_name',title:'姓名',width:60},    
				                {field:'depName',title:'部门',width:100},    
				                {field:'Job',title:'职位',width:120},    
				                {field:'state',title:'状态',width:100}    
				            ]]    
				        ">
	    				</select>
	    			</td>
	    		
	    			<td>优先级:</td>
	    			<td>
	    				<select class="easyui-combobox"  style="width: 100%"  type="text" 
	    					name="PRIORITY"
	    					data-options="required:true,validType:['length[0,50]']">
	    					<option>一般</option>
	    					<option>紧急</option>
	    				</select>
	    			</td>
	    		</tr>
	    		<tr>
	    			<td>任务:</td>
	    			<td colspan="3">
	    				<input class="easyui-textbox" style="width: 100%;height:150px" type="number" name="TASK_CONTENT"
	    				 data-options="multiline:true,validType:['length[0,4000]']"></input>
	    			</td>
	    		</tr>
	    	</table>
	    </form>
	   
	</div> 
	<div id="dlg-buttons" style="display: none">
		<table cellpadding="0" cellspacing="0" style="width:100%">
			<tr>
				<td style="text-align:right">
					<a href="javascript:void(0);" class="easyui-linkbutton" iconCls="icon-save" onclick="submitForm()">保存</a>
					<a href="javascript:void(0);" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#win').dialog('close')">关闭</a>
				</td>
			</tr>
		</table>
	</div>

 <script type="text/javascript" src="static/datagrid-filter.js"></script>
<script type="text/javascript">

	$(function(){
	    var dg = $('#dg');
	    dg.datagrid('enableFilter');	   
		//注册添加事件
	   $("#addBtn").on("click",function(){
	    	$('#win').dialog({	    		
	    		title:"任务下达",
	    		width:600,    
	    		height:400,
	    		shadow:true,
	    		modal:true,	 
	    		buttons:"#dlg-buttons",
	    		onBeforeOpen:function(){ 
	    			//清除Form
	    			$('form').form('clear');	
	    			$('form').form('reset');
	    			$("form").find('#WH_PROJECT_NAME').textbox('readonly',false);
	    	    } 
	    	});
	    });
		//编辑事件
		$("#editBtn").on("click",function(){
			//查找选择编辑的记录
			var row = $("#dg").datagrid("getSelected");			
			//没有选择行
			if(!row){
				$.messager.show({
					title:'',
					msg:'请选择需要编辑的行',
					showType:'show',
					timeout:2000,
					style:{
						right:'',
						top:document.body.scrollTop+document.documentElement.scrollTop,
						bottom:''
					}
				});

				return;
			}
			 
	    	$('#win').dialog({	    		
	    		title:"任务下达",
	    		width:600,    
	    		height:400,
	    		shadow:true,
	    		modal:true,	 
	    		buttons:"#dlg-buttons",
	    		onBeforeOpen:function(){ 
	    			//清除Form
	    			$('form').form('clear');
	    			 $('form').form('load',row);
	    			// $("form").find('#WH_PROJECT_NAME').textbox('readonly',true);
	    	    } 
	    	});
	    });
		
		
		//删除按钮
		$("#deleteBtn").on("click",function(){
			var row = $("#dg").datagrid("getSelected");			
			//没有选择行
			if(!row){
				$.messager.show({
					title:'',
					msg:'请选择需要删除的行',
					showType:'show',
					timeout:2000,
					style:{
						right:'',
						top:document.body.scrollTop+document.documentElement.scrollTop,
						bottom:''
					}
				});
				return;
			}
			$.messager.progress({title:"",msg:"正在处理,请稍后",text:"",interval:500});
			//提交服务器删除
			$.ajax({
				type: "POST",
				url: "task/task_delete",
				dataType:'json',
				data:row,
				cache: false,
				success: function(data){
					$.messager.progress('close');
					if(data.target =="success"){
						var rowIndex = $("#dg").datagrid("getRowIndex",row);	
						$("#dg").datagrid("deleteRow",rowIndex);	
						$.messager.show({
							"title":'',
							"msg":'删除成功',
							"showType":'show',
							"timeout":2,
							"style":{
								"right":'',
								"top":document.body.scrollTop+document.documentElement.scrollTop,
								"bottom":''
								}
							});
					}else{
						$.messager.alert('',data.msg,'error');
					}
				},
				error : function(XmlHttpRequest,textStatus,errorThrown){
					$.messager.progress('close');
					$.messager.alert('','服务访问异常：'+errorThrown,'error');
				}
			});
		});
		//刷新
		$("#reloadBtn").on("click",function(){
			$('#dg').datagrid('reload');
		});		
		
	});

	//表单提交
	function submitForm(){
        $('form').form('submit',{
            onSubmit:function(){
            	//验证通过提价表单
			 if($(this).form('enableValidation').form('validate'))
				 {
					 $.messager.progress({title:"",msg:"正在处理,请稍后",text:"",interval:500});
					//提交表单
					$("form").ajaxSubmit({
						type: "POST",
						url: $("form").attr("action"),
						dataType:'json',				
						cache: false,
						success: function(data){	
							$.messager.progress('close');
							if(data.target =="success"){
								$('#win').dialog("close");							
								// 消息将显示在顶部中间
								$.messager.show({
									"title":'',
									"msg":'保存成功',
									"showType":'show',
									"timeout":2000,
									"style":{
										"right":'',
										"top":document.body.scrollTop+document.documentElement.scrollTop,
										"bottom":''
									}
								});
								//新增
								if($("form").find("input[name=PTID]").val()==""){
									data.msg.TASK_STATE="已下达";
									$('#dg').datagrid('appendRow',data.msg);
								}else{
									//修改
									$('#dg').datagrid('updateRow',{
										index: $("#dg").datagrid("getRowIndex",$("#dg").datagrid("getSelected")),	// 索引从0开始
										row: data.msg
									});
								}
							}else{
								$.messager.alert('',data.msg,'error');
							}
						},
						error : function(XmlHttpRequest,textStatus,errorThrown){
							$.messager.progress('close');
							$.messager.alert('','服务访问异常：'+errorThrown,'error');
						}
					});
				 }
			 return false;
            }
        });
    }
	
	var cmenu;
	function createColumnMenu(){
		cmenu = $('<div/>').appendTo('body');
		cmenu.menu({
			onClick: function(item){
				if (item.iconCls == 'icon-ok'){
					$('#dg').datagrid('hideColumn', item.name);
					cmenu.menu('setIcon', {
						target: item.target,
						iconCls: 'icon-empty'
					});
				} else {
					$('#dg').datagrid('showColumn', item.name);
					cmenu.menu('setIcon', {
						target: item.target,
						iconCls: 'icon-ok'
					});
				}
			}
		});
		var fields = $('#dg').datagrid('getColumnFields');
		for(var i=0; i<fields.length; i++){
			var field = fields[i];
			var col = $('#dg').datagrid('getColumnOption', field);
			cmenu.menu('appendItem', {
				text: col.title,
				name: field,
				iconCls: 'icon-ok'
			});
		}
	}
	
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