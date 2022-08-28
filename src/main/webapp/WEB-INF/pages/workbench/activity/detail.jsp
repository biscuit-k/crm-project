<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=utf-8" language="java" %>

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

	<script type="text/javascript">

		//默认情况下取消和保存按钮是隐藏的
		var cancelAndSaveBtnDefault = true;

		$(function(){
			$("#remark").focus(function(){
				if(cancelAndSaveBtnDefault){
					//设置remarkDiv的高度为130px
					$("#remarkDiv").css("height","130px");
					//显示
					$("#cancelAndSaveBtn").show("2000");
					cancelAndSaveBtnDefault = false;
				}
			});

			$("#cancelBtn").click(function(){
				//显示
				$("#cancelAndSaveBtn").hide();
				//设置remarkDiv的高度为130px
				$("#remarkDiv").css("height","90px");
				cancelAndSaveBtnDefault = true;
				// 清空内容
				$("#remark").val("");
			});

			$(".remarkDiv").mouseover(function(){
				$(this).children("div").children("div").show();
			});

			$(".remarkDiv").mouseout(function(){
				$(this).children("div").children("div").hide();
			});

			$(".myHref").mouseover(function(){
				$(this).children("span").css("color","red");
			});

			$(".myHref").mouseout(function(){
				$(this).children("span").css("color","#E6E6E6");
			});

			// 页码加载完成后加载当前是否活动的备注信息
			loadActivityRemark();

			// 为保存备注按钮绑定点击事件
			$(".saveActivityRemarkBtn").click(function () {
				// 获取参数
				var activityId = $("input[name=activityId]").val();
				var noteContent = $("#remark").val();
				// 判断备注内容是否为空
				if(noteContent != null && noteContent != ""){
					$.ajax({
						url : 'workbench/activity/saveCreateActivityRemark.do',
						data : {
							activityId : activityId,
							noteContent : noteContent
						},
						type : 'post',
						dataType: 'json',
						success : function(data){
							if(data.code == 1){
								alert("备注成功！");
								loadActivityRemark();
								$("#cancelBtn").click();
							}else{
								alert(data.message);
							}
						}
					})
				}
			})

			// 为每个备注信息的修改按钮添加绑定事件
			$(".activityRemarkDiv").on( "click" , ".edit-activityRemark" , function () {
				var id = $(this).parent().parent().parent().attr("id");
				$("#editRemarkModal").modal("show");
				// 获取原本备注内容
				var noteContent = $(this).parent().parent().find(".noteContent").text();

				// 将当前的备注id赋值给隐藏域
				$("#remarkId").val(id);
				// 将原本内容填充只模态框内
				$("#edit-noteContent").val(noteContent);

			} )

			// 给确认修改备注信息绑定点击事件
			$("#updateRemarkBtn").click(function(){
				var noteContent = $("#edit-noteContent").val();
				var id = $("#remarkId").val();
				// 要修改的内容不为空则向服务器发起修改请求
				if(noteContent != null & noteContent != ""){
					$.ajax({
						url : 'workbench/activity/saveEditActivityRemark.do',
						data : {
							id : id,
							noteContent : noteContent
						},
						dataType : 'json',
						type : 'post',
						success : function(data){
							if(data.code){
								alert("修改备注信息成功!");
								// 重写加载备注信息
								loadActivityRemark();
								$("#editRemarkModal").modal("hide");
							}else{
								alert(data.message);
							}
						}
					})
				}else{
					alert("备注内容不可为空！")
				}
			});

			// 为每个备注信息的删除按钮添加绑定事件
			$(".activityRemarkDiv").on( 'click' , '.delete-activityRemark' , function () {
				var id = $(this).parent().parent().parent().attr("id");
				if(confirm("确认删除此条市场活动备注信息吗？")){
					$.ajax({
						url : 'workbench/activity/saveDeleteActivityRemarkById.do',
						data : {
							id : id
						},
						dataType : 'json',
						type : 'post',
						success : function(data){
							if(data.code){
								alert("删除市场活动备注信息成功!");
								// 重写加载备注信息
								loadActivityRemark();
							}else{
								alert(data.message);
							}
						}
					})
				}
			} );



		});

		// 页码加载完成后加载当前是否活动的备注信息
		function loadActivityRemark(){
			// 获取当前市场活动的 id
			var activityId = $("input[name=activityId]").val();
			// 获取备注内容元素
			var activityRemarkDiv = $(".activityRemark").eq(0);
			activityRemarkDiv.show();
			// 删除除第一个备注元素以外的所有元素
			$(".activityRemark:not(:eq(0))").remove();

			// 向服务器发起请求获取当前市场活动的所有备注信息
			$.ajax({
				url : 'workbench/activity/queryActivityRemarkListByActivityId.do',
				data : {
					activityId : activityId
				},
				type : 'get' ,
				dataType : 'json' ,
				success : function (data) {
					if(data.code == 1){
						for (let i = 0; i < data.returnData.length; i++) {
							if(i == 0){
								activityRemarkDiv.attr("id" , data.returnData[i].id);
								activityRemarkDiv.find(".noteContent").text(data.returnData[i].noteContent);
								activityRemarkDiv.find(".activityName").text(data.returnData[i].activityId);
								if(data.returnData[i].editFlag == 1){
									activityRemarkDiv.find(".activityRemarkCrateTimeAndCreateBy").text(+" "+data.returnData[i].editTime +" 由 " + data.returnData[i].editBy + " 修改");
								}else{
									activityRemarkDiv.find(".activityRemarkCrateTimeAndCreateBy").text(+" "+data.returnData[i].createTime +" 由 " + data.returnData[i].createBy  + " 创建");
								}
							}else{
								var cloneActivityRemarkDiv =  activityRemarkDiv.clone(true);
								cloneActivityRemarkDiv.attr("id" , data.returnData[i].id);
								cloneActivityRemarkDiv.find(".noteContent").text(data.returnData[i].noteContent);
								cloneActivityRemarkDiv.find(".activityName").text(data.returnData[i].activityId);
								if(data.returnData[i].editFlag == 1){
									cloneActivityRemarkDiv.find(".activityRemarkCrateTimeAndCreateBy").text(+" "+data.returnData[i].editTime +" 由 " + data.returnData[i].editBy + " 修改");
								}else{
									cloneActivityRemarkDiv.find(".activityRemarkCrateTimeAndCreateBy").text(+" "+data.returnData[i].createTime +" 由 " + data.returnData[i].createBy  + " 创建");
								}
								$(".activityRemarkDiv").append(cloneActivityRemarkDiv);
							}
						}
						var createActivityRemarkDiv = $(".createActivityRemarkDiv");
						$(".activityRemarkDiv").append(createActivityRemarkDiv);
					}else{
						activityRemarkDiv.hide();
					}
				}
			})
		}

	</script>

