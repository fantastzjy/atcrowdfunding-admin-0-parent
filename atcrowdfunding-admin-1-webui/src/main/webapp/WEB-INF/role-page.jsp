<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="UTF-8">
<%@ include file="/WEB-INF/include-head.jsp" %>
<link rel="stylesheet" href="css/pagination.css"/>
<script type="text/javascript" src="script/jquery.pagination.js"></script>
<script type="text/javascript" src="script/my-role.js"></script>
<script type="text/javascript">
    $(function () {
        // 调用分页参数初始化方法
        initGlobalVariable();

        // 执行分页
        showPage();

        $("#searchBtn").click(function () {
            // 在单击响应函数中获取文本框中输入的数据,要去除空格
            var keyword = $.trim($("#keywordInput").val());

            // 验证输入数据是否有效
            // keyword == ""等价于keyword.length==0
            if (keyword == null || keyword == "") {
                // 如果无效，提示，停止函数执行
                layer.msg("请输入关键词！");
                return;
            }

            // 如果有效，赋值给window.keyword
            window.keyword = keyword;

            // 调用showPage()重新分页
            showPage();
        });

        // 全选/全部选
        $("#summaryBox").click(function () {
            // 1.获取当前checkbox的选中状态
            var currentStatus = this.checked;
            // 2.设置itemBox的选中状态，把所有的状态都设置一遍
            $(".itemBox").prop("checked", currentStatus);

        });
        // 给批量删除按钮绑定单击响应函数
        $("#batchRemoveBtn").click(function () {
            // 获取被选中的itemBox数组长度
            var length = $(".itemBox:checked").length;
            // 如果长度为0，说明没有选择itemBox
            if (length == 0) {
                layer.msg("请选择至少一条进行删除！");
                return;
            }

            // 在全局作用域内创建roleIdArray   下面要是用window.roleIdArray需要重新创建，因为这是点击才生成
            window.roleIdArray = new Array();
            // 遍历$(".itemBox:checked")
            $(".itemBox:checked").each(function () {
                // 通过checkbox的roleid属性获取roleId值，自定义属性不能通过dom对象获取
                var roleId = $(this).attr("roleid");

                // 存入数组
                window.roleIdArray.push(roleId);
            });

            // 调用函数打开模态框
            showRemoveConfirmModal();
        });

        // 给确认模态框中的OK按钮绑定单击响应函数
        $("#confirmModalBtn").click(function () {
            //数组要进行转化为JSON字符串
            var roleId = window.roleIdArray;
            var resquestBody = JSON.stringify(roleId);

            $.ajax({
                "url": "role/batch/remove.json",
                "type": "post",
                "data": resquestBody,
                "contentType": "application/json;charset=UTF-8",
                "dataType": "json",
                "success": function (response) {
                    var result = response.result;
                    if (result == "SUCCESS") {
                        layer.msg("操作成功！");

                        // 如果删除成功，则重新调用分页方法
                        showPage();
                        // $("#summaryBox").prop("checked",false);
                    }

                    if (result == "FAILED") {
                        layer.msg(response.message);
                    }

                    // 不管成功还是失败，都需要关掉模态框
                    $("#confirmModal").modal("hide");

                },
                "error": function (response) {
                    layer.msg(response.message);
                }

            });
        });


//		只能生效一次，重新分页（也就是重新生成这些动态元素）后失效
// 		$(".removeBtn").click(function(){

// 			// 获取当前记录的roleId
// 			var roleId = $(this).attr("roleId");

// 			// 存入全局变量数组
// 			window.roleIdArray = new Array();

// 			window.roleIdArray.push(roleId);

// 			// 打开模态框（后续所有操作都和批量删除一样）
// 			showRemoveConfirmModal();

// 		});

        // 针对.removeBtn这样动态生成的元素对象使用on()函数方式绑定单击响应函数
        // $("动态元素所“依附”的静态元素").on("事件类型","具体要绑定事件的动态元素的选择器", 事件响应函数);
        // removeBtn    这里用的选择器是类选择器
        $("#roleTableBody").on("click", ".removeBtn", function () {
            // 获取当前记录的roleId
            var roleId = $(this).attr("roleId");

            // 存入全局变量数组
            window.roleIdArray = new Array();

            window.roleIdArray.push(roleId);

            // 打开模态框（后续所有操作都和批量删除一样）
            showRemoveConfirmModal();
        });

        $("#addBtn").click(function () {
            $("#addModal").modal("show");
        });

        $("#addModalBtn").click(function () {
            // 通过id选择器有id就可以找到获取其内容
            var roleName = $.trim($("#roleNameInput").val());

            // 1.收集文本框内容
            if (roleName == null || roleName == "") {
                layer.msg("请输入有效角色名称！")
                return;
            }

            // 2.发送请求
            $.ajax({
                "url": "role/save/role.json",
                "type": "post",
                "data": {
                    "roleName": roleName
                },
                "dataType": "json",
                "success": function (response) {

                    var result = response.result;

                    if (result == "SUCCESS") {
                        layer.msg("操作成功！");

                        // 3.操作成功重新分页
                        // 前往最后一页
                        window.pageNum = 999999;
                        showPage();
                    }

                    if (result == "FAILED") {
                        layer.msg(response.message);
                    }

                    // 4.不管成功还是失败，关闭模态框
                    $("#addModal").modal("hide");

                    // 5.清理本次在文本框填写的数据
                    $("#roleNameInput").val("");

                },
                "error": function (response) {
                    layer.msg(response.message);
                }
            });

        });

        //类选择器和 id选择器都可以
        $("#roleTableBody").on("click", ".editBtn", function () {
            // 1.获取当前按钮的roleId
            window.roleId = $(this).attr("roleId");

            // 2.获取当前按钮所在行的roleName
            var roleName = $(this).parents("tr").children("td:eq(2)").text();

            // 3.修改模态框中文本框的value值，目的是在显示roleName
            $("#roleNameInputEdit").val(roleName);

            // 4.打开模态框
            $("#editModal").modal("show");
        });

        $("#editModalBtn").click(function () {
            // 1.获取文本框值
            var roleName = $.trim($("#roleNameInputEdit").val());

            if (roleName == null || roleName == "") {
                layer.msg("请输入有效角色名称！");

                return;
            }
            // 2.发送请求
            $.ajax({
                "url": "role/update/role.json",
                "type": "post",
                "data": {
                    "id": window.roleId,
                    "name": roleName
                },
                "dataType": "json",
                "success": function (response) {
                    var result = response.result;

                    if (result == "SUCCESS") {
                        layer.msg("操作成功！");

                        // 3.操作成功重新分页
                        showPage();
                    }

                    if (result == "FAILED") {
                        layer.msg(response.message);
                    }

                    // 4.不管成功还是失败，关闭模态框
                    $("#editModal").modal("hide");

                }
            });


        });


    });
