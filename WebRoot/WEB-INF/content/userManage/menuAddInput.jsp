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
<title>添加菜单项</title>
	<style>
		*{padding:0;margin:0;}
		.browser{margin-left:400px;}
		#importExcel{width:64px;height:25px;margin-left:400px;}
	</style>
</head>
<body>
	<form id="form_save" class="form-horizontal" role="form">
		<div class="form-group">
			<label for="name" class="col-sm-3 control-label">菜单项标题<span class="text-danger">*</span></label>
			<div class="col-sm-4"><input type="text" class="form-control input-sm" name="menu.title" maxlength="100"></div>
		</div>
		<div class="form-group">
			<label for="companyType" class="col-sm-3 control-label">父菜单项<span class="text-danger">*</span></label>
			<div class="col-sm-4">
				<select id="parent" class="form-control input-sm" name="menu.parentId">
					<s:iterator value="#request.topMenus" var="menu">
						<option value='<s:property value="#menu.getId()"/>' <s:if test='%{#menu.getId()==#request.tid}'>selected</s:if> ><s:property value="#menu.getTitle()"/></option>
					</s:iterator>
				</select>
			</div>
		</div>
		<div class="form-group">
			<label for="email" class="col-sm-3 control-label">url</label>
			<div class="col-sm-4"><input type="text"  class="form-control input-sm" name="menu.url" maxlength="256"></div>
		</div>
		<div class="form-group">
			<label for="cellphone" class="col-sm-3 control-label">所属功能<span class="text-danger">*</span></label>
			<div>
				<div class="col-sm-2">
					<select id="model" class="form-control input-sm">
						<s:iterator value="#request.model"  var="modelObject">
							<option value='<s:property value="#modelObject[0].getName()"/>'><s:property value="#modelObject[0].getName()"/></option>
						</s:iterator>
					</select>
				</div>
				<div class="col-sm-2">
					<select id="function" class="form-control input-sm" name="menu.functionId">
						<s:iterator value="#request.model.get(0)[1]" var="func">
							<option value='<s:property value="#func.getId()"/>'><s:property value="#func.getName()"/></option>
						</s:iterator>
					</select>
				</div>
			</div>
		</div>
		<div class="form-group">
			<label for="email" class="col-sm-3 control-label">排序</label>
			<div class="col-sm-4"><input type="text" class="form-control input-sm" name="menu.sortOrder" value="20"></div>
		</div>
	</form>
	<p class="text-center">
		<button type="button" class="btn btn-custom-primary btn-sm" id="copy" style="float:right;margin-right:42%" ><i class="fa fa-floppy-o"></i>保存并复制</button>
		<button type="button" class="btn btn-custom-primary btn-sm" id="save" style="float:right;margin-right:20px"><i class="fa fa-floppy-o"></i>保存</button>
		<button type="button" class="btn btn-custom-primary btn-sm" id="back" onclick="goBack()" style="float:right;background:#AAAAAB;border:1px solid #AAAAAB;width:63px;margin-right:20px"></i>返回</button>	
	</p>
</body>
</html>
<content tag="scripts">
	<script src="js/king-common.js"></script>
	<script src="js/jquery.maxlength.js"></script>
	<script>
		$optionJson=<s:property value="optionJson" escape="false"/>;
		$(document).ready(function(){
			$("#save,#copy").click(function(){
				$isSave=$(this).attr("id")=="save";
				$.ajax({
					url:"menu/add.ajax",
					type:"post",
					data:$("#form_save").serializeArray(),
					dataType:"json",
					success:function(data){
						if(data.info){
							alert('菜单项已添加成功！');
							if($isSave)
								location.reload();
							else{
								location.replace("<%= basePath%>menu/copy?tid="+data.id);
							}
							//$("#form_save")[0].reset();
						}else{
							alert('保存失败');
						}
					},
					error:function(data){
						alert('保存失败');
					}
				});
			});
			
			if($('#parent').val()==0){
				$('#model option[value="通用"]').attr("selected",true);
				reload_subMenu("通用");
			}
			
			$('#model').change(function(){
				reload_subMenu($(this).val());			
			});
			
			
			$('#parent').change(function(){
				if($(this).val()==0){
					$('#model option[value="通用"]').attr("selected",true);
					reload_subMenu("通用");
				}
			});
			
		});
		var reload_subMenu= function($topId){
			$('#function').empty();
			var model=$optionJson[$topId];
			for(var key1 in model){
				var func=model[key1];
				for(var key2 in func)
				$('#function').append('<option value="'+key2+'">'+func[key2]+'</option>');
			}
		};
		function goBack(){
			if(confirm("您确定要放弃相关操作，返回到菜单项列表中吗？")){
				location.replace('<%= basePath%>menu/list');
			}
		}
	</script>
</content>