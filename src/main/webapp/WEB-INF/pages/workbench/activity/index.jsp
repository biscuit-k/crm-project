<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=utf-8" language="java" %>
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

			// 给创建按钮添加点击事件
			$("#createActivityBtn").click(function () {
				// 模态框初始化工作
				// 重置一个 form 表单中的所有数据
				$("#createActivityForm")[0].reset(); // js 中的方法


				// 弹出模态窗口
				$("#createActivityModal").modal("show")


			});

			// 新增市场活动保存按钮点击事件
			$("#saveCreateActivityBtn").click(function () {
				var owner = $("#create-marketActivityOwner").val();
				var name = $.trim($("#create-marketActivityName").val());
				var startDate = $("#create-startDate").val();
				var endDate = $("#create-endDate").val();
				var cost = $.trim($("#create-cost").val());
				var description = $.trim($("#create-description").val());

				// 表单验证，验证数据合法性
				if(owner == "" || owner == 0){
					alert("所有者不能为空！")
					return false;
				}
				if(name == ""){
					alert("名称不能为空！")
					return false;
				}
				if(startDate != "" && endDate != ""){
					// 使用字符串的大小比较开始日期和结束日期的大小
					if(startDate > endDate){
						alert("开始日期不能大于结束日期！");
						return false;
					}
				}else{
					alert("日期不能为空！");
					return false;
				}

				/*
					正则表达式：
						语法通则：
							1) // 表示在js中定义个正则表达式：/xxxxxx/
							2） ^  表示匹配字符串的开头位置，表示一个字符串只能以什么内容开头
							    $  表示匹配字符串的结尾位置，表示一个字符串只能以什么内容结尾
							3) [] 表示匹配指定字符集中的一位字符：/[avc]/ 表示被匹配的字符串中必须要由一位是 avc 中任一位
												之中可以使用 - 表示多个内容，例如 a - z 表示 a - z 之间的所有内容
																			0 - 9 表示 0 - 9 之间的所有内容
							4) {} 表示匹配次数 /[a-z]{7}/ 表示当前字符串需要是 7 位，并且是 a - z 之间的字符
								{m} 表示匹配 m 次
								{m , n} 表示匹配 m 到 n 次
								{m ,} 表示匹配 m 次或者更多次
							5) 特殊字符
								\d : 匹配一位数字，相当于 [0-9]
								\D : 匹配一位非数字，只要不是数字即可
								\w : 匹配所有的字符，它包含字母、数字、下划线，但不包含特殊符号
								\W : 匹配所有的非字符，它包含字母、数字、下划线之外的字符

								* : 匹配 0 次或多次，相当于{0,}
								+ : 匹配 1 次或多次，相当于{1,}
								+ : 匹配 0 次或 1 次，相当于{0,1}
				 */
				var regExp = /^(([1-9]\d*)| 0)$/;
				if(!regExp.test(cost)){ // 字符串符合则返回 true
					alert("成本请输入非负整数！");
					return false;
				}

				// 数据都合法则发送 ajax 请求
				$.ajax({
					url : 'workbench/activity/saveCreateActivity.do' ,
					data : {
						owner : owner,
						name : name,
						startDate : startDate,
						endDate : endDate,
						cost : cost,
						description : description
					},
					tyep : 'post' ,
					dataType : "json" ,
					success : function (data){
						if (data.code == 1){
							// 新增成功 ，关闭模态框
							$("#createActivityModal").modal("hide");
							queryActivityByCondition(1,getPageSize());
							// 新增成功后，刷新当前页面的市场活动数据
						}else{
							// 新增失败，显示错误信息
							$("#createActivityModal").modal("show");
						}
					}
				})




				return false;
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


			// 当页面加载完成后，发送请求，请求市场活动数据的第一页数据
			queryActivityByCondition(1,10);


			// 给查询按钮添加单击事件，实现条件查询分页
			$("#queryActivityBtn").click(function () {
				queryActivityByCondition(1,getPageSize());
			});


			// 批量删除选中的数据操作
			$("#deleteActivityBtn").click(function(){
				var dom = $("#tBody input[type='checkbox']:checked");
				if(dom != null && dom.size() > 0){
					var ids = "";
					$.each(dom , function (index , obj) {
						ids += "ids=" + obj.value + "&";
					})
					ids = ids.substring(0,ids.length-1);
					console.log(ids)
					if(confirm("当前选中" + dom.size() +"条数据，确认删除吗？")){
						if(dom.size() > 5){
							if(confirm("当前选中的数据量较多，为" + dom.size() +"条数据，确认删除吗？")){
								deleteActivityByIds(ids);
							}
						}else{
							deleteActivityByIds(ids);
						}
					}
				}else{
					alert("当前尚未选中市场活动数据！")
				}




			});

			// 点击全选按钮
			$("#activityAllBtn").click(function () {
				var flag = $(this).prop("checked");
				$("#tBody input[type='checkbox']").prop("checked" , flag);
			});

			// 进行单选时判断当前是否为全选状态
			$("#tBody").on( "click" , "input[type='checkbox']" , function () {


				var allCheckbox = $("#tBody input[type='checkbox']").size();
				var allCheckboxIsChecked = $("#tBody input[type='checkbox']:checked").size();
				if(allCheckbox == allCheckboxIsChecked){
					$("#activityAllBtn").prop("checked" , true);
				}else{
					$("#activityAllBtn").prop("checked" , false);
				}


			})

			// 为修改按钮绑定点击事件
			$("#updateActivityBtn").click(function () {

				$("#editActivityForm").get(0).reset(); // 清空一次表单原有内容

				// 判断当前选中的数据条数，只有在选中一条数据时才能修改
				var isChooseData = $("#tBody input[type=checkbox]:checked");
				if(isChooseData.size() != 0){
					if(isChooseData.size() == 1){
						var id = isChooseData.val();

						// 向服务器请求当前 id 对应的市场活动数据
						$.ajax({
							url : 'workbench/activity/queryActivityById.do',
							data : {
								id : id,
							},
							dataType : 'json',
							type : 'post',
							success : function (data){
								if(data.code == 1){// 打开模态框
									// 向模态框中填充数据信息
									$("#edit-id").val(data.returnData.id);
									$("#edit-owner").val(data.returnData.owner);
									$("#edit-name").val(data.returnData.name);
									$("#edit-cost").val(data.returnData.cost);
									$("#edit-startDate").val(data.returnData.startDate);
									$("#edit-endDate").val(data.returnData.endDate);
									$("#edit-description").val(data.returnData.description);



									$("#editActivityModal").modal('show');
								}else{
									alert(data.message);
								}
							}
						})

					}else{
						alert("一次只能修改一条市场活动的信息！")
					}
				}else{
					alert("请选择一条需要修改的市场活动信息！")
				}
			})

			// 为修改市场活动数据的确认修改按钮绑定点击事件
			$("#editActivityBtn").click( function () {
				var id = $("#edit-id").val();
				var owner = $("#edit-owner").val();
				var name = $.trim($("#edit-name").val());
				var startDate = $("#edit-startDate").val();
				var endDate = $("#edit-endDate").val();
				var cost = $("#edit-cost").val();
				var description = $.trim($("#edit-description").val());

				// 表单验证，验证数据合法性
				if(owner == "" || owner == 0){
					alert("所有者不能为空！")
					return false;
				}
				if(name == ""){
					alert("名称不能为空！")
					return false;
				}
				if(startDate != "" && endDate != ""){
					// 使用字符串的大小比较开始日期和结束日期的大小
					if(startDate > endDate){
						alert("开始日期不能大于结束日期！");
						return false;
					}
				}else{
					alert("日期不能为空！");
					return false;
				}

				$.ajax({
					url : 'workbench/activity/saveEditActivity.do',
					data : {
						id:id,
						owner:owner,
						name:name,
						startDate:startDate,
						endDate:endDate,
						cost:cost,
						description,description
					},
					dataType : 'json',
					type : 'post',
					success : function (data) {
						if(data.code == 1){
							$("#editActivityModal").modal('hide');
							alert("修改成功！")
							queryActivityByCondition(1,getPageSize());
						}else{
							alert(data.message);
						}
					}
				})
			} );

			// 为导出所有市场活动信息按钮绑定点击事件
			$("#exportActivityAllBtn").click( function () {
				// 向服务器端发送到处所有市场活动信息请求
				if(confirm("是否要导出所有市场活动信息？")){
					window.location.href = "workbench/activity/exportAllActivity.do";
				}
			} )

			// 为导出选中的市场活动信息按钮绑定点击事件
			$("#exportActivityXzBtn").click( function () {
				var id = "";
				var chooseActivity = $("#tBody input[type=checkbox]:checked");
				if(chooseActivity.size() >= 1){

					$.each(chooseActivity , function(index , obj) {
						id += "ids=" + obj.value + "&";
					})

					id = id.substring(0 , id.length-1);

					if(confirm("是否要导出已选择的 "+ chooseActivity.size() +"条市场活动信息？")){
						window.location.href = "workbench/activity/exportActivityByIds.do?"+id;
					}
				}else{
					alert("请选择至少一条要到处的市场活动信息");
				}
			} )

			// 为导入按钮绑定点击事件
			$("#importActivityFileBtn").click(function(){
				// 清空上次导入上传的文件
				$("#activityFile")[0].files[0] = null;
				$("#activityFile").val("");
				// 点击时打开导入文件模态框
				$("#importActivityModal").modal('show');
			});

			// 为确认导入文件按钮绑定点击事件
			$("#importActivityBtn").click(function(){
				// 获取上传文件名称
				var activityFileName = $("#activityFile").val();
				// 判断上传文件是否的 .xls 格式的 excel 文件
				var fileType = activityFileName.substring(activityFileName.lastIndexOf(".")+1,activityFileName.length);
				if(fileType.toLocaleLowerCase() == "xls"){
					// 获取文件表组件中的文件内容
					var activityFile = $("#activityFile")[0].files[0];
					// 判断文件大小是否符合最大限制 , 5MB
					if( activityFile.size <= 5 * 1024 * 1024 ){

						// FormDate 是 ajax 提供的接口，可以模拟键值对向后台提交参数
						// FormDate 最大的优势是不但能提交文本数据，还能提交二进制数据，也就是可以上传文件参数

						// 使用 FormDate 对象上传 excel 文件到服务器
						var formDate = new FormData();
						formDate.append("activityFile" , activityFile)

                        $.ajax({
                            url : 'workbench/activity/importActivity.do',
							processData:false, // 设置 ajax 向后台提交请求参数之前，是否统一把参数转换为字符串，默认 true 进行转换
							contentType:false, // 设置 ajax 向后台提交请求参数之前，是否统一把参数按照 urlencoded 进行编码 默认 true 进行
                            dataType : 'json',
                            type : 'post',
                            data: formDate,
                            success : function (data) {
								if(data.code == 1){
									alert("导入成功！");
									queryActivityByCondition(1,getPageSize());
									$("#importActivityModal").modal('hide');
								}else{
									alert(data.message);
								}
                            }
                        })
                    }else{
                        alert("文件大小超过 5MB 无法导入！ ");
                    }
				}else{
					alert("删除文件类型不匹配，只能上传.xls格式的excel文件！");
				}

			});

			// 点击市场活动名称，跳转到该市场活动的详细信息页码 detail.jsp
			// 市场活动数据的市场活动名称绑定点击事件
			$("#tBody").on('click' , '.detailBtn' , function () {
				var id = $(this).parent().siblings().find("input[type=checkbox]").val();
				window.location.href = 'workbench/activity/detail.do?id='+id;
			})

		});

		// 根据条件查询，包含页码切换
		function queryActivityByCondition(pageNo,pageSize){
			var name = $("#query-name").val();
			var owner = $("#query-owner").val();
			var startDate = $("#query-startDate").val();
			var endDate = $("#query-endDate").val();
			$.ajax({
				url:'workbench/activity/queryActivityByConditionForPage.do',
				data:{
					name:name,
					owner:owner,
					startDate:startDate,
					endDate:endDate,
					pageNo:pageNo,
					pageSize:pageSize
				},
				type:'get',
				dataType:'json',

				success:function(data){
					if(data.totalCount == 0){
						alert("未查询到该条件的市场活动相关记录！");
						return;
					}
					// 显示数据总条数
					$("#page-totalCount").text(data.totalCount);
					// 显示当前页的数据
					$(".activeTr").eq(0).siblings().remove();
					var activityTr = $(".activeTr").eq(0).clone();
					$.each(data.activityList,function(index , activity){
						if(index == 0){
							$(".activeTr").eq(0).children("td").eq(0).find("input").val(activity.id);
							$(".activeTr").eq(0).children("td").eq(1).find("a").text(activity.name);
							$(".activeTr").eq(0).children("td").eq(2).text(activity.owner);
							$(".activeTr").eq(0).children("td").eq(3).text(activity.startDate);
							$(".activeTr").eq(0).children("td").eq(4).text(activity.endDate);
						}else{
							var newTr = activityTr.clone();
							newTr.children("td").eq(0).find("input").val(activity.id);
							newTr.children("td").eq(1).find("a").text(activity.name);
							newTr.children("td").eq(2).text(activity.owner);
							newTr.children("td").eq(3).text(activity.startDate);
							newTr.children("td").eq(4).text(activity.endDate);
							$(".activeTable").append(newTr);
						}
					})

					// 重置所有已选择的内容
					$("#tBody input[type='checkbox']").prop("checked" , false);

					// 根据查询到的数据更新页码
					$("#demo_page1").bs_pagination({
						currentPage:pageNo, // 当前页码 pageNo
						totalRows:data.totalCount, // 数据总条数 totalCount
						rowsPerPage:pageSize, // 每页显示的数据条数  pageSize
						totalPages:data.totalPage, // 数据总页数，必填参数，没有默认值 totalPageCount

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
							queryActivityByCondition(pageObj.currentPage,pageObj.rowsPerPage);

						}
					})

				}
			})
		}

		// 获取当前插件内容设置的每页数据的显示条数，bs_pagination_master 插件提供的方法
		function getPageSize(){
			return $("#demo_page1").bs_pagination('getOption' , 'rowsPerPage');
		};

		/**
		 * 发起批量删除请求
		 * @param ids
		 */
		function deleteActivityByIds(ids){
			$.ajax({
				url : 'workbench/activity/deleteActivityByIds.do',
				data : ids ,
				dataType : 'json',
				type : 'post',
				success : function (data) {
					if(data.code == 1){
						alert("删除成功，共删除" + data.returnData + "条市场活动数据！")
						// 更新列表数据
						queryActivityByCondition(1,getPageSize());
					}else{
						alert(data.message);
					}
				}
			})
		}


	</script>
