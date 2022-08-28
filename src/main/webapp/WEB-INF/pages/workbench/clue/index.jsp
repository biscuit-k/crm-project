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
	<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
	<link href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css" type="text/css" rel="stylesheet"/>

	<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>

	<script type="text/javascript">

	$(function(){

		// 添加日期插件，选择日期使用插件
		$(".myDate").datetimepicker({
			language:'zh-CN' , // 语言
			format:'yyyy-mm-dd' , // 选中日期后，日期的格式
			minView:'month' , // 配置时间选择器，最大可用选择的时间单位，最精确可用选择到秒，当前配置最大选择到天
			initialDate:new Date(), // 初始化选择日期，打开日期选择器时默认选中的日期
			autoclose:true , // 设置选中完日期后是否自动关闭选择器，默认位 false 不关闭，true 为关闭
			todayBtn:true, // 是否显示快捷选中当前时间的按钮，默认为 false 不显示
			clearBtn:true // 是否显示清空当前已选择的日期按钮，默认为 false 不显示
		});

		// 加载分页数据
		loadClueForPage(1,10);

		// 给创建线索按钮绑定点击事件
		$("#createClueModalBtn").click(function(){
			// 重置模态框表单数据
			$("#createClueForm").get(0).reset();

			// 打开创建线索的模态框
			$("#createClueModal").modal('show');
		});


		// 给确认创建线索按钮绑定点击事件
		$("#saveCreateClueBtn").click(function(){
			// 线索参数
			var fullname        = $.trim( $("#create-fullname").val() );
			var appellation     = $("#create-appellation").val();
			var owner           = $("#create-owner").val();
			var company         = $.trim( $("#create-company").val() );
			var job             = $.trim( $("#create-job").val() );
			var email           = $.trim( $("#create-email").val() );
			var phone           = $.trim( $("#create-phone").val() );
			var website         = $.trim( $("#create-website").val() );
			var mphone          = $.trim( $("#create-mphone").val() );
			var state           = $("#create-state").val();
			var source          = $("#create-source").val();
			var description     = $.trim( $("#create-description").val() );
			var contactSummary  = $.trim( $("#create-contactSummary").val() );
			var nextContactTime = $.trim( $("#create-nextContactTime").val() );
			var address         =  $.trim($("#create-address").val() );

			// 表单验证

			// 发送请求进行数据提交进行新增
			$.ajax({
				url : 'workbench/clue/saveCreateClue.do',
				data : {
					fullname : fullname,
					appellation : appellation,
					owner : owner,
					company : company,
					job : job,
					email : email,
					phone : phone,
					website : website,
					mphone : mphone,
					state : state,
					source : source,
					description : description,
					contactSummary : contactSummary,
					nextContactTime: nextContactTime,
					address : address
				},
				dataType : 'json',
				type : 'post',
				success : function(data){
					if(data.code){
						alert("新增成功");
						loadClueForPage(1 , getTotalSize());
						$("#createClueModal").modal('hide');
						$("#chooseAllClue").prop("checked" , false);
						$("#tBody input[type=checkbox]:checked").prop("checked" , false);
					}else{
						alert(data.message);
						$("#createClueModal").modal('show');
					}
				}
			})

		});


		// 给修改线索按钮绑定点击事件
		$("#editClueModalBtn").click(function(){
			// 重置模态框表单数据
			$("#editClueFrom").get(0).reset();

			// 判断当前是否选中了一个线索，并获取其id
			var clue = $("#tBody input[type=checkbox]:checked");
			if(clue.size() == 0){
				alert("需要选中一条线索才能进行修改！");
			}else{
				if(clue.size() == 1){
					var id = clue.val();
					$.ajax({
						url : 'workbench/clue/queryClueByIdFromEdit.do',
						data : {
							id : id
						},
						dataType : 'json',
						type : 'get',
						success : function (data){
							if(data.code == 1){
								var clue = data.returnData;
								// 向表单中填充数据
								$("#clueId").val(clue.id);
								$("#edit-fullname").val(clue.fullname);
								$("#edit-address").val(clue.address);
								$("#edit-owner").val(clue.owner);
								$("#edit-phone").val(clue.phone);
								$("#edit-mphone").val(clue.mphone);
								$("#edit-nextContactTime").val(clue.nextContactTime);
								$("#edit-website").val(clue.website);
								$("#edit-company").val(clue.company);
								$("#edit-description").val(clue.description);
								$("#edit-source").val(clue.source);
								$("#edit-state").val(clue.state);
								$("#edit-job").val(clue.job);
								$("#edit-contactSummary").val(clue.contactSummary);
								$("#edit-appellation").val(clue.appellation);
								$("#edit-email").val(clue.email);
								// 打开修改线索模态框
								$("#editClueModal").modal('show');
							}else{
								alert(data.message);
							}
						}
					})
				}else{
					alert("只能选中一条线索进行修改！")
				}
			}


		});


		// 给确认修改线索按钮绑定点击事件
		$("#saveEditClueBtn").click(function(){
			// 线索参数

			var id				= $("#clueId").val();
			var fullname        = $.trim( $("#edit-fullname").val() );
			var appellation     = $("#edit-appellation").val();
			var owner           = $("#edit-owner").val();
			var company         = $.trim( $("#edit-company").val() );
			var job             = $.trim( $("#edit-job").val() );
			var email           = $.trim( $("#edit-email").val() );
			var phone           = $.trim( $("#edit-phone").val() );
			var website         = $.trim( $("#edit-website").val() );
			var mphone          = $.trim( $("#edit-mphone").val() );
			var state           = $("#edit-state").val();
			var source          = $("#edit-source").val();
			var description     = $.trim( $("#edit-description").val() );
			var contactSummary  = $.trim( $("#edit-contactSummary").val() );
			var nextContactTime = $.trim( $("#edit-nextContactTime").val() );
			var address         =  $.trim($("#edit-address").val() );
			$.ajax({
				url : 'workbench/clue/saveUpdateClue.do',
				data : {
					id : id,
					fullname : fullname,
					appellation : appellation,
					owner : owner,
					company : company,
					job : job,
					email : email,
					phone : phone,
					website : website,
					mphone : mphone,
					state : state,
					source : source,
					description : description,
					contactSummary : contactSummary,
					nextContactTime: nextContactTime,
					address : address
				},
				dataType : 'json',
				type : 'post',
				success : function (data){
					if(data.code == 1){
						alert("修改线索成功！");
						loadClueForPage(1 , getTotalSize());
						$("#editClueModal").modal('hide');
						$("#chooseAllClue").prop("checked" , false);
						$("#tBody input[type=checkbox]:checked").prop("checked" , false);
					}else{
						alert(data.message);
					}
				}
			})
		});

		// 点击查看明细
		$("#tBody").on("click" , ".detailHref" , function(){
			var id = $(this).parent().parent().find("input[type=checkbox]").val();
			window.location.href = "workbench/clue/detail.do?id="+id;
		});

		// 点击全选
		$("#chooseAllClue").click(function () {
			var flag = $(this).prop("checked");
			$.each($("#tBody input[type=checkbox]") , function(index , obj){
				$(obj).prop("checked" , flag);
			});
		})

		// 选中单个
		$("#tBody").on("click" , "input[type=checkbox]" , function (){
			var isChooseNum = $("#tBody input[type=checkbox]:checked").size();
			var chooseNum = $("#tBody input[type=checkbox]").size();
			if(isChooseNum == 0){
				$("#chooseAllClue").prop("checked",false);
			}else{
				if(chooseNum == isChooseNum){
					$("#chooseAllClue").prop("checked",true);
				}else{
					$("#chooseAllClue").prop("checked",false);
				}
			}
		});


		// 为批量删除按钮绑定单击事件
		$("#deleteClueBtn").click(function () {
			// 判断当前是否选中了线索
			var chooseClue = $("#tBody input[type=checkbox]:checked");
			if(chooseClue.size() > 0){
				var id = "";

				$.each(chooseClue , function (index , obj){
					id += "id=" + $(obj).val() + "&";
				});
				id = id.substring(0 , id.length-1);
				if(confirm("确认删除当前选中的" + chooseClue.size() + "线索信息吗？")){
					if(chooseClue.size() > 5){
						if(confirm("当前选中的线索数量为五条以上，确认删除吗？")){
							$.ajax({
								url : 'workbench/clue/saveDeleteClueById.do',
								data : id,
								dataType : 'json',
								type : 'post',
								success : function (data){
									if (data.code == 1){
										alert("删除成功！");
										loadClueForPage(1 , getTotalSize());
									}else{
										alert(data.message);
									}
								}
							});
						}
					}else{
						$.ajax({
							url : 'workbench/clue/saveDeleteClueById.do',
							data : id,
							dataType : 'json',
							type : 'post',
							success : function (data){
								if (data.code == 1){
									alert("删除成功！");
									loadClueForPage(1 , getTotalSize());
									$("#chooseAllClue").prop("checked" , false);
									$("#tBody input[type=checkbox]:checked").prop("checked" , false);
								}else{
									alert(data.message);
								}
							}
						});
					}
				}
			}else{
				alert("至少选中一条需要删除的线索！")
			}
		});
		
	});

	function loadClueForPage(pageNo,totalSize){

		// 向服务器发送请求获取分页数据的第一页
		$.ajax({
			url : 'workbench/clue/queryClueCarryPage.do',
			data : {
				pageNo : pageNo,
				totalSize : totalSize
			},
			dataType : 'json',
			type : 'get',
			success : function (data){
				if(data.code == 1){
					// 加载当前页数据
					var pageData = data.returnData.list;
					// 删除除第一条分页模板外的其他数据列表
					$(".clueTr:not(:eq(0))").remove();
					var clueTr = $(".clueTr");
					for (var i = 0; i < pageData.length; i++){
						var tr = null;
						if(i == 0){
							tr = clueTr;
						}else{
    						tr = clueTr.clone(true);
						}
						if(i % 2 != 0){
							tr.addClass("activity");
						}
						tr.find("input[type=checkbox]").val(pageData[i].id);
						tr.find("td").eq(1).find("a").text(pageData[i].fullname);
						tr.find("td").eq(2).text(pageData[i].company);
						tr.find("td").eq(3).text(pageData[i].phone);
						tr.find("td").eq(4).text(pageData[i].mphone);
						tr.find("td").eq(5).text(pageData[i].source);
						tr.find("td").eq(6).text(pageData[i].owner);
						tr.find("td").eq(7).text(pageData[i].state);
						if(i != 0){
							$("#tBody").append(tr);
						}
					}

					// 加载分页插件
					$("#demo_page1").bs_pagination({
						currentPage:pageNo, // 当前页码 pageNo
						totalRows:data.returnData.total, // 数据总条数 totalCount
						rowsPerPage:totalSize, // 每页显示的数据条数  pageSize
						totalPages:data.returnData.pages, // 数据总页数，必填参数，没有默认值 totalPageCount

						visiblePageLinks: 5, // 一次可显示几个用于切换的页码按钮

						showGoToPage: true, // 控制是否显示手动输入页码，跳转到指定页码，默为 true 显示
						showRowsPerPage: true, // 控制是否显示每页条数，默认未 true 显示
						showRowsInfo: true, // 控制是否显示记录的详细信息 默认未 true 显示

						onChangePage: function (event,pageObj) {
							// 当用户对分页条的数据进行修改时就会触发该函数，如进行修改每页显示数据条数、页码切换
							// 触发后该函数会返回切换后页码和每页显示的数据条数，等于返回一个 pageNo 和 pageSize
							// 封装在 pageObj 中

							// 重置全选按钮
							$("#activityAllBtn").prop("checked" , false);
							loadClueForPage(pageObj.currentPage,pageObj.rowsPerPage);

						}
					})
				}else{
					alert("查询失败！")
				}
			}
		})

	}

	// 获取当前每页显示总条数
	function getTotalSize(){
		return $("#demo_page1").bs_pagination('getOption' , 'rowsPerPage');
	}
	
	</script>
