<%@ page contentType="text/html;charset=utf-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
	<meta charset="UTF-8">
	<%
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" +
	request.getServerPort() + request.getContextPath() + "/";
	%>
	<base href="<%=basePath%>"/>

	<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
	<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

	<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

	<script type="text/javascript">
		$(function (){

			// 添加日期插件，让用户选择时间
			$(".myDate").datetimepicker({
				language:'zh-CN' , // 语言
				format:'yyyy-mm-dd' , // 选中日期后，日期的格式
				minView:'month' , // 配置时间选择器，最大可用选择的时间单位，最精确可用选择到秒，当前配置最大选择到天
				initialDate:new Date(), // 初始化选择日期，打开日期选择器时默认选中的日期
				autoclose:true , // 设置选中完日期后是否自动关闭选择器，默认位 false 不关闭，true 为关闭
				todayBtn:true, // 是否显示快捷选中当前时间的按钮，默认为 false 不显示
				clearBtn:true // 是否显示清空当前已选择的日期按钮，默认为 false 不显示
			});

			$("#cancelEditBtn").click(function (){
				window.location.href = "workbench/transaction/index.do";
			});

			$("#saveEditBtn").click(function (){
				let id = '${requestScope.tran.id}';
				alert(id);
			});

			// 点击搜索联系人按钮
			$("#queryContactsBtn , #create-contactsName").click(function (){

				let contactsId = $("#create-contactsId").val();
				$.ajax({
					url : 'workbench/transaction/queryContactsNotContactsId.do',
					dataType : 'json',
					type : 'get',
					data : {
						contactsId : contactsId
					},
					success : function (data){
						if(data.code == 1){
							let trSource = $("#contactsTBody").find("tr").eq(0);
							trSource.show();
							$("#contactsTBody tr:not(:eq(0))").remove();
							for (let i = 0; i < data.returnData.length; i++) {
								let tr = trSource.clone(true);
								if(i == 0){
									tr = trSource;
								}
								tr.find("td").eq(0).find("input").attr("id" , data.returnData[i].id);
								tr.find("td").eq(1).text(data.returnData[i].fullname);
								tr.find("td").eq(2).text(data.returnData[i].email);
								tr.find("td").eq(3).text(data.returnData[i].mphone);

								tr.find("td").eq(0).find("input").prop("checked",false);
								$("#contactsTBody").append(tr);
							}
							$("#findContacts").modal('show');
						}else{
							$("#contactsTBody tr:not(:eq(0))").remove();
							$("#contactsTBody").find("tr").eq(0).hide();
							alert(data.message);
						}
					}
				});
			});

			// 选中联系人
			$("#contactsTBody").on("click" , "input[type=radio]" , function (){
				let id = $(this).attr("id");
				let fullName = $(this).parent().parent().find("td").eq(1).text();
				$("#create-contactsId").val(id);
				$("#create-contactsName").val(fullName);
				$("#findContacts").modal('hide');
			});


			// 点击搜索市场活动按钮
			$("#queryActivityBtn , #create-activityName").click(function (){
				let activityId = $("#create-activityId").val();
				$.ajax({
					url : 'workbench/transaction/queryActivityNotActivityId.do',
					dataType : 'json',
					type : 'get',
					data : {
						activityId : activityId
					},
					success : function (data){
						if(data.code == 1){
							let trSource = $("#activityTBody").find("tr").eq(0);
							trSource.show();
							$("#activityTBody tr:not(:eq(0))").remove();
							for (let i = 0; i < data.returnData.length; i++) {
								let tr = trSource.clone(true);
								if(i == 0){
									tr = trSource;
								}
								tr.find("td").eq(0).find("input").attr("id" , data.returnData[i].id);
								tr.find("td").eq(1).text(data.returnData[i].name);
								tr.find("td").eq(2).text(data.returnData[i].startDate);
								tr.find("td").eq(3).text(data.returnData[i].endDate);
								tr.find("td").eq(4).text(data.returnData[i].owner);

								tr.find("td").eq(0).find("input").prop("checked",false);
								$("#activityTBody").append(tr);
							}
							$("#findMarketActivity").modal('show');
						}else{
							$("#activityTBody tr:not(:eq(0))").remove();
							$("#activityTBody").find("tr").eq(0).hide();
							alert(data.message);
						}
					}
				});
			});

			// 选中市场活动信息
			$("#activityTBody").on("click" , "input[type=radio]" , function (){
				let id = $(this).attr("id");
				let name = $(this).parent().parent().find("td").eq(1).text();
				$("#create-activityId").val(id);
				$("#create-activityName").val(name);
				$("#findMarketActivity").modal('hide');
			});



		});
	</script>
