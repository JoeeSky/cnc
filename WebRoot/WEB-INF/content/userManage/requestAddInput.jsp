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
<title>添加请求</title>
	<style>
		*{padding:0;margin:0;}
		.browser{margin-left:400px;}
		#importExcel{width:64px;height:25px;margin-left:400px;}
	</style>
</head>
<body>
	<form id="form_save" class="form-horizontal" role="form">
		<div class="form-group">
			<label class="col-sm-3 control-label">url<span class="text-danger">*</span></label>
			<div class="col-sm-4"><input type="text" class="form-control input-sm" name="req.url" maxlength="256"></div>
		</div>
		<div class="form-group">
			<label for="companyType" class="col-sm-3 control-label">所属功能<span class="text-danger">*</span></label>
			<div>
				<div class="col-sm-2">
				<select id="model" class="form-control input-sm">
					<s:iterator value="#request.model" var="modelObject">
						<option value='<s:property value="#modelObject[0].getName()"/>'><s:property value="#modelObject[0].getName()"/></option>
					</s:iterator>
				</select>
				</div>
				<div class="col-sm-2">
				<select id="function" class="form-control input-sm" name="req.functionId">
					<s:iterator value="#request.model.get(0)[1]" var="func">
						<option value='<s:property value="#func.getId()"/>'><s:property value="#func.getName()"/></option>
					</s:iterator>
				</select>
				</div>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-3 control-label">已启用<span class="text-danger">*</span></label>
			<div class="col-sm-4">
				<select class="form-control input-sm" name="req.status">
					<s:iterator value="#request.status">
						<option value='<s:property value="[0].top[0]"/>'><s:property value="[0].top[1]"/></option>
					</s:iterator>
				</select>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-3 control-label">是否页面<span class="text-danger">*</span></label>
			<div class="col-sm-4">
				<s:iterator value="#request.isPage">
					<label class="radio-inline col-sm-2" style="padding-left:28px;padding-right:24px;">
						<input type="radio" class="isPage" name="req.isPage" value='<s:property value="[0].top[0]"/>'> <s:property value="[0].top[1]"/> 
					</label>
				</s:iterator>
			</div>
		</div>
		
		<div class="form-group" id="breadCrumbRow">
			<label for="email" class="col-sm-3 control-label">面包屑</label>
			<div class="col-sm-4"><input type="text" id="breadCrumb" class="form-control input-sm" name="req.breadCrumb" value="" maxlength="100"><span style="color:#9d9d9d;padding-left:4px">用英文逗号分隔，如用户管理,用户列表</span></div>
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
						url:"request/add.ajax",
						type:"post",
						data:$("#form_save").serializeArray(),
						dataType:"json",
						success:function(data){
							if(data.info){
								alert('请求已添加成功！');
								if($isSave)
									location.reload();
								else{
									location.replace("<%= basePath%>request/copy?tid="+data.id);
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
			
			$('#model').change(function(){
				$('#function').empty();
				var model=$optionJson[$(this).val()];
				for(var key1 in model){
					var func=model[key1];
					for(var key2 in func)
					$('#function').append('<option value="'+key2+'">'+func[key2]+'</option>');
				}
			});
			
			$('#breadCrumbRow').css('display','none');
			
			$('.isPage').change(function(){
				if($(this).attr('value')=='true') $('#breadCrumbRow').show(300);
				else $('#breadCrumbRow').hide(300);
			});
			
			
		});
		function goBack(){
			if(confirm("您确定要放弃相关操作，返回到请求列表中吗？")){
				location.replace('<%= basePath%>request/list');
			}
		}
	</script>
</content>