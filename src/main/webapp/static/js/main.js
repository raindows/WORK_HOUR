$(".pf-user-panel").css("width",$(".pf-user").width()*1+15);


/****
HEAD LEFT 菜单定义
*****/
var SystemMenu = [{
	title: '任务管理',
	icon: 'fa fa-tasks',
	menu: [{
		title: '任务',
		icon: 'fa fa-tasks',
		children: [{
			title: '我的任务',
			href: 'task/to_loadMyTask'
		},{
			title: '下达任务',
			href: 'task/to_task_add'
		},{
			title: '任务关闭',
			href: 'task/to_closeTask'
		}]
	}]
},{
	title: '系统管理',
	icon: 'fa fa-tasks',
	menu: [{
		title: '主数据',
		icon: 'fa fa-tasks;',
		children: [
		 /*{
			title: '组织架构',
			href: 'index.html'
		},*/{
			title: '人员档案管理',
			href: 'system/person'
		},{
			title: '项目管理',
			href: 'project/project'
		},{
			title: '月工时统计',
			href: 'task/task_to_mothHour'
		}]
	}]
}];
/*
HEAD LEFT 菜单事件注册
 */
var mainPlatform = {

	init: function(){

		this.bindEvent();
		this._createTopMenu();
	},

	bindEvent: function(){
		var self = this;
		// 顶部大菜单单击事件
		$(document).on('click', '.pf-nav-item', function() {
            $('.pf-nav-item').removeClass('current');
            $(this).addClass('current');
            // 渲染对应侧边菜单
            var m = $(this).data("sort");            
           self._createSiderMenu(SystemMenu[m]);   
        });

		/********左侧菜单点击事件*************/
        $(document).on('click', 'ul.sider-nav-s li a', function() {
        	//点击后的菜单样式
        	$(this).closest('.easyui-accordion').find('ul.sider-nav-s li').removeClass('active');
            $(this).closest('li').addClass('active');
            var menu = $(this).closest('li');
            //打开对应tab
            self._addMainPanel({
            	"title":menu.attr("text"),
            	"href":menu.data("href")});
        });

        $(document).on('click', '.pf-logout', function() {
        	$.messager.confirm("系统登出","您确定要登出系统吗？如果是登出前请保存数据，防止数据丢失",function(ok){
        		if(ok){
        			location.href= 'system/logout'; 
        		}
        	});            
        });
	},
	//添加Tab项
	_addMainPanel:function(menu){
		//查看对应tab是否存才
		if($("#MainTabs").tabs('exists', menu.title)){			
			$('#MainTabs').tabs('select', menu.title); 
		}else{

			$("#MainTabs").tabs('add',{
				title: menu.title,
				content: '<iframe class="page-iframe" style="overflow-y:hidden;" src="'+menu.href+'" frameborder="no"   border="no" height="100%" width="100%" scrolling="auto"></iframe>',
				closable: true
			});
		}
		
	},
	// renderTopMenu
	_createTopMenu: function(){
		var menuStr = '',
			currentIndex = 0;
		for(var i = 0, len = SystemMenu.length; i < len; i++) {
			if(SystemMenu[i].title =="系统管理"){
				if($("#depName_").val() != "运管中心")
					continue;
			}
			menuStr += '<li class="pf-nav-item project" data-sort="'+ i +'" data-menu="system_menu_" + i>'+
                      '<a href="javascript:;">'+
                          '<i class="'+ SystemMenu[i].icon +'"></i>'+
                          '<span class="pf-nav-title">'+ SystemMenu[i].title +'</span>'+
                      '</a>'+
                  '</li>';
		}
		this._createSiderMenu(SystemMenu[0]);

		$('.pf-nav').html(menuStr);
		$('.pf-nav-item').eq(currentIndex).addClass('current');
	},

	_createSiderMenu: function(menu){
		while(true){
			var pp = $('#left_m').accordion('getSelected');
			if (pp){
				var index = $('#left_m').accordion('getPanelIndex',pp);
				$('#left_m').accordion('remove',index);
			}else{
				break;
			}
		}
		try{
			var opt = $('.leftMenu').panel("options");
			opt.title =menu.title;
			$('.leftMenu').panel(opt);
		}catch(e){
			$(".leftMenu").attr("data-options","region:'west',split:true,title:'"+menu.title+"'");
		}		

        for(var i = 0, len = menu.menu.length; i < len; i++){
        	var m = menu.menu[i];
        	var str ='<ul class="sider-nav-s">'		
        	if(m.children && m.children.length > 0) {
        		for(var n=0;n < m.children.length;n++){
        			if(m.children[n].isCurrent){
        				str +='<li class="active" text="'+m.children[n].title+'" data-href="'+m.children[n].href+'">';	
        			}else{
        				str +='<li class="" text="'+m.children[n].title+'" data-href="'+m.children[n].href+'">';	
        			}			
					str +='<a href="javascript:;"><i class="fa fa-list-alt"> </i> '+m.children[n].title+'</a>';
					str +='</li>';
        		}
        	}
        	str +='</ul>' ;       	
        	$('#left_m').accordion('add', {
        		title: m.title,
        		content: str,
        		selected: false
        	});
        	$('#left_m').accordion('select',0);
        }
	}
};
$(function(){
	mainPlatform.init();
});
