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
	<script type="text/javascript" src="static/datagrid-filter.js"></script>
	<script type="text/javascript" src="static/echarts/echarts.min.js"></script>
	<script type="text/javascript" src="static/echarts/macarons.js"></script>
	<style type="text/css">	
	.datagrid-cell, .datagrid-cell-group, .datagrid-header-rownumber, .datagrid-cell-rownumber
       {
        text-overflow: ellipsis;
       }
       .datagrid-wrap{
       	border:0px
       }
	</style>
</head>
<body class="easyui-layout">
	

	<div data-options="region:'west'" style="width:50%; border: 0px;height: 100%">
		<div class="row" style="height: 50%;">
			
				<div class="col-6" style="height: 100%;">
					<div id="currentMonthComp" class="easyui-panel" title="当月任务完成率" style="height:100%;padding:10px;">
						
					</div>
				</div>
				<div class="col-6" style="height: 100%;">
					<div id="currentMonthWh" class="easyui-panel" title="当月工时统计(天)" style="height:100%;padding:10px;">
						
					</div>
				</div>
		</div>
		
		<div class="row" style="height: 50%;">
			<div class="col-12" style="height:100%;">
				<div id="monthSum" class="easyui-panel" title="每月关闭工时分析" style="height:100%;padding:10px;">
							
				</div>
			</div>
		</div>
	</div>
	<div data-options="region:'center'" style="padding:5px;width:50%; border: 0px">
		<div id="p" class="easyui-panel" title="当月已关闭任务明细" style="height:100%;">
			<table id="dg" class="easyui-datagrid" style="height:100%;display: none;border:0px" 
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
				url="task/myCurrentMothCloseTask"
				rownumbers="true"
				title="" pagination="true">
			<thead data-options="frozen:true">
				<tr>
					<th field="PROJECT_NAME" align="center"  width="1" >项目名称</th>
					<th field="TASK_CONTENT" align="center" width="1" data-options="formatter:formatTASK_CONTENT" >任务</th>
					<th field="ESTIMATED_WORK_HOUR"  align="center" width="80px">预估工时(天)</th>			
				</tr>
			</thead>
			<thead>
				<tr>
					<th field="PTID"  hidden='true' align="center"  width="1">PTID</th>
					<th field="PERSON_LIABLE" align="center" width="60px">责任人</th>
					<th field="TASK_TYPE" align="center" width="100px" >任务类型</th>
					<th field="NEED_COMPLETE_TIME"  align="center" width="100px">要求完成时间</th>					
					<th field="REAL_WORK_HOUR"  align="center" width="80px"  hidden='true'>实际工时(天)</th>
					<th field="PRIORITY" data-options="formatter:formatPRIORITY" align="center" width="50px" >优先级</th>
					<th field="TASK_CREATE_TIME" align="center" width="100px" >任务下达时间</th>
					<th field="REAL_COMPLETE_TIME" align="center" width="1" >实际完成时间</th>
					<th field="TASK_CLOSE_TIME" align="center" width="1" >任务关闭时间</th>
					<th field="TASK_STATE" align="center" width="80px" data-options="formatter:formatTASK_STATE" >任务状态</th>
				</tr>
			</thead>
		</table>
		</div>
	</div>
<script type="text/javascript">

	//任务完成率
	function taskCompleteRate(data){
		//当月任务完成率
	    var option1 = {
			    title : {
			        text: '',
			        textStyle:{
			            color:'#0098d9'
			        },
			        subtext:'当月完成率',  
			        subtextStyle:{
			            fontSize:15
			        } ,    
			        left:'50%',
			        top:'40%',
			        textAlign:'center'

			    },  
			    series : [
			        {
			            color: ['#e01f54', 'grey'],
			            name: '当月完成率',
			            type: 'pie',
			            radius : ['90%', '80%'],
			            center: ['50%', '50%'],
			            "clockWise": true,//是否顺时针
			            data:[
			                {
			                    value:data.hasComplete, 
			                    name:'当月完成率',
			                    itemStyle:{
			                        normal:{                            
			                            label:{
			                                show:true,
			                                position:'center',
			                                formatter: '{d}%',
			                                textStyle: {
			                                     color: '#e01f54',
			                                     fontSize:30
			                                 }
			                            }
			                        }
			                    }
			                },
			                {
			                    value:data.noComplete, 
			                    name:''
			                }
			            ],         
			            label:{
			                normal:{
			                    position:'center'
			                }
			            }
			        }
			    ]
			};
		 var myChart = echarts.init(document.getElementById('currentMonthComp'),"shine");
		 myChart.setOption(option1);
		 
		 var option2 = {				   
				    grid:{
				        right:0,
				        left:30,
				        top:20,
				        bottom:20
				    },
				    calculable : true,
				    xAxis : 
				        {
				            type : 'category',
				            axisTick:{
				            	show:true,
				            	length:10
				            },
				            data : ['已关闭','未关闭']
				        }
				    ,
				    yAxis : [
				        {
				            type : 'value',
				            name:""
				        }
				    ],
				    series : [
				        {
				            name:'本月工时',
				            type:'bar',				            
				            data:[data.hasComplete,data.noComplete],
				            barWidth:30,
				            color: ['#3fb1e3', '#6be6c1'],
				            label:{
				                normal:{
				                    show:true,
				                    position:'top',
				                    formatter:'{c}',
				                    textStyle:{
				                        
				                    }
				                }
				            }
				        }
				    ]
				};			
		var myChart2 = echarts.init(document.getElementById('currentMonthWh'),"macarons");
		myChart2.setOption(option2);
	
		var option3 = {
			    tooltip : {
			        trigger: 'axis'			      
			    },
			    grid:{
			        right:0,
			        left:35,
			        top:20,
			        bottom:20
			    },
			    calculable : true,
			    xAxis : 
			        {
			            type : 'category',
			            axisTick:{
			            	show:true,
			            	length:10
			            },
			            data : ['1月','2月','3月','4月','5月','6月','7月','8月','9月','10月','11月','12月']
			        },
			    yAxis : [
			        {
			            type : 'value',
			            name:""
			        }
			    ],
			    series : [
			        {
			        	name:'目标',
			            type:'bar',			            
			            data:[data.M_01,data.M_02,data.M_03,data.M_04,data.M_05,data.M_06,data.M_07,data.M_08,data.M_09,data.M_10,data.M_11,data.M_12],
			            barWidth:25,
			            label:{
			                normal:{
			                    show:true,
			                    position:'top',
			                    formatter:'{c}',
			                    textStyle:{
			                        
			                    }
			                }
			            }
			        }
			    ]
			};			
		var myChart3 = echarts.init(document.getElementById('monthSum'),"macarons");
		myChart3.setOption(option3);
	}
	$(function(){
	    var dg = $('#dg');
	    dg.datagrid('enableFilter');
	    $.messager.progress({title:"",msg:"正在处理,请稍后",text:"",interval:500});
	    $.ajax({
	    	type: "POST",
	    	url:"task/home_sum",
	    	dataType:'json',				
			cache: false,
			success: function(data){
				$.messager.progress('close');
				if(data.target=="success"){
					taskCompleteRate(data);
				}else{
					$.messager.alert('','服务器拉取报表失败','error');
				}				
			},
			error : function(XmlHttpRequest,textStatus,errorThrown){
				$.messager.progress('close');
				$.messager.alert('','服务访问异常：'+errorThrown,'error');
			}
	    }); 
			 
	});
	
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
	//格式化任务状态
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