</head>
<body>

	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" id="createActivityForm" role="form">
					
						<div class="form-group">
							<label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" name="owner" id="create-marketActivityOwner">
									<option value="0">请选择</option>
									<c:forEach items="${requestScope.requestUsers}" var="user">
										<option value="${user.id}">${user.name}</option>
									</c:forEach>
								</select>
							</div>
                            <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" name="name" id="create-marketActivityName">
                            </div>
						</div>
						
						<div class="form-group">
							<label for="create-startDate" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control myDate" name="startDate" id="create-startDate" readonly>
							</div>
							<label for="create-endDate" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control myDate" name="endDate" id="create-endDate" readonly>
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" name="cost" id="create-cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" name="description" id="create-description"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveCreateActivityBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改市场活动的模态窗口 -->
	<div class="modal fade" id="editActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" id="editActivityForm" role="form">

						<input type="hidden" id="edit-id"/>
					
						<div class="form-group">
							<label for="edit-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-owner" name="userId">
									<option value="0">请选择</option>
									<c:forEach items="${requestScope.requestUsers}" var="user">
										<option value="${user.id}">${user.name}</option>
									</c:forEach>
								</select>
							</div>
                            <label for="edit-name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-name" value="发传单">
                            </div>
						</div>

						<div class="form-group">
							<label for="edit-startDate" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-startDate" value="2020-10-10">
							</div>
							<label for="edit-endDate" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-endDate" value="2020-10-20">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost" value="5,000">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description">市场活动Marketing，是指品牌主办或参与的展览会议与公关市场活动，包括自行主办的各类研讨会、客户交流会、演示会、新产品发布会、体验会、答谢会、年会和出席参加并布展或演讲的展览会、研讨会、行业交流会、颁奖典礼等</textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="editActivityBtn">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 导入市场活动的模态窗口 -->
    <div class="modal fade" id="importActivityModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 85%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">导入市场活动</h4>
                </div>
                <div class="modal-body" style="height: 350px;">
                    <div style="position: relative;top: 20px; left: 50px;">
                        请选择要上传的文件：<small style="color: gray;">[仅支持.xls]</small>
                    </div>
                    <div style="position: relative;top: 40px; left: 50px;">
                        <input type="file" id="activityFile">
                    </div>
                    <div style="position: relative; width: 400px; height: 320px; left: 45% ; top: -40px;" >
                        <h3>重要提示</h3>
                        <ul>
                            <li>操作仅针对Excel，仅支持后缀名为XLS的文件。</li>
                            <li>给定文件的第一行将视为字段名。</li>
                            <li>请确认您的文件大小不超过5MB。</li>
                            <li>日期值以文本形式保存，必须符合yyyy-MM-dd格式。</li>
                            <li>日期时间以文本形式保存，必须符合yyyy-MM-dd HH:mm:ss的格式。</li>
                            <li>默认情况下，字符编码是UTF-8 (统一码)，请确保您导入的文件使用的是正确的字符编码方式。</li>
                            <li>建议您在导入真实数据之前用测试文件测试文件导入功能。</li>
                        </ul>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button id="importActivityBtn" type="button" class="btn btn-primary">导入</button>
                </div>
            </div>
        </div>
    </div>
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>市场活动列表</h3>
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
				      <input class="form-control" id="query-name" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" id="query-owner" type="text">
				    </div>
				  </div>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">开始日期</div>
					  <input class="form-control myDate" readonly type="text" id="query-startDate" />
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
					  <input class="form-control myDate" readonly type="text" id="query-endDate">
				    </div>
				  </div>
				  
				  <button type="button" class="btn btn-default" id="queryActivityBtn">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="createActivityBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="updateActivityBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteActivityBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				<div class="btn-group" style="position: relative; top: 18%;">
                    <button type="button" class="btn btn-default" id="importActivityFileBtn"><span class="glyphicon glyphicon-import"></span> 上传列表数据（导入）</button>
                    <button id="exportActivityAllBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（批量导出）</button>
                    <button id="exportActivityXzBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（选择导出）</button>
                </div>
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover activeTable">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="activityAllBtn"/></td>
							<td>名称</td>
                            <td>所有者</td>
							<td>开始日期</td>
							<td>结束日期</td>
						</tr>
					</thead>
					<tbody id="tBody">
						<tr class="active activeTr">
							<td><input type="checkbox"/></td>
							<td><a class="detailBtn" style="text-decoration: none; cursor: pointer;">发传单</a></td>
                            <td>zhangsan</td>
							<td>2020-10-10</td>
							<td>2020-10-20</td>
						</tr>
					</tbody>
				</table>
			</div>

			<%-- 分页显示插件 bs_pagination-master --%>
			<div id="demo_page1"></div>

			<%-- 废弃分页 --%>
			<%--<div style="height: 50px; position: relative;top: 30px;">
                        <div>
                            <button type="button" class="btn btn-default" style="cursor: default;">共<b id="page-totalCount">50</b>条记录</button>
                        </div>
                        <div class="btn-group" style="position: relative;top: -34px; left: 110px;">
                            <button type="button" class="btn btn-default" style="cursor: default;">显示</button>
                            <div class="btn-group">
                                <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
                                    10
                                    <span class="caret"></span>
                                </button>
                                <ul class="dropdown-menu" role="menu">
                                    <li><a href="javascript:;">20</a></li>
                                    <li><a href="javascript:;">30</a></li>
                                </ul>
                            </div>
                            <button type="button" class="btn btn-default" style="cursor: default;">条/页</button>
                        </div>


                        <div style="position: relative;top: -88px; left: 285px;">
                            <nav>
                                <ul class="pagination">
                                    <li class="disabled"><a href="#">首页</a></li>
                                    <li class="disabled"><a href="#">上一页</a></li>
                                    <li class="active"><a href="#" >1</a></li>
                                    <li><a href="#">2</a></li>
                                    <li><a href="#">3</a></li>
                                    <li><a href="#">4</a></li>
                                    <li><a href="#">5</a></li>
                                    <li><a href="#">下一页</a></li>
                                    <li class="disabled"><a href="#">末页</a></li>
                                </ul>
                            </nav>
                        </div>
                    </div>--%>
			
		</div>
		
	</div>
</body>
</html>