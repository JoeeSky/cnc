<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE html>
<s:i18n name="contentMessage.userManage.userInfo">
<html>
<head>
<meta charset="utf-8">
<title>用户详细信息</title>
</head>
	<body>
		<form action="" class="form-horizontal" role="form">
			<div class="form-group">
				<label class="col-sm-3 control-label">角色名</label>
				<div class="col-sm-4"><p class="form-control-static"><s:property value="role.name"/></p></div>
			</div>
			<div class="form-group">
				<label class="col-sm-3 control-label">公司类型</label>
				<div class="col-sm-4"><p class="form-control-static"><s:property value="#request.companyType"/></p></div>
			</div>
			<div class="form-group">
				<label class="col-sm-3 control-label">描述</label>
				<div class="col-sm-4"><p class="form-control-static"><s:property value="role.desc"/></p></div>
			</div>
			<div class="form-group">
				<label class="col-sm-3 control-label">已启用</label>
				<div class="col-sm-4"><p class="form-control-static"><s:property value="role.enable"/></p></div>
			</div>
			<div class="form-group">
				<label class="col-sm-3 control-label">排序权重</label>
				<div class="col-sm-4"><p class="form-control-static"><s:property value="role.sortOrder"/></p></div>
			</div>
		</form>
	</body>
</html>
</s:i18n>
<content tag="scripts">
	<script src="js/king-common.js"></script>
</content>