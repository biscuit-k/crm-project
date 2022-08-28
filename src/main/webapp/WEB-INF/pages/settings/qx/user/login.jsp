<%@ page contentType="text/html;charset=utf-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
	<%
		String basePath = request.getScheme() + "://" + request.getServerName() + ":" +
		request.getServerPort() + request.getContextPath() + "/";
	%>
	<base href="<%=basePath%>"/>
	<meta charset="UTF-8">
	<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
	<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<title>Biscuit-CRM-登录</title>
	<script type="text/javascript">
		$(function () {
			$("#loginBtn").click ( function () {
				var loginAct = $.trim($("input[name = loginAct]").val());
				var loginPwd = $.trim($("input[name = loginPwd]").val());
				var isRemPwd = $("input[type = checkbox]").prop("checked");

				// 表单验证
				if ( loginAct == "" ) {
					alert("用户名不能为空！");
					return;
				}
				if ( loginPwd == "" ){
					alert("用户名密码不能为空！");
					return;
				}


				// 数据完成，则发生请求验证账号是否可以正常登录
				$.ajax({
					url : 'settings/qx/user/login.do',
					data : {
						'loginAct':loginAct,
						'loginPwd':loginPwd,
						'isRemPwd':isRemPwd
					},
					type : 'post',
					dataType : 'json',
					success : function(data){
						if(data.code == 0){
							// 登录失败，限时错误信息
							$("#msg").text(data.message);
							$("input[name = loginPwd]").val("")
						}else{
							// 登录成功则提交表单，进行正式登录
							window.location.href = "workbench/index.do";
						}
					},
					beforeSend:function() { // ajax 向后台发送请求前，执行的函数
											// 该函数的返回值可以决定最终是否真正向后台发送请求
											// 该函数返回 true : ajax 会向后台发送请求
											// 该函数返回 false : ajax 放弃向后台发送请求
						$("#msg").text("正在请求登录，请稍后！");
						return true;
					}
				})

			});

			// 给整个浏览器窗口添加键盘按下事件 ：使用回车键 Enter 键登录
			$(window).keydown(function(event){
				// 当键盘按下后，判断是否按下的是 Enter 键
				// Enter 回车键对应的编码是 13
				if( event.keyCode == 13){
					$("#loginBtn").click();
				}
			})
		})
	</script>
</head>
<body>
	<div style="position: absolute; top: 0px; left: 0px; width: 60%;">
		<img src="image/IMG_7114.JPG" style="width: 100%; height: 90%; position: relative; top: 50px;">
	</div>
	<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
		<div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">CRM &nbsp;<span style="font-size: 12px;">&copy;2022&nbsp;Biscuit</span></div>
	</div>

	<div style="position: absolute; top: 120px; right: 100px;width:450px;height:400px;border:1px solid #D5D5D5">
		<div style="position: absolute; top: 0px; right: 60px;">
			<div class="page-header">
				<h1>登录</h1>
			</div>
			<form action="/settings/qx/user/login.do" class="form-horizontal" role="form">
				<div class="form-group form-group-lg">
					<div style="width: 350px;">
						<input class="form-control" type="text" name="loginAct" value="${cookie.loginAct.value}" placeholder="用户名">
					</div>
					<div style="width: 350px; position: relative;top: 20px;">
						<input class="form-control" type="password" name="loginPwd" value="${cookie.loginPwd.value}" placeholder="密码">
					</div>
					<div class="checkbox"  style="position: relative;top: 30px; left: 10px;">
						<label>
							<c:if test="${not empty cookie.loginAct.value and not empty cookie.loginPwd.value}">
								<input type="checkbox" checked> 十天内免登录
							</c:if>
							<c:if test="${empty cookie.loginAct.value or empty cookie.loginPwd.value}">
								<input type="checkbox"> 十天内免登录
							</c:if>
						</label>
						&nbsp;&nbsp;
						<span id="msg" style="color: red;margin-left: 10px"></span>
					</div>
					<button type="button" id="loginBtn" class="btn btn-primary btn-lg btn-block"  style="width: 350px; position: relative;top: 45px;">登录</button>
				</div>
			</form>
		</div>
	</div>
</body>
</html>