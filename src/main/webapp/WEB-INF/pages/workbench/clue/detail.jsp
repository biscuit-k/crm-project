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
				$(".create-clueRemark").val("")
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





			loadClueRemark();

			// 为点击删除备注信息绑定点击事件
			$("#clueRemarkParent").on( "click" , ".clueRemark-remove" , function() {
				var id = $(this).parent().parent().parent().parent().attr("id");
				if(confirm("确认删除此条备注信息吗？")){
					$.ajax({
						url : 'workbench/clue/saveDeleteClueRemarkById.do',
						data : {
							id : id
						},
						dataType : 'json',
						type : 'post',
						success : function (data){
							if(data.code == 1){
								alert("删除备注信息成功！");
								loadClueRemark();
							}else{
								alert(data.message);
							}
						}
					});
				}
			});

			// 为点击修改备注信息绑定点击事件
			$("#clueRemarkParent").on( "click" , ".clueRemark-edit" , function() {
				var id = $(this).parent().parent().parent().parent().attr("id");
				$("#bundModal").modal('show');
			});



			// 为新增备注信息按钮绑定单击事件
			$(".saveCreateBtn").click(function() {
				var noteContent = $.trim($(".create-clueRemark").val());
				var clueId = $("#clueId").val();
				if(noteContent != null && noteContent != ""){
					$.ajax({
						url : 'workbench/clue/saveCreateClueRemark.do',
						data : {
							noteContent : noteContent,
							clueId : clueId
						},
						dataType : 'json',
						type : 'post',
						success : function (data){
							if(data.code == 1){
								alert("备注添加成功！");
								$(".create-clueRemark").val("")
								loadClueRemark();
							}else{
								alert(data.message);
							}
						}
					});
				}else{
					alert("备注内容不可为空！");
					$(".create-clueRemark").focus();
				}
			});

			// 点击添加线索关联的市场活动信息
			$("#relevancyActivity").click(function (){
				loadClueActivityLikeNameAndNotClueId(null);
				$("#bundModal").modal('show');
			});

			// 点击确认关联按钮
			$(".saveEditBtn").click(function (){
				var trList = $("#tBody-act-modal input[type=checkbox]:checked");
				var clueId = "clueId="+$("#clueId").val();
				if(trList.size() >= 1){
					var activityIds = "";
					$.each(trList , function (index , obj){
						activityIds += "activityIds=" + $(obj).val() + "&";
					})
					activityIds = activityIds.substring(0 , activityIds.length -1);
					var data = activityIds + "&" + clueId;
					if(confirm("确认为当前线索绑定当前选中的市场活动信息吗？")){
						$.ajax({
							url : 'workbench/clue/saveCreateClueActivityRelation.do',
							data : data,
							dataType : 'json',
							type : 'post',
							success : function (data){
								if(data.code == 1){
									alert("关联成功！");
									loadClueActivity();
									$("#bundModal").modal('hide');
								}else{
									alert(data.message);
								}
							}
						});
					}
				}else{
					alert("至少选中一条需要与线索关联的市场活动！");
				}
			});

			// 根据名称进行模糊查询
			$("#activityName").blur(function (){
				if(this.value != null && this.value != ""){

					var name = this.value;
					loadClueActivityLikeNameAndNotClueId(name);
				}
			})


			// 加载该线索关联的市场活动信息
			loadClueActivity();

			// 解除当前线索与市场活动的关联
			$("#tBody-act").on("click" , "a" , function (){
				var activityId = $(this).parent().parent().attr("id");
				var clueId = $("#clueId").val();
				if(confirm("确认接触此条市场活动与线索的关联吗？")){
					$.ajax({
						url : 'workbench/clue/saveDeleteClueActivityRelationByActivityIdAndClueId.do',
						data : {
							activityId : activityId,
							clueId : clueId
						},
						dataType : 'json',
						type : 'post',
						success : function (data){
							if(data.code == 1){
								alert("解绑成功！");
								loadClueActivity();
							}else{
								alert(data.message);
							}
						}
					})
				}
			});


			// 点击线索转换为客户按钮
			$("#clueConvertBtn").click(function (){
				var id = $("#clueId").val();
				window.location.href = "workbench/clue/convert.do?id="+id;
			});



		});

		// 加载当前线索的评价
		function loadClueRemark(){
			var clueId = $("#clueId").val();
			var clueRemark = $(".clueRemark").eq(0);
			clueRemark.show();
			$(".clueRemark:not(:eq(0))").remove();
			$.ajax({
				url : 'workbench/clue/queryAllClueRemarkByClueId.do',
				data : {
					clueId : clueId
				},
				dataType : 'json',
				type : 'get',
				success : function (data){
					// 根据备注数据进行显示
					var clueRemarkList = data.returnData;
					if(clueRemarkList != null && clueRemarkList.length > 0){
						for (var i = 0; i < clueRemarkList.length; i++){
							var cr = null;
							if(i == 0){
								cr = clueRemark;
							}else{
								cr = clueRemark.clone(true);
							}
							cr.attr("id" , clueRemarkList[i].id);
							cr.find("img").attr("title",clueRemarkList[i].createBy);
							cr.find("h5").text(clueRemarkList[i].noteContent);
							cr.find("b").text($("#fullnameAll").text() + "-" + $("#company").text());
							if(clueRemarkList[i].editFlag == 0){
								cr.find("small").text(" "+clueRemarkList[i].createTime + " 由 "+clueRemarkList[i].createBy+" 创建");
							}else{
								cr.find("small").text(" "+clueRemarkList[i].editTime + " 由 "+clueRemarkList[i].editBy+" 修改");
							}
							$("#clueRemarkParent").append(cr);
						}
						var createClueRemarkFrom = $(".createClueRemark");
						$("#clueRemarkParent").append(createClueRemarkFrom);
					}else{
						clueRemark.hide();
					}


				}
			})
		}

		// 加载当前线索关联的市场活动
		function loadClueActivity(){
			var clueId = $("#clueId").val();

			$.ajax({
				url : 'workbench/clue/queryMoreActivityForClueDetailByClueId.do',
				data : {
					clueId : clueId
				},
				dataType : 'json',
				type : 'get',
				success : function (data){
					// 根据返回的数据页码进行显示
					var activityList = data.returnData;
					var actTr = $("#tBody-act").find("tr").eq(0);
					actTr.show();
					$("#tBody-act").find("tr:not(:eq(0))").remove();
					if(activityList != null && activityList.length > 0){
						for (var i = 0; i < activityList.length; i++){
							var t = null;
							if(i == 0){
								t = actTr;
							}else{
								t = actTr.clone(true);
							}
							t.attr("id",activityList[i].id);
							t.find("td").eq(0).text(activityList[i].name);
							t.find("td").eq(1).text(activityList[i].startDate);
							t.find("td").eq(2).text(activityList[i].endDate);
							t.find("td").eq(3).text(activityList[i].owner);
							$("#tBody-act").append(t);
						}
					}else{
						actTr.hide();
					}

				}
			});
		}

		// 可以根据名称进行模糊查询未关联的市场活动信息
		function loadClueActivityLikeNameAndNotClueId(name){
			var clueId = $("#clueId").val();
			$.ajax({
				url : 'workbench/clue/queryMoreActivityForClueDetailNotActivityId.do',
				data : {
					clueId : clueId,
					name : name
				},
				dataType : 'json',
				type : 'get',
				success : function (data){
					// 根据备注数据进行显示
					var activityList = data.returnData;
					var actTr = $("#tBody-act-modal").find("tr").eq(0);
					actTr.show();
					$("#tBody-act-modal tr:not(:eq(0))").remove();
					if(activityList != null && activityList.length > 0){
						for (var i = 0; i < activityList.length; i++){
							var t = null;
							if(i == 0){
								t = actTr;
							}else{
								t = actTr.clone(true);
							}
							t.find("td").eq(0).find("input").val(activityList[i].id);
							t.find("td").eq(0).find("input").prop("checked",false);
							t.find("td").eq(1).text(activityList[i].name);
							t.find("td").eq(2).text(activityList[i].startDate);
							t.find("td").eq(3).text(activityList[i].endDate);
							t.find("td").eq(4).text(activityList[i].owner);
							$("#tBody-act-modal").append(t);
						}
					}else{
						actTr.hide();
						if(confirm("未查询到匹配的市场活动信息，是否查询所有数据？")){
							loadClueActivityLikeNameAndNotClueId(null);
						}
					}


				}
			})
		}

	</script>