</script>
<body>

<%@ include file="/WEB-INF/include-nav.jsp" %>
<div class="container-fluid">
    <div class="row">
        <%@ include file="/WEB-INF/include-sidebar.jsp" %>
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title">
                        <i class="glyphicon glyphicon-th"></i> 数据列表
                    </h3>
                </div>
                <div class="panel-body">
                    <form class="form-inline" role="form" style="float: left;">
                        <div class="form-group has-feedback">
                            <div class="input-group">
                                <div class="input-group-addon">查询条件</div>
                                <input id="keywordInput" class="form-control has-success" type="text"
                                       placeholder="请输入查询条件">
                            </div>
                        </div>
                        <button id="searchBtn" type="button" class="btn btn-warning">
                            <i class="glyphicon glyphicon-search"></i> 查询
                        </button>
                    </form>
                    <button id="batchRemoveBtn" type="button" class="btn btn-danger"
                            style="float: right; margin-left: 10px;">
                        <i class=" glyphicon glyphicon-remove"></i> 删除
                    </button>
                    <button id="addBtn" type="button" class="btn btn-primary"
                            style="float: right;">
                        <i class="glyphicon glyphicon-plus"></i> 新增
                    </button>
                    <br>
                    <hr style="clear: both;">
                    <div class="table-responsive">
                        <table class="table  table-bordered">
                            <thead>
                            <tr>
                                <th width="30">#</th>
                                <th width="30"><input id="summaryBox" type="checkbox"></th>
                                <th>名称</th>
                                <th width="100">操作</th>
                            </tr>
                            </thead>
                            <tbody id="roleTableBody">
                            <%--这里显示内容--%>
                            </tbody>
                            <tfoot>
                            <tr>
                                <td colspan="6" align="center">
                                    <div id="Pagination" class="pagination">
                                        <!-- 这里显示分页 -->
                                    </div>
                                </td>
                            </tr>
                            </tfoot>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/include-modal-role-confirm.jsp" %>
<%@ include file="/WEB-INF/include-modal-role-add.jsp" %>
<%@ include file="/WEB-INF/include-modal-role-edit.jsp" %>
</body>
</html>