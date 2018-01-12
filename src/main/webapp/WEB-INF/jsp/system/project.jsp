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
	</style>
</head>
<body class="easyui-layout" style="padding: 2px;">
	<table id="dg" class="easyui-datagrid" style="height:100%;display: none"
		data-options="singleSelect:true,pageSize:50,
		view:groupview,groupField:'PROJECT_TYPE',		
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
		url="project/listAll"
		rownumbers="true"
		title="项目档案" toolbar="#tb" pagination="true">
	<thead>
		<tr>
			<th field="PID"  hidden='true' align="center"  width="1">PID</th>
			<th field="WH_PROJECT_NAME" align="center"  width="1" >项目名称</th>
			<th field="SALE_SOURCE" align="center" width="1" >销售负责人</th>
			<th field="PROJECT_LEADER"  align="center" width="1">项目经理</th>
			<th field="PROJECT_TYPE"  align="center" width="1">项目类型</th>
			<th field="UPTIME"  align="center" width="1">上线时间</th>
			<th field="DELIVERY_CYLE" align="center" width="1" >交付周期(月)</th>
			<th field="WH_MEMO" align="center" width="1" >备注</th>
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
		<form id="ff" class="easyui-form" action="project/project_add" method="post">
			<input type="hidden" name="PID">
	    	<table cellpadding="5" style="width: 100%">
	    		<tr>
	    			<td >项目名称:</td>
	    			<td>
	    				<input class="easyui-textbox" style="width: 100%" type="text" id="WH_PROJECT_NAME" 
	    				name="WH_PROJECT_NAME" data-options="required:true,validType:['length[0,100]']"></input>
	    			</td>
	    		</tr>
	    		<tr>
	    			<td>项目类型:</td>
	    			<td>
	    				<select class="easyui-combobox" name="PROJECT_TYPE"  style="width: 100%"  
	    				data-options="required:true,validType:['length[0,50]']">
		    				<option >MES</option>
		    				<option >ERP</option>
		    				<option >M2M</option>
		    				<option >APS</option>
		    				<option >WMS</option>
		    				<option >DMS</option>
		    				<option >OA</option>
	    				</select>	    			
					</td>
	    		</tr>
	    		<tr>
	    			<td>销售负责人:</td>
	    			<td>
	    				<select class="easyui-combogrid"  style="width: 100%"  type="text"
	    				name="SALE_SOURCE"
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
	    		</tr>	    		
	    		<tr>
	    			<td>项目经理:</td>
	    			<td>
	    				 <select class="easyui-combogrid"  style="width: 100%"  type="text" 
	    					name="PROJECT_LEADER"
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
	    		</tr>
	    		<tr>
	    			<td>上线时间:</td>
	    			<td>
	    				<input class="easyui-datebox" style="width: 100%" type="text" id='UPTIME' name="UPTIME"
	    				 data-options="required:true" editable="false"></input>
	    			</td>
	    		</tr>
	    		<tr>
	    			<td>上线周期:</td>
	    			<td>
	    				<input class="easyui-textbox" style="width: 100%" type="number" name="DELIVERY_CYLE"
	    				 data-options="required:true" buttonText="月"></input>
	    			</td>
	    		</tr>
	    		<tr>
	    			<td>备注:</td>
	    			<td>
	    				<input class="easyui-textbox" style="width: 100%;height:100px" type="number" name="WH_MEMO"
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

	//日期框验证
/*	$.extend($.fn.validatebox.defaults.rules, {
		TimeCheck:{
			validator: function(value, param){alert(value+","+param);
				var pattern = /^[0-9]{4}-[0-1]?[0-9]{1}-[0-3]?[0-9]{1}$/;				
				return pattern.test(value);
			},
			message:'日期格式输入非法'
		}
	});	*/

	$(function(){
	    var dg = $('#dg');
	    dg.datagrid('enableFilter');	   
		//注册添加事件
	   $("#addBtn").on("click",function(){
	    	$('#win').dialog({	    		
	    		title:"项目档案信息",
	    		width:420,    
	    		height:450,
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
	    		title:"项目档案信息",
	    		width:420,    
	    		height:450,
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
				url: "project/project_delete",
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
								if($("form").find("input[name=PID]").val()==""){
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
	
</script>
</body>