</head>
<body>

	<<input type="hidden" id="clueId" value="${requestScope.clue.id}"/>

	<!-- 关联市场活动的模态窗口 -->
	<div class="modal fade" id="bundModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">关联市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" id="activityName" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td><input type="checkbox"/></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
								<td></td>
							</tr>
						</thead>
						<tbody id="tBody-act-modal">
							<tr>
								<td><input type="checkbox"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>
							<tr>
								<td><input type="checkbox"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-primary saveEditBtn">关联</button>
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
			<h3>${requestScope.clue.fullname}${requestScope.clue.appellation} <small>${requestScope.clue.company}</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" id="clueConvertBtn"><span class="glyphicon glyphicon-retweet"></span> 转换</button>
			
		</div>
	</div>
	
	<br/>
	<br/>
	<br/>

	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="fullnameAll">${requestScope.clue.fullname}${requestScope.clue.appellation}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${requestScope.clue.owner}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">公司</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="company">${empty requestScope.clue.company?"暂无资料":requestScope.clue.company}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">职位</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${empty requestScope.clue.job?"暂无资料":requestScope.clue.job}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">邮箱</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${empty requestScope.clue.email?"暂无资料":requestScope.clue.email}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">公司座机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${empty requestScope.clue.phone?"暂无资料":requestScope.clue.phone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">公司网站</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${empty requestScope.clue.website?"暂无资料":requestScope.clue.website}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">手机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${empty requestScope.clue.mphone?"暂无资料":requestScope.clue.mphone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">线索状态</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${empty requestScope.clue.state?"未填写":requestScope.clue.state}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">线索来源</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${empty requestScope.clue.source?"未填写":requestScope.clue.source}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${requestScope.clue.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${requestScope.clue.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${empty requestScope.clue.editBy?"尚未修改":requestScope.clue.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${empty requestScope.clue.editTime?"":requestScope.clue.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${empty requestScope.clue.description?"尚未填写":requestScope.clue.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">联系纪要</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${empty requestScope.clue.contactSummary?"尚未填写":requestScope.clue.contactSummary}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 90px;">
			<div style="width: 300px; color: gray;">下次联系时间</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${empty requestScope.clue.nextContactTime?"暂未约定":requestScope.clue.nextContactTime}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 100px;">
            <div style="width: 300px; color: gray;">详细地址</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b>
					${empty requestScope.clue.address?"尚未填写":requestScope.clue.address}
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
	</div>
	
	<!-- 备注 -->
	<div style="position: relative; top: 40px; left: 40px;" id="clueRemarkParent">
		<div class="page-header">
			<h4>备注</h4>
		</div>
		
		<!-- 备注1 -->
		<div class="remarkDiv clueRemark" style="height: 60px;">
			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>哎呦！</h5>
				<font color="gray">线索</font> <font color="gray">-</font> <b>李四先生-动力节点</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>
				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit clueRemark-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove clueRemark-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
				</div>
			</div>
		</div>
		

		
		<div id="remarkDiv" class="createClueRemark" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control create-clueRemark" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button type="button" class="btn btn-primary saveCreateBtn">保存</button>
				</p>
			</form>
		</div>
	</div>
	
	<!-- 市场活动 -->
	<div>
		<div style="position: relative; top: 60px; left: 40px;">
			<div class="page-header">
				<h4>市场活动</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>名称</td>
							<td>开始日期</td>
							<td>结束日期</td>
							<td>所有者</td>
							<td></td>
						</tr>
					</thead>
					<tbody id="tBody-act">
						<tr>
							<td>发传单</td>
							<td>2020-10-10</td>
							<td>2020-10-20</td>
							<td>zhangsan</td>
							<td><a href="javascript:void(0);"  style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>
						</tr>
					</tbody>
				</table>
			</div>
			
			<div>
				<a href="javascript:void(0);" id="relevancyActivity" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>关联市场活动</a>
			</div>
		</div>
	</div>
	
	
	<div style="height: 200px;"></div>
</body>
</html>