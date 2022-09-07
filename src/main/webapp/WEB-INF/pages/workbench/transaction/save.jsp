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

			$("#cancelCreateBtn").click(function (){
				window.location.href = "workbench/transaction/index.do";
			});

			$("#saveCreateBtn").click(function (){
				alert("新增");
			});

			// 选择联系人点击事件
			$("#create-contactsFullname , #create-contactsIdBtn").click(function (){
				$.ajax({
					url : 'workbench/transaction/queryContactsForTranSave.do',
					dataType : 'json',
					type : 'get',
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

			// 模糊搜索联系人信息
			$("#queryContactsLikeFullName").blur(function (){
				let fullName = $(this).val();
				likeContactsLikeFullName(fullName);
			});

			// 选中联系人
			$("#contactsTBody").on("click" , "input[type=radio]" , function (){
				let id = $(this).attr("id");
				let fullname = $(this).parent().parent().find("td").eq(1).text();
				$("#create-contactsId").val(id);
				$("#create-contactsFullname").val(fullname);
				$("#findContacts").modal('hide');
			});


			// 选中市场活动
			$("#create-activityName , #create-activityNameBtn").click(function (){
				$.ajax({
					url : 'workbench/transaction/queryActivityForTranSave.do',
					dataType : 'json',
					type : 'get',
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


			$("#likeActivityName").blur(function (){
				let name = $(this).val();
				likeActivityLikeName(name);
			});

			$("#activityTBody").on("click" , "input[type=radio]" , function(){
				let id = $(this).attr("id");
				let name = $(this).parent().parent().find("td").eq(1).text();
				$("#create-activityId").val(id);
				$("#create-activityName").val(name);
				$("#findMarketActivity").modal('hide');
			});


		});

		function likeContactsLikeFullName(fullName){
			$.ajax({
				url: 'workbench/transaction/queryContactsForTranSaveLikeFullName.do',
				data : {
					fullName : fullName
				},
				dataType : 'json',
				type : 'get',
				success : function(data){
					if(data != null && data.length > 0){
						let trSource = $("#contactsTBody").find("tr").eq(0);
						trSource.show();
						$("#contactsTBody tr:not(:eq(0))").remove();
						for (let i = 0; i < data.length; i++) {
							let tr = trSource.clone(true);
							if(i == 0){
								tr = trSource;
							}
							tr.find("td").eq(0).find("input").attr("id" , data[i].id);
							tr.find("td").eq(1).text(data[i].fullname);
							tr.find("td").eq(2).text(data[i].email);
							tr.find("td").eq(3).text(data[i].mphone);
							$("#contactsTBody").append(tr);
						}
						$("#findContacts").modal('show');
					}else{
						$("#contactsTBody tr:not(:eq(0))").remove();
						$("#contactsTBody").find("tr").eq(0).hide();
						if(confirm("为查询到与该联系人名称匹配的信息，是否重新查询？")){
							$("#queryContactsLikeFullName").val("");
							likeContactsLikeFullName(null);
						}
					}
				}
			})
		}

		function likeActivityLikeName(name){
			$.ajax({
				url: 'workbench/transaction/queryActivityForTranSaveLikeName.do',
				data : {
					name : name
				},
				dataType : 'json',
				type : 'get',
				success : function(data){
					if(data != null && data.length > 0){
						let trSource = $("#activityTBody").find("tr").eq(0);
						trSource.show();
						$("#activityTBody tr:not(:eq(0))").remove();
						for (let i = 0; i < data.length; i++) {
							let tr = trSource.clone(true);
							if(i == 0){
								tr = trSource;
							}
							tr.find("td").eq(0).find("input").attr("id" , data[i].id);
							tr.find("td").eq(1).text(data[i].name);
							tr.find("td").eq(2).text(data[i].startDate);
							tr.find("td").eq(3).text(data[i].endDate);
							tr.find("td").eq(4).text(data[i].owner);
							$("#activityTBody").append(tr);
						}
						$("#findMarketActivity").modal('show');
					}else{
						$("#activityTBody tr:not(:eq(0))").remove();
						$("#activityTBody").find("tr").eq(0).hide();
						if(confirm("为查询到与该市场活动名称匹配的信息，是否重新查询？")){
							$("#likeActivityName").val("");
							likeActivityLikeName(null);
						}
					}
				}
			})
		}


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
						    <input type="text" class="form-control" style="width: 300px;" id="likeActivityName" placeholder="请输入市场活动名称，支持模糊查询">
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
						    <input type="text" class="form-control" style="width: 300px;" id="queryContactsLikeFullName" placeholder="请输入联系人名称，支持模糊查询">
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
		<h3>创建交易</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button type="button" id="saveCreateBtn" class="btn btn-primary">保存</button>
			<button type="button" id="cancelCreateBtn" class="btn btn-default">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form class="form-horizontal" role="form" style="position: relative; top: -30px;">
		<div class="form-group">
			<label for="create-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-owner">
				  <option value="0">请选择</option>
				  <c:forEach items="${requestScope.ownerList}" var="owner">
					  <option value="${owner.id}">${owner.name}</option>
				  </c:forEach>
				</select>
			</div>
			<label for="create-money" class="col-sm-2 control-label">金额</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-money">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-name">
			</div>
			<label for="create-expectedDate" class="col-sm-2 control-label">预计成交日期<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control myDate" readonly id="create-expectedDate">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-customerId" class="col-sm-2 control-label">客户名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-customerId" placeholder="支持自动补全，输入客户不存在则新建">
			</div>
			<label for="create-transactionStage" class="col-sm-2 control-label">阶段<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
			  <select class="form-control" id="create-transactionStage">
			  	<option value="0">请选择</option>
			  	<c:forEach items="${requestScope.dicValueStage}" var="stage">
					<option value="${stage.id}">${stage.value}</option>
				</c:forEach>
			  </select>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-transactionType" class="col-sm-2 control-label">类型</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-transactionType">
					<option value="0">请选择</option>
					<c:forEach items="${requestScope.dicValueTransactionType}" var="transactionType">
						<option value="${transactionType.id}">${transactionType.value}</option>
					</c:forEach>
				</select>
			</div>
			<label for="create-possibility" class="col-sm-2 control-label">可能性</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-possibility" readonly>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-clueSource" class="col-sm-2 control-label">来源</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-clueSource">
					<option value="0">请选择</option>
					<c:forEach items="${requestScope.dicValueSource}" var="source">
						<option value="${source.id}">${source.value}</option>
					</c:forEach>
				</select>
			</div>
			<label for="create-activityName" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" id="create-activityNameBtn"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="hidden" id="create-activityId"/>
				<input type="text" class="form-control" id="create-activityName" readonly>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-contactsFullname" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a href="javascript:void(0);" id="create-contactsIdBtn"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="hidden" id="create-contactsId"/>
				<input type="text" class="form-control" id="create-contactsFullname" readonly>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-description" class="col-sm-2 control-label">描述</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-description"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-nextContactTime">
			</div>
		</div>
		
	</form>
</body>
</html>