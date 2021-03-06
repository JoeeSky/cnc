<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>菜单列表</title>
</head>
<body>
	<div id="jqgrid-wrapper">
		<!-- 条件搜索 begin-->
		<div class="row">
			<div class="col-sm-5 pull-right">
				<a class="btn btn-primary btn-sm  pull-right" style="margin-left:20px;" href="menu/addInput">添加新菜单</a>
				<a class="btn btn-primary btn-sm  pull-right" style="margin-left:20px;" href="menu/addInput?tid=0">添加顶级菜单</a>
				<div id="fuzzySearchbox"
					class="input-group input-group-sm searchbox">
					<input type="search" id="searchText" class="form-control"
						placeholder="请输入关键字..."> <span class="input-group-btn">
						<button class="btn btn-default" type="button" id="searchButton">
							<i class="fa fa-search"></i>
						</button>
					</span>				
				</div>			
			</div>
		</div>
		<form class="form-horizontal" role="form" id="exactForm">
			<fieldset>
				<legend>查询条件</legend>
				<div class="col-sm-3">
					<div class="input-group input-group-sm">
						<div class="input-group-addon">姓名</div>
						<input type="text" class="form-control" name="name">
					</div>
				</div>
				<div class="col-sm-3">
					<div class="input-group input-group-sm">
						<div class="input-group-addon">角色</div>
						<select id="role" name="role" class="form-control">
							<option value="">所有角色</option>
						</select>
					</div>
				</div>
				<div class="col-sm-3">
					<button class="btn btn-primary btn-sm" id="exactQuery">查询</button>
					<button class="btn btn-danger btn-sm" id="clearExactForm">清除</button>
				</div>
			</fieldset>
		</form>
		<!-- 条件搜索 end-->
		<!-- jqgrid begin-->
		<table id="jqgrid" class="table table-striped table-hover"></table>
		<div id="jqgrid-pager"></div>
		<!-- jqgrid end-->
	</div>
