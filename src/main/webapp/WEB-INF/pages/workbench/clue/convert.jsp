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
	<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	
	
	<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
	
	<script type="text/javascript">
		$(function(){
			$("#isCreateTransaction").click(function(){
				if(this.checked){
					$("#create-transaction2").show(200);
				}else{
					$("#create-transaction2").hide(200);
				}
			});


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


			// 点击交易绑定市场活动，搜索市场活动按钮绑定点击事件
			$("#bindActivity").click(function (){
				loadClueActivityByClueIdLikeActivityName(null);
				$("#searchActivityModal").modal('show');
			});

			// 模糊搜索当前市场活动
			$("#activityName").blur(function (){
				var activityName = $("#activityName").val();
				if(activityName != null && activityName != ""){
					loadClueActivityByClueIdLikeActivityName(activityName);
				}
			});

			// 讲是否活动与交易进行绑定
			$("#tBody").on("click" , "input[type=radio]" , function (){
				var activityName = $(this).parent().parent().find("td").eq(1).text();
				$("#activity").val(activityName);
				$("#activityId").val(this.value);
				$("#searchActivityModal").modal('hide');
			});

			// 确认进行转换
			$("#saveCreateConvertBtn").click(function (){
				// 判断是否创建交易
				var isCreateTransaction =  $("#isCreateTransaction").prop("checked");
				var clueId = $("#clueId").val();
				var money = $.trim($("#amountOfMoney").val());
				var name = $.trim($("#tradeName").val());
				var expectedDate = $("#expectedClosingDate").val();
				var stage = $("#stage").val();
				var activityId = $("#activityId").val();

				$.ajax({
					url : 'workbench/clue/saveConvert.do',
					dataType: 'json',
					type: 'post',
					data : {
						clueId : clueId,
						isCreateTransaction : isCreateTransaction,
						money : money,
						name : name,
						expectedDate : expectedDate,
						stage : stage,
						activityId : activityId
					},
					success: function (data){
						if (data.code == 1){
							alert("转换成功！");
							window.location.href = "workbench/clue/index.do";
						}else{
							alert(data.message);
						}
					}
				})
			});

			// 取消线索转换
			$("#cancelConvertBtn").click(function (){
				window.history.go(-1);
			});

		});


		function loadClueActivityByClueIdLikeActivityName(activityName){
			var clueId = $("#clueId").val();
			$.ajax({
				url : 'workbench/clue/queryClueBindActivityByClueIdAndLikeActivityName.do',
				data : {
					clueId : clueId,
					activityName : activityName
				},
				dataType : 'json',
				type : 'get',
				success : function (data){
					if(data.code == 1){
						var activityTr = $("#tBody tr:eq(0)");
						activityTr.show();
						$("#tBody tr:not(:eq(0))").remove();
						for (var i = 0; i < data.returnData.length; i++){
							var tr = null;
							if(i == 0){
								tr = activityTr;
							}else{
								tr = activityTr.clone();
							}
							tr.find("td").eq(0).find("input").val(data.returnData[i].id);
							tr.find("td").eq(1).text(data.returnData[i].name);
							tr.find("td").eq(2).text(data.returnData[i].startDate);
							tr.find("td").eq(3).text(data.returnData[i].endDate);
							tr.find("td").eq(3).text(data.returnData[i].owner);
							$("#tBody").append(tr);
						}
					}else{
						var activityTr = $("#tBody tr:eq(0)");
						$("#tBody tr:not(:eq(0))").remove();
						activityTr.hide();
						if(confirm("未搜索到当前线索相关的市场活动信息，是否重写搜索？")){
							$("#activityName").val("");
							loadClueActivityByClueIdLikeActivityName(null);
						}
					}
				}
			});
		}

	</script>



</head>
<body>

	<input type="hidden" value="${requestScope.clue.id}" id="clueId"/>
	
	<!-- 搜索市场活动的模态窗口 -->
	<div class="modal fade" id="searchActivityModal" role="dialog" >
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">搜索市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" id="activityName" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
								<td></td>
							</tr>
						</thead>
						<tbody id="tBody">
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

	<div id="title" class="page-header" style="position: relative; left: 20px;">
		<h4>转换线索 <small>${requestScope.clue.fullname}${requestScope.clue.appellation}-${requestScope.clue.company}</small></h4>
	</div>
	<div id="create-customer" style="position: relative; left: 40px; height: 35px;">
		新建客户：${requestScope.clue.company}
	</div>
	<div id="create-contact" style="position: relative; left: 40px; height: 35px;">
		新建联系人：${requestScope.clue.fullname}${requestScope.clue.appellation}
	</div>
	<div id="create-transaction1" style="position: relative; left: 40px; height: 35px; top: 25px;">
		<input type="checkbox" id="isCreateTransaction"/>
		为客户创建交易
	</div>
	<div id="create-transaction2" style="position: relative; left: 40px; top: 20px; width: 80%; background-color: #F7F7F7; display: none;" >
	
		<form>
		  <div class="form-group" style="width: 400px; position: relative; left: 20px;">
		    <label for="amountOfMoney">金额</label>
		    <input type="text" class="form-control" id="amountOfMoney">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="tradeName">交易名称</label>
		    <input type="text" class="form-control" id="tradeName" value="${requestScope.clue.company}-">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="expectedClosingDate">预计成交日期</label>
		    <input type="text" class="form-control myDate" readonly id="expectedClosingDate">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="stage">阶段</label>
		    <select id="stage" value="0"  class="form-control">
		    	<option value="0">请选择</option>
		    	<c:forEach items="${requestScope.stageList}" var="stage">
					<option value="${stage.id}">${stage.value}</option>
				</c:forEach>
		    </select>
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="activity">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" id="bindActivity" style="text-decoration: none;"><span class="glyphicon glyphicon-search"></span></a></label>
		    <input type="text" class="form-control" id="activity" placeholder="点击上面搜索" readonly/>
			<input type="hidden" id="activityId"/>
		  </div>
		</form>
		
	</div>
	
	<div id="owner" style="position: relative; left: 40px; height: 35px; top: 50px;">
		记录的所有者：<br>
		<b>${requestScope.clue.owner}</b>
	</div>
	<div id="operation" style="position: relative; left: 40px; height: 35px; top: 100px;">
		<input class="btn btn-primary" type="button" id="saveCreateConvertBtn" value="转换">
		&nbsp;&nbsp;&nbsp;&nbsp;
		<input class="btn btn-default" type="button" id="cancelConvertBtn" value="取消">
	</div>
</body>
</html>