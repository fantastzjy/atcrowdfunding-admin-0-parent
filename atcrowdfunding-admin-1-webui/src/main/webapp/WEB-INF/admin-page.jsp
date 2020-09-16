<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="UTF-8">
<%@ include file="/WEB-INF/include-head.jsp" %>
<link rel="stylesheet" href="css/pagination.css"/>
<script type="text/javascript" src="script/jquery.pagination.js"></script>
<script type="text/javascript" src="script/my-admin.js"></script>
<script type="text/javascript">
    $(function () {
        layer.msg("别把自己删了哈！！！");
        // 初始化全局变量   中括号前面不要  点
        window.totalRecord = ${requestScope['PAGE-INFO'].total};
        window.pageSize = ${requestScope['PAGE-INFO'].pageSize};
        window.pageNum = ${requestScope['PAGE-INFO'].pageNum};

        // 每一次页面最初显示的时候都会把keyword设置为最新值
        //这里要封装成字符串  因为比如只写  aa 就会被当做是 aa 这个变量
        window.keyword = "${param.keyword}";

        // 对分页导航条显示进行初始化
        initPagination();

        // 全选/全不选功能
        $("#summaryBox").click(function () {

            // 获取当前#summaryBox的勾选状态
            // this代表当前多选框对象（DOM对象）
            // 	var checkStatus = this.checked
            // 使用checkStatus设置.itemBox的状态  对属性checked进行赋值
            //用attr进行赋值  只起一次作用，所以这里用prop
            $(".itemBox").prop("checked", this.checked);
        });

        // 给批量删除按钮绑定单击响应函数
        $("#batchRemoveBtn").click(function () {

            // 创建数组对象：存储adminId
            var adminIdArray = new Array();

            // 创建数组对象：存储loginAcct
            var loginAcctArray = new Array();

            // 通过jQuery选择器定位到所有被选中itemBox，然后遍历
            $(".itemBox:checked").each(function () {

                <%-- <input adminId="${admin.id }" class="itemBox" type="checkbox"> --%>
                // this.adminId拿不到值，原因是：this作为DOM对象无法读取HTML标签本身没有的属性
                // 将this转换为jQuery对象调用attr()函数就能够拿到值
                var adminId = $(this).attr("adminId");

                // 调用数组对象的push()方法将数据存入数组
                adminIdArray.push(adminId);
                // 得到账户的名字
                // <td><input type="checkbox" /></td><td>loginAcct</td>
                var loginAcct = $(this)                // 当前checkbox对象
                    .parent("td")    // 包含checkbox的td
                    .next()            // 当前td的下一个兄弟元素，也就是下一个td
                    .text();		// 下一个td的标签内部的文本

                loginAcctArray.push(loginAcct);
            });

            // 检查adminIdArray是否包含有效数据
            if (adminIdArray.length == 0) {

                // 给出提示
                alert("请勾选您要删除的记录！");

                // 函数停止执行
                return;
            }

            // 给出确认提示，让用户确认是否真的删除这两条记录
            var confirmResult = confirm("您真的要删除" + loginAcctArray + "信息吗？操作不可逆，请谨慎决定！");

            // 如果用户点击了取消，那么让函数停止执行
            if (!confirmResult) {
                return;
            }

            // 调用专门封装的函数，执行批量删除
            doBatchRemove(adminIdArray);

        });

        // 给单条删除按钮绑定单击响应函数
        $(".uniqueRemoveBtn").click(function () {

            // 获取当前adminId值
            var adminId = $(this).attr("adminId");

            // 获取当前记录的loginAcct
            var loginAcct = $(this).parents("tr").children("td:eq(2)").text();

            var confirmResult = confirm("您真的要删除" + loginAcct + "这条记录吗？");

            if (!confirmResult) {
                return;
            }

            // 为了能够使用批量删除的操作，将adminId存入数组
            var adminIdArray = new Array();

            adminIdArray.push(adminId);

            // 调用专门封装的函数，执行批量删除
            doBatchRemove(adminIdArray);

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
                    <form action="admin/query/for/search.html" class="form-inline" role="form" style="float: left;"
                          method="post">
                        <div class="form-group has-feedback">
                            <div class="input-group">
                                <div class="input-group-addon">查询条件</div>
                                <input
                                        name="keyword"
                                        class="form-control has-success"
                                        type="text"
                                        placeholder="请输入查询条件">
                            </div>
                        </div>
                        <button type="submit" class="btn btn-warning">
                            <i class="glyphicon glyphicon-search"></i> 查询
                        </button>
                    </form>
                    <button
                            id="batchRemoveBtn"
                            type="button"
                            class="btn btn-danger"
                            style="float: right; margin-left: 10px;">
                        <i class=" glyphicon glyphicon-remove"></i> 删除
                    </button>
                    <a href="admin/to/add/page.html" class="btn btn-primary" style="float: right;"><i
                            class="glyphicon glyphicon-plus"></i> 新增</a>
                    <br>
                    <hr style="clear: both;">
                    <div class="table-responsive">
                        <table class="table  table-bordered">
                            <thead>
                            <tr>
                                <th width="30">#</th>
                                <th width="30"><input id="summaryBox" type="checkbox"></th>
                                <th>账号</th>
                                <th>名称</th>
                                <th>邮箱地址</th>
                                <th width="100">操作</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:if test="${empty requestScope['PAGE-INFO'].list }">
                                <!--设置样式最好用CSS的样式 -->
                                <tr>
                                    <td style="text-align: center;" colspan="6">抱歉！没有符合您要求的查询结果！</td>
                                </tr>
                            </c:if>
                            <c:if test="${!empty requestScope['PAGE-INFO'].list }">
                                <c:forEach items="${requestScope['PAGE-INFO'].list }"
                                           var="admin" varStatus="myStatus">
                                    <tr>
                                        <!-- count表示从1开始 -->
                                        <td>${myStatus.count }</td>
                                        <td><input adminId="${admin.id }" class="itemBox" type="checkbox"></td>
                                        <td>${admin.loginAcct }</td>
                                        <td>${admin.userName }</td>
                                        <td>${admin.email }</td>
                                        <td>
                                            <button type="button" class="btn btn-success btn-xs">
                                                <i class=" glyphicon glyphicon-check"></i>
                                            </button>
                                            <!-- 绑定事件用button   跳转用 <a>-->
                                            <a href="admin/to/edit/page.html?adminId=${admin.id }&pageNum=${requestScope['PAGE-INFO'].pageNum}"
                                               class="btn btn-primary btn-xs"><i
                                                    class=" glyphicon glyphicon-pencil"></i></a>
                                            <button adminId="${admin.id }" type="button"
                                                    class="btn btn-danger btn-xs uniqueRemoveBtn">
                                                <i class=" glyphicon glyphicon-remove"></i>
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:if>
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

</body>
</html>