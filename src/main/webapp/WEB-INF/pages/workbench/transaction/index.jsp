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
	<link href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css" type="text/css" rel="stylesheet"/>


	<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>

	<script type="text/javascript">

		$(function(){

			queryTransactionForPage(1,10);

			$("#tBody").on("click" , ".tranForDetail" , function () {
				let id = $(this).parent().parent().find("td:eq(0)").find("input").attr("id");
				window.location.href = "workbench/transaction/detail.do?id=" + id;
			});


			// 点击创建按钮
			$("#createTransactionBtn").click(function (){
				window.location.href = "workbench/transaction/save.do"
			});

			// 点击修改按钮
			$("#editTransactionBtn").click(function (){
				var chooseTr = $("#tBody tr input[type=checkbox]:checked");
				if(chooseTr.size() > 0){
					if (chooseTr.size() == 1){
						let id = chooseTr.attr("id");
						window.location.href = "workbench/transaction/edit.do?id="+id;
					}else{
						alert("最多只能选择一条要修改的交易信息!");
					}
				}else{
					alert("请选择一条要修改的交易信息!");
				}
			});

			// 点击删除按钮
			$("#deleteTransactionBtn").click(function (){

				var chooseTr = $("#tBody tr input[type=checkbox]:checked");
				if(chooseTr.size() > 0){
					if(confirm("当前选中了" + chooseTr.size() +"条交易信息，确认删除吗？")){

					}
				}else{
					alert("请选择至少一条要删除的交易信息!");
				}
			});


			// 全选按钮
			$("#transactionAllBtn").click(function (){
				let flag = $(this).prop("checked");
				$("#tBody").find("input[type=checkbox]").prop("checked" , flag);
			});
			$("#tBody").on("click" , "input[type=checkbox]" , function (){
				let inputCheckBoxList = $("#tBody").find("input[type=checkbox]")
				let flag = true;
				$.each(inputCheckBoxList , function (index, obj){
					if(!$(obj).prop("checked")){
						flag = false;
						return;
					}
				});
				$("#transactionAllBtn").prop("checked" , flag);
			});



		});

		function getPagePluginsPageSize(){
			return $("#myPage").bs_pagination('getOption' , 'rowsPerPage');
		}

		// 全部数据分页
		function queryTransactionForPage(pageNo , pageSize){
			$.ajax({
				url : 'workbench/transaction/queryTransactionForPage.do',
				data : {
					pageNo : pageNo,
					pageSize : pageSize
				},
				dataType : 'json',
				type : 'get',
				success : function (data){
					var list = data.list;
					if(list != null && list.length > 0) {
						var trSource = $("#tBody tr").eq(0);
						trSource.show();
						$("#tBody tr:not(:eq(0))").remove();
						for (var i = 0; i < list.length; i++) {
							var tr = trSource.clone(true);
							if (i == 0) {
								tr = trSource;
							}
							if (i % 2 != 0) {
								tr.addClass("active");
							}
							tr.find("td").eq(0).find("input").prop("checked", false);
							tr.find("td").eq(0).find("input").attr("id", list[i].id);
							tr.find("td").eq(1).find("a").text(list[i].name);
							tr.find("td").eq(2).text(list[i].customerId);
							tr.find("td").eq(3).text(list[i].stage);
							tr.find("td").eq(4).text(list[i].type);
							tr.find("td").eq(5).text(list[i].owner);
							tr.find("td").eq(6).text(list[i].source);
							tr.find("td").eq(7).text(list[i].contactsId);
							$("#tBody").append(tr);
						}
					}
					$("#myPage").bs_pagination({
						currentPage:pageNo, // 当前页码 pageNo
						totalRows:data.total, // 数据总条数 totalCount
						rowsPerPage:data.totalSize, // 每页显示的数据条数  pageSize
						totalPages:data.pages, // 数据总页数，必填参数，没有默认值 totalPageCount

						visiblePageLinks: 5, // 一次可显示几个用于切换的页码按钮

						showGoToPage: true, // 控制是否显示手动输入页码，跳转到指定页码，默为 true 显示
						showRowsPerPage: true, // 控制是否显示每页条数，默认未 true 显示
						showRowsInfo: true, // 控制是否显示记录的详细信息 默认未 true 显示

						onChangePage: function (event,pageObj) {
							// 当用户对分页条的数据进行修改时就会触发该函数，如进行修改每页显示数据条数、页码切换
							// 触发后该函数会返回切换后页码和每页显示的数据条数，等于返回一个 pageNo 和 pageSize
							// 封装在 pageObj 中

							// 重置全选按钮
							$("#transactionAllBtn").prop("checked" , false);
							queryTransactionForPage(pageObj.currentPage,pageObj.rowsPerPage);

						}
					})
				}
			})
		}

	</script>
</head>
<body>

	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>交易列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">客户名称</div>
				      <input class="form-control" type="text">
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">阶段</div>
					  <select class="form-control">
					  	<option value="0">请选择</option>
						  <c:forEach items="${requestScope.dicValueStage}" var="stage">
							  <option value="${stage.id}">${stage.value}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">类型</div>
					  <select class="form-control">
					  	<option value="0">请选择</option>
					  	<c:forEach items="${requestScope.dicValueTransactionType}" var="transactionType">
							<option value="${transactionType.id}">${transactionType.value}</option>
						</c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">来源</div>
				      <select class="form-control" id="create-clueSource">
						  <option value="0">请选择</option>
						  <c:forEach items="${requestScope.typeCodeSource}" var="source">
							  <option value="${source.id}">${source.value}</option>
						  </c:forEach>
						</select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">联系人名称</div>
				      <input class="form-control" type="text">
				    </div>
				  </div>
				  
				  <button type="submit" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="createTransactionBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editTransactionBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger"  id="deleteTransactionBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="transactionAllBtn" /></td>
							<td>名称</td>
							<td>客户名称</td>
							<td>阶段</td>
							<td>类型</td>
							<td>所有者</td>
							<td>来源</td>
							<td>联系人名称</td>
						</tr>
					</thead>
					<tbody id="tBody">
						<tr>
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" class="tranForDetail">动力节点-交易01</a></td>
							<td>动力节点</td>
							<td>谈判/复审</td>
							<td>新业务</td>
							<td>zhangsan</td>
							<td>广告</td>
							<td>李四</td>
						</tr>
					</tbody>
				</table>
			</div>
			


			<div id="myPage"></div>
			
		</div>
		
	</div>
</body>
</html>