</head>
<body>
	
	<!-- 修改市场活动备注的模态窗口 -->
	<div class="modal fade" id="editRemarkModal" role="dialog">
		<%-- 备注的id --%>
		<input type="hidden" id="remarkId">
        <div class="modal-dialog" role="document" style="width: 40%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">修改备注</h4>
                </div>
                <div class="modal-body">
                    <form class="form-horizontal" role="form">
                        <div class="form-group">
                            <label for="edit-noteContent" class="col-sm-2 control-label">内容</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="edit-noteContent"></textarea>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
                </div>
            </div>
        </div>
    </div>

    

	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>市场活动-发传单 <small>${requestScope.activity.startDate} ~ ${requestScope.activity.endDate}</small></h3>
		</div>
		
	</div>
	
	<br/>
	<br/>
	<br/>

	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<input type="hidden" name="activityId" value="${requestScope.activity.id}">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.activity.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${requestScope.activity.name}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>

		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">开始日期</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.activity.startDate}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">结束日期</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${requestScope.activity.endDate}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">成本</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.activity.cost}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${requestScope.activity.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${requestScope.activity.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${empty requestScope.activity.editBy?"无修改记录":requestScope.activity.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${requestScope.activity.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${requestScope.activity.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
	</div>
	
	<!-- 备注 -->
	<div class="activityRemarkDiv" style="position: relative; top: 30px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>
		
		<!-- 市场活动备注模板 -->
		<div class="remarkDiv activityRemark" style="height: 60px;">
			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5 class="noteContent">哎呦！</h5>
				<font color="gray">市场活动</font> <font color="gray">-</font> <b class="activityName">发传单</b> <small style="color: gray;" class="activityRemarkCrateTimeAndCreateBy"> 2017-01-22 10:10:10 由zhangsan</small>
				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
					<a class="myHref edit-activityRemark" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<a class="myHref delete-activityRemark" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
				</div>
			</div>
		</div>
		



		
		<div id="remarkDiv" class="createActivityRemarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button type="button" class="btn btn-primary saveActivityRemarkBtn">保存</button>
				</p>
			</form>
		</div>
	</div>
	<div style="height: 200px;"></div>
</body>
</html>