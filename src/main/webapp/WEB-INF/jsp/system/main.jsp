<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8">
	<base href="<%=basePath%>">
	<meta http-equiv="X-UA-Compatible" content="IE=9,10,11,edge,chrome=1">
	<title>工时任务管理系统</title>
	<!--框架样式-->
	<link rel="stylesheet" type="text/css" href="static/themes/default/easyui.css">	
	<!--框架样式-->
	<link rel="stylesheet" type="text/css" href="static/themes/icon.css">
	<!--自定义样式，全局样式文件-->
	<link rel="stylesheet" type="text/css" href="static/css/demo.css">
	<!--第三方插件，字体图标-->
	<link rel="stylesheet" href="static/font-awesome-4.7.0/css/font-awesome.min.css">
	<!--jquery-->
	<script type="text/javascript" src="static/jquery.min.js"></script>
	<!--框架脚本-->
	<script type="text/javascript" src="static/jquery.easyui.min.js"></script>
	<!-- jquery 表单 -->
	<script type="text/javascript" src="static/jquery.form.min.js"></script>
</head>
<body class="easyui-layout" id="main">
	<!--BEGIN HEAD PANEL-->
	<div data-options="region:'north',border:false" style="background:#007cb6;padding:0px 5px;overflow-y: hidden;">
		<div id="pf-hd">
			<!--BEGIN LOGO-->
			<div class="pf-logo">
				<img src="static/images/main/login.png" alt="logo" style="height:37px">
			</div>		
			<!--END LOGO-->

			<!--BEGIN HEAD MENU-->
			<div class="pf-nav-wrap">
              <!--BEGIN pf-nav-ww-->
              <div class="pf-nav-ww">               
                <ul class="pf-nav">	
					<!--
					<li class="pf-nav-item project" data-sort="0" data-menu="system_menu_1">
						<a href="javascript:;">
							<i class="fa fa-tasks"></i>
							<span class="pf-nav-title">任务管理</span>
						</a>
					</li>
					<li class="pf-nav-item project current" data-sort="1" data-menu="system_menu_2">
						<a href="javascript:;">
							<i class="fa fa-camera-retro"></i>
							<span class="pf-nav-title">系统管理</span>
						</a>
					</li>
					-->
				</ul>
              </div>
              <!--END pf-nav-ww-->
            </div>
			<!--END HEAD MENU-->
			
			<!--BEGIN pf-user-->
			<div class="pf-user">
            	<!--<span class="msgts">10</span>-->
                <div class="pf-user-photo">
                    <img src="static/images/main/user.png" alt="">                   
                </div>
                <h4 class="pf-user-name ellipsis">${user.e_name}</h4>
                <input id="depName_" type="hidden" value="${user.depName }">
                <i class="fa fa-angle-down" 
					style="font-size: 16px;font-style: normal;-webkit-font-smoothing: antialiased;-webkit-text-stroke-width: 0.2px;-moz-osx-font-smoothing: grayscale;color:white"></i>
				<!--BEGIN pf-user-panel-->
                <div class="pf-user-panel">                	
                    <ul class="pf-user-opt">                       
                        <li class="pf-modify-pwd">
                            <a href="javascript:void(0);" id="changePwd">
                                <i class="fa fa-key"></i>
                                <span class="pf-opt-name">修改密码</span>
                            </a>
                        </li>
                        <li class="pf-logout">
                            <a href="javascript:void(0);">
                                 <i class="fa fa-sign-out"></i>
                                <span class="pf-opt-name">退出</span>
                            </a>
                        </li>
                    </ul>
                </div>
				<!--END pf-user-panel-->
            </div>
			<!--END pf-user-->

		</div>
	</div>
	<!--END HEAD PANEL-->

	<!--BEGIN LEFT MENU-->
	<div data-options="region:'west',split:true,title:''" style="width:150px;" class="leftMenu" >
		<!--BEGIN easyui-accordion-->
		<div class="easyui-accordion" data-options="fit:true,border:false,split:true"  id="left_m"> 			
			<!--
			<div title="Title1" style="padding:10px;" data-options="selected:true">
				<ul class="sider-nav-s">					
					<li class="active" text="首页" data-href="workbench.html">					
						<a href="#"><i class="fa fa-list-alt"> </i> 首页</a>
					</li>					
					<li class="" text="详细信息" data-href="providers1.html">
						<a href="#">
							<i class="fa fa-list-alt"> </i> 详细信息
						</a>
					</li>
					<li class="" text="企业基本信息" data-href="basic_info.html">
						<a href="#">
							<i class="fa fa-list-alt"> </i> 企业基本信息
						</a>
					</li>
				</ul>
			</div>
			<div title="Title2" data-options="" style="padding:10px;">
				content2
			</div>
			<div title="Title3" style="padding:10px">
				content3
			</div>
			-->
		</div>
		<!--END easyui-accordion-->
	</div>
	<!--END LEFT MENU-->
	<!--
	<div data-options="region:'east',split:true,collapsed:true,title:'East'" style="width:100px;padding:10px;">east region</div>
	-->
	<!--BEGIN CENTER-->
	<div data-options="region:'center'" style="border:0px">
		<!--BEGIN TABS-->
		<div id="MainTabs" class="easyui-tabs tabs-container easyui-fluid" style="width:100%;height:100%;border:0px">
			<!--BEGIN TAB PANEL-->
			<div title="首页" style="padding:0px;" >
				<iframe class="page-iframe" style="overflow-y:hidden;" src="system/home" frameborder="no"   border="no" height="100%" width="100%" scrolling="auto"></iframe>
			</div>
			<!--END TAB PANEL-->
		</div>
		<!--END TABS-->
	</div>
	<!--END CENTER-->
	
	<!--begin 修改密码 -->
	<div id="win"  style="padding: 10px;display:none" >
		<form id="ff" class="easyui-form" action="system/change_pwd" method="post">
			<input type="hidden" name="EID">
	    	<table  style="width: 100%">
	    		<tr>
	    			<td >旧密码:</td>
	    			<td>
	    				<input class="easyui-passwordbox"  type="text" name="old_pwd" data-options="required:true,validType:['length[0,20]']"></input>
	    			</td>
	    		</tr>
	    		<tr>
	    			<td>新密码:</td>
	    			<td>
	    				<input class="easyui-passwordbox" type="text" name="new_pwd" data-options="required:true,validType:['length[0,20]']"></input>
	    			</td>
	    		</tr>
	    		<tr>
	    			<td>密码确认:</td>
	    			<td>
	    				<input class="easyui-passwordbox"  type="text" name="re_pwd" data-options="required:true,validType:['length[0,20]']"></input>
					</td>
	    		</tr>	    		
	    	</table>
	    </form>	   
	</div> 
	<!-- begin dlg-buttons -->
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
	<!-- begin dlg-buttons -->
	<!--end 修改密码 -->
	<!--主界面 js-->
	<script type="text/javascript" src="static/js/main.js"></script>
	<script type="text/javascript">
	$(function(){
		// 开始 修改密码
		$("#changePwd").on("click",function(){
			
			$('#win').dialog({	    		
	    		title:"修改密码",
	    		width:250,    
	    		height:200,
	    		shadow:true,
	    		modal:true,	 
	    		buttons:"#dlg-buttons",
	    		onBeforeOpen:function(){ 
	    			//清除Form
	    			$('form').form('clear');	
	    			$('form').form('reset');
	    	    } 
	    	});
		});
		// 结束 修改密码
	})
	
	//表单提交
	function submitForm(){
        $('form').form('submit',{
            onSubmit:function(){
            	//验证通过提价表单
			 if($(this).form('enableValidation').form('validate'))
				 {
				 	if($("input[name=new_pwd]").val() != $("input[name=re_pwd]").val())
				 		{
				 			$.messager.alert("","两次新密码不一样", "error");
				 			return false;
				 		}
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
									"msg":'密码修改成功',
									"showType":'show',
									"timeout":2000,
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
				 }
			 return false;
            }
        });
    }
	</script>
</body>
</html>
