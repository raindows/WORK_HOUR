<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8"/> 
	<base href="<%=basePath%>"/>
	<meta http-equiv="X-UA-Compatible" content="IE=9,10,11,edge,chrome=1"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/> 
    <title>工时系统入口</title> 
	<link rel="stylesheet" type="text/css" href="static/css/login/login.css"/>
	<link rel="stylesheet" href="static/font-awesome-4.7.0/css/font-awesome.min.css">
	<script type="text/javascript" src="static/jquery.min.js"></script>
	<script type="text/javascript" src="static/jquery.form.min.js"></script>
	<script type="text/javascript" src="static/jquery.easyui.min.js"></script>
</head>
<body class="white" style="height:100%">
	<div class="login-hd">
		<div class="hd-inner">
			<img src="static/images/login_logo_w.png" class="logo">
			<span class="split"></span>
			<span class="sys-name">工时任务管理系统</span>
		</div>
	</div>
	<div class="login-bd">&nbsp;
		<div class="bd-inner">
			<div class="inner-wrap">
				<div class="lg-zone">
					<div class="lg-box">
						<div class="lg-label"><h4>用户登录</h4></div>
						<div class="alert alert-error">
			              <i class="fa fa-font-awesome"></i>
			              <span id="loginfo">请输入用户名</span>
			            </div>
						<form action="login">
							<div class="lg-e_userName input-item clearfix">
								<i class="fa fa-user"></i>
								<input type="text" placeholder="账号" id="e_userName" name="e_userName">
							</div>
							<div class="lg-password input-item clearfix">
								<i class="fa fa-lock"></i>
								<input type="password" placeholder="请输入密码" id="password" name="password">
							</div>
							<div class="lg-check clearfix">
								<div class="input-item">
									<i class="fa fa-suitcase"></i>
									<input type="text" placeholder="验证码" id="checkCode">
								</div>
								<span class="check-code">XD34F</span>
							</div>
							<!--<div class="tips clearfix">
								<label><input type="checkbox" checked="checked">记住用户名</label>
								<a href="javascript:;" class="register">立即注册</a>
								<a href="javascript:;" class="forget-pwd">忘记密码？</a>
							</div>-->
							<div class="enter">
								<a href="javascript:;" class="purchaser" id="login">进入系统</a>
							<!--	<a href="javascript:;" class="supplier" onClick="javascript:window.location='main.html'">供应商登录</a>-->
							</div>
						</form>
						<div class="line line-y"></div>
						<div class="line line-g"></div>
					</div>
				</div>
				<div class="lg-poster"></div>
			</div>
		</div>
	</div>	
</body> 
<script type="text/javascript">

	//生成随机验证码
	function randomString() {
	　　
	　　var $chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ0123456789';
	　　var maxPos = $chars.length;
	　　var pwd = '';
	　　for (i = 0; i < 5; i++) {
	　　　　pwd += $chars.charAt(Math.floor(Math.random() * maxPos));
	　　}
	　　return pwd;
	}
	$(function(){
		var height = $(document).height() - $(".login-hd").height() -2;
		$(".login-bd").css({"height":height});
		//验证码事件注册
		$(".check-code").on("click",function(){
			$(".check-code").text(randomString());
		})
		//初始加载时生成一个验证码
		$(".check-code").text(randomString());
		$("#checkCode").val($(".check-code").text());
		//登录事件注册
		$("#login").on("click",function(){
			//登录信息验证
			if($.trim($("#e_userName").val()) == ""){
				$("#loginfo").text("请输入用户名");
				return;
			}
			if($.trim($("#password").val()) == ""){
				$("#loginfo").text("请输入密码");
				return;
			}
			if($.trim($("#checkCode").val()) == ""){
				$("#loginfo").text("请输入验证码");
				return;
			}else{
				if($.trim($("#checkCode").val().toUpperCase()) != $(".check-code").text()){
					$("#loginfo").text("验证码不正确");
					return;
				}
			}
			$("#loginfo").text("正在进行身份验证,请稍后...");
			//提交表单进行验证
			$("form").ajaxSubmit({
				type: "POST",
				url: $("form").attr("action"),
				dataType:'json',				
				cache: false,
				success: function(data){					
					if(data.target =="success"){
						window.location.href = "system/main";
					}else{
						$("#loginfo").text(data.msg);
					}
				},
				error : function(XmlHttpRequest,textStatus,errorThrown){
					$("#loginfo").text("服务访问异常："+errorThrown);
				}
			});
		});
	});
</script>
</html>