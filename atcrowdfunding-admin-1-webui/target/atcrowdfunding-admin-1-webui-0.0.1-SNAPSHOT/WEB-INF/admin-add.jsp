<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="UTF-8">
<%@ include file="/WEB-INF/include-head.jsp" %>
<body>

	<%@ include file="/WEB-INF/include-nav.jsp" %>
	<div class="container-fluid">
		<div class="row">
			<%@ include file="/WEB-INF/include-sidebar.jsp" %>
			<div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
				<!-- 面包屑 -->
				<ol class="breadcrumb">
					<li><a href="admin/to/main/page.html">首页</a></li>
					<li><a href="admin/query/for/search.html">数据列表</a></li>
					<li class="active">新增</li>
				</ol>
				
					<div class="panel panel-default">
					<div class="panel-heading">
						表单数据
					</div>
					<div class="panel-body">
						<form action="admin/save.html" method="post" role="form">
							<div class="form-group">
								<label for="exampleInputPassword1">登录账号</label>
								<input
									type="text" 
									name="loginAcct"
									class="form-control" 
									id="exampleInputPassword1"
									placeholder="请输入登陆账号"/>
							</div>
							<div class="form-group">
								<label for="exampleInputPassword1">登录密码</label>
								<input
									type="text" 
									name="userPswd"
									class="form-control" 
									id="exampleInputPassword1"
									placeholder="请输入登录密码"/>
							</div>
							<div class="form-group">
								<label for="exampleInputPassword1">用户昵称</label>
								<input
									type="text" 
									name="userName"
									class="form-control" 
									id="exampleInputPassword1"
									placeholder="请输入用户昵称"/>
							</div>
							<div class="form-group">
								<label for="exampleInputEmail1">邮箱地址</label>
								<input 
									type="email"
									name="email"
									class="form-control" 
									id="exampleInputEmail1"
									placeholder="请输入邮箱地址"/>
							</div>
							<button type="submit" class="btn btn-success">
								<i class="glyphicon glyphicon-plus"></i> 新增
							</button>
							<button type="reset" class="btn btn-danger">
								<i class="glyphicon glyphicon-refresh"></i> 重置
							</button>
						</form>
					</div>
				</div>
				
			</div>
		</div>
	</div>

</body>
</html>