</body>
</html>
	<content tag="scripts">
	<script src="js/jquery.ba-bbq.min.js"></script>
	<script src="js/grid.history.js"></script>
	<script src="js/i18n/grid/grid.locale-cn.js"></script>
	<script> $.jgrid.useJSON = true; </script>
	<script src="js/jquery.jqGrid.min.js"></script>
	<script src="js/jquery.jqGrid.fluid.js"></script>
	<script src="js/king-common.js"></script>
	<script>
		function formatUser(cellvalue, options, rowObject){
			if(cellvalue.id == null){
				return "";
			}
			return "<a  target='_blank' href='menu/info?tid="+cellvalue.id+"'>"+cellvalue.title+"</a>";
		}

		$(document).ready(function() {
		    function e() {
		        $("#jqgrid").length > 0 && t.fluidGrid({
		            base: "#jqgrid-wrapper",
		            offset: 0
		        })
		    }
		    var t = $("#jqgrid");
		    $("#jqgrid").length > 0 && (t.jqGrid({
		    	url:"menu/listAjax.ajax",
		    	mtype:"GET",
		    	datatype:"json",
		    	colNames:['菜单标题','父菜单','排序','操作'],
		    	height:410,
		    	rowNum:<s:property value="@org.nfmedia.crms.cons.CommonConstant@DEFAULT_PAGE_SIZE"/>,
		    	rowList: [10, 20, 30],
        		pager: "jqgrid-pager",
        		multiselect: !0,
        		editurl:"menu/edit.ajax",
        		sortname:"id",
        		sortorder: "asc",
        		viewrecords: !0,
        		colModel:[{
        			name:"title",
        			index:"title",
        			align:"center",
        			formatter:formatUser
        		},{
        			name:"parentId",
        			index:"parentId",
        			hidden:true
        		},{
        			name:"sortOrder",
        			index:"sortOrder",
        			align:"center"
        		},{
        			name:"actions",
        			sortable: !1,
        			search: !1,
        			align:"center"
        		}],
        		gridComplete: function(){
        			var ids = $("#jqgrid").jqGrid("getDataIDs");
        			for(var i=0;i < ids.length;i++){
        				ee = '<button class="btn btn-danger btn-xs" onclick="location.href=\'<%= basePath%>menu/updateInput?tid='+ids[i]+'\'">修改</button>';
                        de = '<button class="btn btn-success btn-xs" onclick="$(\'#jqgrid\').delGridRow(\''+ids[i]+'\')">删除</button>';                        
                        pe = '<button class="btn btn-info btn-xs" onclick="location.href=\'<%= basePath%>menu/addInput?tid='+ids[i]+'\'">添加子菜单</button>';
                        fe = '<button class="btn btn-primary btn-xs" onclick="location.href=\'<%= basePath%>menu/copy?tid='+ids[i]+'\'">复制</button>';
                        var rowData = $("#jqgrid").jqGrid("getRowData",ids[i]);//根据上面的id获得本行的所有数据
                        if(rowData.parentId==0) t.jqGrid('setRowData',ids[i],{actions:ee+de+pe+fe});
                        else t.jqGrid('setRowData',ids[i],{actions:ee+de+fe});
                    }
        		}
		    }), e(), $("#jqgrid").length > 0 && t.jqGrid("navGrid","#jqgrid-pager",{
		    	add:!1,
		    	edit:!1,
		    	del:!0,
		    	view:!1,
		    	search: !1,
        		refresh: !0
		    },{},{},{},{
		    	multipleSearch: true,
		    	multipleGroup:true
		    })),
		    $(window).resize(e);

		    //根据关键字搜索
		    /* $("#searchText").keypress(function(event){
		    	if(event.keyCode == "13"){
		    		$("#searchButton").click();
		    	}
		    });
		    $("#searchButton").click(function(){
		    	//console.log("searchbox click");
		    	$("#exactForm")[0].reset();
		    	var searchFilter = $.trim($("#searchText").val());
		    	if(searchFilter.length === 0){
		    		t[0].p.search = false;
		    		$.extend(t[0].p.postData,{searchString:"",searchField:"",searchOper:""});
		    	}else{
		    		searchFilter = " where u.status == 'U and (u.account like '%"+searchFilter+"%' or u.name like '%"+searchFilter+"%' or u.companyType like '%"+searchFilter+"%')";
		    		t[0].p.search = true;
		    		$.extend(t[0].p.postData,{searchString:searchFilter,searchField:"allfieldsearch",searchOper:"cn"});
		    	}
		    	t.trigger("reloadGrid",[{page:1,current:true}]);
		    })

		    //精确搜索
		    $("#exactQuery").click(function(){
		    	var $name = $.trim($("input[name='name']").val());
		    	var $department = $.trim($("#department").val());
		    	var $role = $.trim($("#role").val());
		    	if($name===""&&$department===""&&$role===""){
		    		t[0].p.search = false;
		    		$.extend(t[0].p.postData,{searchString:"",searchField:"",searchOper:""});
		    	}else{
		    		var searchFilter = " and (";
		    		if($name!==""){
		    			searchFilter += "u.name like '%"+$name+"%' and ";
		    		}
		    		if($department !== ""){
		    			searchFilter += "u.department.name like '%"+$department+"%' and ";
		    		}
		    		if($role !== ""){
		    			searchFilter += "u.role.name like '%"+$role+"%'";
		    		}else{
		    			searchFilter = searchFilter.substring(0,searchFilter.lastIndexOf('and '));
		    		}
		    		searchFilter += ")";
		    		console.log(searchFilter);
		    		t[0].p.search = true;
		    		$.extend(t[0].p.postData,{searchString:searchFilter,searchField:"allfieldsearch",searchOper:"cn"});
		    	}
		    	t.trigger("reloadGrid",[{page:1,current:true}]);
		    	return false;
		    });

			$("#clearExactForm").click(function(){
				$("#searchButton").click();
				return false;
			}); */
		});
			
	</script>
	</content>