</head>
<body>

	<!-- 创建线索的模态窗口 -->
	<div class="modal fade" id="createClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">创建线索</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" id="createClueForm" role="form">
					
						<div class="form-group">
							<label for="create-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner">
								  <option value="0">请选择</option>
								  <c:forEach items="${requestScope.userReturn}" var="user">
									  <option value="${user.id}">${user.name}</option>
								  </c:forEach>
								</select>
							</div>
							<label for="create-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-company">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-appellation" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-appellation">
								  <option value="0">请选择</option>
								  <c:forEach items="${requestScope.dicValueCall}" var="dicValue">
									  <option value="${dicValue.id}">${dicValue.value}</option>
								  </c:forEach>
								</select>
							</div>
							<label for="create-fullname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-fullname">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-job">
							</div>
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
							<label for="create-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-website">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-mphone">
							</div>
							<label for="create-state" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-state">
									<option value="0">请选择</option>
									<c:forEach items="${requestScope.dicValueClueState}" var="user">
										<option value="${user.id}">${user.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-source">
									<option value="0">请选择</option>
									<c:forEach items="${requestScope.dicValueSource}" var="dicValue">
										<option value="${dicValue.id}">${dicValue.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						

						<div class="form-group">
							<label for="create-description" class="col-sm-2 control-label">线索描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control myDate" readonly id="create-nextContactTime">
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>
						
						<div style="position: relative;top: 20px;">
							<div class="form-group">
                                <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address"></textarea>
                                </div>
							</div>
						</div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveCreateClueBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改线索的模态窗口 -->
	<div class="modal fade" id="editClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">修改线索</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" id="editClueFrom" role="form">
						<input type="hidden" id="clueId"/>
						<div class="form-group">
							<label for="edit-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-owner">
									<option value="0">请选择</option>
									<c:forEach items="${requestScope.userReturn}" var="user">
										<option value="${user.id}">${user.name}</option>
									</c:forEach>
								</select>
							</div>
							<label for="edit-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-company" value="动力节点">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-appellation" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-appellation">
									<option value="0">请选择</option>
									<c:forEach items="${requestScope.dicValueCall}" var="dicValue">
										<option value="${dicValue.id}">${dicValue.value}</option>
									</c:forEach>
								</select>
							</div>
							<label for="edit-fullname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-fullname" value="李四">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job" value="CTO">
							</div>
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email" value="lisi@bjpowernode.com">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone" value="010-84846003">
							</div>
							<label for="edit-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-website" value="http://www.bjpowernode.com">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone" value="12345678901">
							</div>
							<label for="edit-state" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-state">
									<option value="0">请选择</option>
									<c:forEach items="${requestScope.dicValueClueState}" var="dicValue">
										<option value="${dicValue.id}">${dicValue.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-source">
									<option value="0">请选择</option>
									<c:forEach items="${requestScope.dicValueSource}" var="dicValue">
										<option value="${dicValue.id}">${dicValue.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description">这是一条线索的描述信息</textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="edit-contactSummary">这个线索即将被转换</textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control myDate" readonly id="edit-nextContactTime" value="2017-05-01">
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address">北京大兴区大族企业湾</textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveEditClueBtn">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>线索列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司</div>
				      <input class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司座机</div>
				      <input class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索来源</div>
					  <select class="form-control">
						  <option value="0">请选择</option>
						  <c:forEach items="${requestScope.dicValueSource}" var="dicValue">
							  <option value="${dicValue.id}">${dicValue.value}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text">
				    </div>
				  </div>
				  
				  
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">手机</div>
				      <input class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索状态</div>
					  <select class="form-control">
						  <option value="0">请选择</option>
						  <c:forEach items="${requestScope.dicValueClueState}" var="dicValue">
							  <option value="${dicValue.id}">${dicValue.value}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>

				  <button type="submit" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="createClueModalBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editClueModalBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteClueBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 50px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input id="chooseAllClue" type="checkbox" /></td>
							<td>名称</td>
							<td>公司</td>
							<td>公司座机</td>
							<td>手机</td>
							<td>线索来源</td>
							<td>所有者</td>
							<td>线索状态</td>
						</tr>
					</thead>
					<tbody id="tBody">
						<tr class="clueTr">
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" class="detailHref">李四先生</a></td>
							<td>动力节点</td>
							<td>010-84846003</td>
							<td>12345678901</td>
							<td>广告</td>
							<td>zhangsan</td>
							<td>已联系</td>
						</tr>

                        <%--<tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">李四先生</a></td>
                            <td>动力节点</td>
                            <td>010-84846003</td>
                            <td>12345678901</td>
                            <td>广告</td>
                            <td>zhangsan</td>
                            <td>已联系</td>
                        </tr>--%>

					</tbody>
				</table>
			</div>



			<div id="demo_page1" style="margin-top: 70px"></div>
		</div>
	</div>
</body>
</html>