</head>
<body>

	<!-- 查找市场活动 -->	
	<div class="modal fade" id="findMarketActivity" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable3" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
							</tr>
						</thead>
						<tbody id="activityTBody">
							<tr>
								<td><input type="radio" name="activity"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>

	<!-- 查找联系人 -->	
	<div class="modal fade" id="findContacts" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找联系人</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" style="width: 300px;" placeholder="请输入联系人名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>邮箱</td>
								<td>手机</td>
							</tr>
						</thead>
						<tbody id="contactsTBody">
							<tr>
								<td><input type="radio" name="activity"/></td>
								<td>李四</td>
								<td>lisi@bjpowernode.com</td>
								<td>12345678901</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
	
	
	<div style="position:  relative; left: 30px;">
		<h3>修改交易</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button type="button" id="saveEditBtn" class="btn btn-primary">保存</button>
			<button type="button" id="cancelEditBtn" class="btn btn-default">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form class="form-horizontal" role="form" style="position: relative; top: -30px;">
		<div class="form-group">
			<label for="create-transactionOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-transactionOwner" value="${requestScope.tran.owner}">
				  <c:forEach items="${requestScope.userList}" var="user">
					  <option ${requestScope.tran.owner==user.id?'selected':''} value="${user.id}">${user.name}</option>
				  </c:forEach>
				</select>
			</div>
			<label for="create-amountOfMoney" class="col-sm-2 control-label">金额</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-amountOfMoney" value="${requestScope.tran.money}">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-transactionName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" value="${requestScope.tran.name}" id="create-transactionName">
			</div>
			<label for="create-expectedClosingDate" class="col-sm-2 control-label">预计成交日期<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control myDate" readonly value="${requestScope.tran.expectedDate}" id="create-expectedClosingDate">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-customerName" class="col-sm-2 control-label">客户名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="hidden" id="create-customerId" value="${requestScope.customer.id}"/>
				<input type="text" class="form-control" id="create-customerName"value="${requestScope.customer.name}" placeholder="支持自动补全，输入客户不存在则新建">
			</div>
			<label for="create-transactionStage" class="col-sm-2 control-label">阶段<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
			  <select class="form-control" id="create-transactionStage" value="${requestScope.tran.stage}">
			  	<c:forEach items="${requestScope.dicValueStage}" var="stage">
					<option ${requestScope.tran.stage==stage.id?'selected':''} value="${stage.id}">${stage.value}</option>
				</c:forEach>
			  </select>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-transactionType" class="col-sm-2 control-label">类型</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-transactionType">
					<c:forEach items="${requestScope.dicValueTransactionType}" var="transactionType">
						<option ${requestScope.tran.type==transactionType.id?'selected':''} value="${transactionType.id}">${transactionType.value}</option>
					</c:forEach>
				</select>
			</div>
			<label for="create-possibility" class="col-sm-2 control-label">可能性</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" readonly value="${requestScope.possibility}%" id="create-possibility">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-clueSource" class="col-sm-2 control-label">来源</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-clueSource">
				  <c:forEach items="${requestScope.dicValueSource}" var="source">
					  <option ${requestScope.tran.source==source.id?'selected':''} value="${source.id}">${source.value}</option>
				  </c:forEach>
				</select>
			</div>
			<label for="create-activityName" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);"id="queryActivityBtn"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="hidden" id="create-activityId" value="${requestScope.activity.id}"/>
				<input type="text" class="form-control" readonly value="${requestScope.activity.name}" id="create-activityName">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-contactsName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a href="javascript:void(0);" id="queryContactsBtn"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="hidden" id="create-contactsId" value="${requestScope.contacts.id}"/>
				<input type="text" readonly class="form-control" value="${requestScope.contacts.fullname}" id="create-contactsName">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-description" class="col-sm-2 control-label">描述</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-description">${requestScope.tran.description}</textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-contactSummary">${requestScope.tran.contactSummary}</textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control myDate" readonly value="${requestScope.tran.nextContactTime}" id="create-nextContactTime">
			</div>
		</div>
		
	</form>
</body>
</html>