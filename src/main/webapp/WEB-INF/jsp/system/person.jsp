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
</head>
<body class="easyui-layout" style="padding: 2px;">
	<table id="dg" class="easyui-datagrid" style="height:100%;display: none"
		data-options="singleSelect:true,pageSize:50,
		view:groupview,groupField:'depName',		
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
		
				
		url="system/listAll"
		rownumbers="true"
		title="人员信息档案" toolbar="#tb" pagination="true">
	<thead>
		<tr>
			<th field="EID"  hidden='true' align="center"  width="1">id</th>
			<th field="e_userName" align="center"  width="1" >用户名</th>
			<th field="e_name" align="center" width="1" >姓名</th>
			<th field=depName  align="center" width="1">部门</th>
			<th field="Job"  align="center" width="1">职位</th>
			<th field="state" align="center" width="1" >状态</th>
		</tr>
	</thead>
</table>
<div id="tb" style="display:none">
	<a href="javascript:;" id="addBtn" class="easyui-linkbutton" iconCls="icon-add" plain="true">添加</a>
	<a href="javascript:;" id="editBtn"class="easyui-linkbutton" iconCls="icon-edit" plain="true">编辑</a>	
	<a href="javascript:;" id="deleteBtn" class="easyui-linkbutton" iconCls="icon-remove" plain="true">删除</a>
	<a href="javascript:;" id="redoBtn" class="easyui-linkbutton" iconCls="icon-redo" plain="true">密码重置</a>
	<a href="javascript:;" id="reloadBtn" class="easyui-linkbutton" iconCls="icon-reload" plain="true">刷新</a>	
</div>

	<!-- 编辑窗口 -->
	<div id="win"  style="padding: 10px;display:none" >
		<form id="ff" class="easyui-form" action="system/person_add" method="post">
			<input type="hidden" name="EID">
	    	<table cellpadding="5" style="width: 100%">
	    		<tr>
	    			<td >用户名:</td>
	    			<td>
	    				<input class="easyui-textbox" style="width: 100%" type="text" id="e_userName" 
	    				name="e_userName" data-options="required:true,validType:['length[0,20]']"></input>
	    			</td>
	    		</tr>
	    		<tr>
	    			<td>姓名:</td>
	    			<td>
	    				<input class="easyui-textbox"  style="width: 100%"  type="text" 
	    				name="e_name" data-options="required:true,validType:['length[0,50]']"></input>
	    			</td>
	    		</tr>
	    		<tr>
	    			<td>部门:</td>
	    			<td>
	    				<select class="easyui-combobox" name="depName"  style="width: 100%"  
	    				data-options="required:true,validType:['length[0,20]']">
		    				<option>总经办</option>
		    				<option >运管中心</option>
		    				<option >销售部</option>
		    				<option >项目部</option>
		    				<option >开发部</option>
		    				<option >决策委员会</option>
		    				<option >销售</option>
		    				<option >客服部</option>
	    				</select>
	    			
					</td>
	    		</tr>
	    		<tr>
	    			<td>职位:</td>
	    			<td>
	    				<input class="easyui-textbox" style="width: 100%" type="text" name="Job"
	    				 data-options="required:true,validType:['length[0,20]']"></input>
					</td>
	    		</tr>
	    		<tr>
	    			<td>状态:</td>
	    			<td>
	    				<select class="easyui-combobox" name="state"  style="width: 100%"  
	    				data-options="required:true,validType:['length[0,10]']">
		    				<option>在职</option>
		    				<option >离职</option>
	    				</select>
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
	    		title:"人员档案信息",
	    		width:300,    
	    		height:260,
	    		shadow:true,
	    		modal:true,	 
	    		buttons:"#dlg-buttons",
	    		onBeforeOpen:function(){ 
	    			//清除Form
	    			$('form').form('clear');	
	    			$('form').form('reset');
	    			$("form").find('#e_userName').textbox('readonly',false);
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
	    		title:"人员档案信息",
	    		width:300,    
	    		height:260,
	    		shadow:true,
	    		modal:true,	 
	    		buttons:"#dlg-buttons",
	    		onBeforeOpen:function(){ 
	    			//清除Form
	    			$('form').form('clear');
	    			 $('form').form('load',row);
	    			 $("form").find('#e_userName').textbox('readonly',true);
	    	    } 
	    	});
	    });
		
		//密码重置
		$("#redoBtn").on("click",function(){
			var row = $("#dg").datagrid("getSelected");			
			//没有选择行
			if(!row){
				$.messager.show({
					title:'',
					msg:'请选择需要重置的账号',
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
			//提交服务器
			$.ajax({
				type: "POST",
				url: "system/person_repwd",
				dataType:'json',
				data:row,
				cache: false,
				success: function(data){
					$.messager.progress('close');
					if(data.target =="success"){
						var rowIndex = $("#dg").datagrid("getRowIndex",row);
						$.messager.show({
							"title":'',
							"msg":'重置成功',
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
				url: "system/person_delete",
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
								if($("form").find("input[name=EID]").val()==""){
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