// 初始化全局变量		只在第一次访问该页面的时候进行初始化  后面会在赋值
function initGlobalVariable() {
    window.pageSize = 10;
    window.pageNum = 1;
    window.keyword = "";
}

// 给服务器发送请求获取分页数据（pageInfo），并在页面上显示分页效果（主体、页码导航条）
function showPage() {

    // 给服务器发送请求获取分页数据：PageInfo
    var pageInfo = getPageInfo();
    // console.log(pageInfo);

    // 在页面上的表格中tbody标签内显示分页的主体数据
    generateTableBody(pageInfo);

    // 在页面上的表格中tfoot标签内显示分页的页码导航条
    initPagination(pageInfo);
    //zjy使翻页时/删除完毕后全选全不选按钮变成不选中状态
    $("#summaryBox").prop("checked", false);
}

// 获取分页数据：PageInfo
function getPageInfo() {
    // 以同步请求方式调用$.ajax()函数并获取返回值（返回值包含全部响应数据）
    // 会等得到返回值才进行下面的程序
    //这里用同步的方式进行请求，所以这里直接得到整个返回对象
    // 数据为空时，值为 undefine
    var ajaxResult = $.ajax({
        "url": "role/search/by/keyword.json",
        "type": "post",
        "data": {
            "pageNum": (window.pageNum == undefined) ? 1 : window.pageNum,
            "pageSize": (window.pageSize == undefined) ? 5 : window.pageSize,
            "keyword": (window.keyword == undefined) ? "" : window.keyword
        },
        "dataType": "json",
        "async": false	// 为了保证getPageInfo()函数能够在Ajax请求拿到响应后获取PageInfo，需要设置为同步操作
    });

    // console.log(ajaxResult);

    // console.log(ajaxResult.responseJSON);

    // 从全部响应数据中获取JSON格式的响应体数据
    var resultEntity = ajaxResult.responseJSON;

    // 从响应体数据中获取result，判断当前请求是否成功
    var result = resultEntity.result;

    // 如果成功获取PageInfo
    if (result == "SUCCESS") {
        return resultEntity.data;
    }

    if (result == "FAILED") {
        layer.msg(resultEntity.message);
    }

    return null;
}


// 使用PageInfo数据在tbody标签内显示分页数据
function generateTableBody(pageInfo) {

    // 执行所有操作前先清空   ，内容都是拼接来的，不清空点击下一页会累积
    $("#roleTableBody").empty();

    // 获取数据集合
    var list = pageInfo.list;

    // 判断list是否有效
    if (list == null || list.length == 0) {
        $("#roleTableBody")
            .append("<tr><td colspan='4' style='text-align:center;'>没有查询到数据！</td></tr>");
        return;
    }

    /*
<tr>
    <td>1</td>
    <td><input type='checkbox'></td>
    <td>PM - 项目经理</td>
    <td>
        <button type='button' class='btn btn-success btn-xs'><i class=' glyphicon glyphicon-check'></i></button>
        <button type='button' class='btn btn-primary btn-xs'><i class=' glyphicon glyphicon-pencil'></i></button>
        <button type='button' class='btn btn-danger btn-xs'><i class=' glyphicon glyphicon-remove'></i></button>
    </td>
</tr>
     */

    for (var i = 0; i < list.length; i++) {

        var role = list[i];

        var checkBtn = "<button type='button' class='btn btn-success btn-xs'><i class=' glyphicon glyphicon-check'></i></button>";
        var pencilBtn = "<button roleId='" + role.id + "' type='button' class='btn btn-primary btn-xs editBtn'><i class=' glyphicon glyphicon-pencil'></i></button>";
        // 注意着里面的单引号不要写成中文的了
        var removeBtn = "<button roleId='" + role.id + "' type='button' class='btn btn-danger btn-xs removeBtn'><i class=' glyphicon glyphicon-remove'></i></button>";


        var numberTd = "<td>" + (i + 1) + "</td>";
        var checkBoxTd = "<td><input roleid='" + role.id + "' class='itemBox' type='checkbox'></td>";
        var roleNameTd = "<td>" + role.name + "</td>";
        var btnTd = "<td>" + checkBtn + " " + pencilBtn + " " + removeBtn + "</td>";

        var tr = "<tr>" + numberTd + checkBoxTd + roleNameTd + btnTd + "</tr>";

        // 将前面拼好的HTML代码追加到#roleTableBody中
        $("#roleTableBody").append(tr);
    }
}


//声明函数封装导航条初始化操作
function initPagination(pageInfo) {

    // 声明变量存储分页导航条显示时的属性设置
    var paginationProperties = {
        num_edge_entries: 3,			//边缘页数
        num_display_entries: 5,		//主体页数
        callback: pageselectCallback,	//回调函数
        items_per_page: window.pageSize,	//每页显示数据数量，就是pageSize
        current_page: (window.pageNum - 1),//当前页页码
        prev_text: "LAST",			//上一页文本
        next_text: "NEXT"			//下一页文本
    };

    // 显示分页导航条
    $("#Pagination").pagination(pageInfo.total, paginationProperties);
}

// 在每一次点击“上一页”、“下一页”、“页码”时执行这个函数跳转页面
function pageselectCallback(pageIndex, jq) {

    // 将全局变量中的pageNum修改为最新值
    // pageIndex从0开始，pageNum从1开始
    window.pageNum = pageIndex + 1;
    // 调用分页函数重新执行分页
    showPage();
    //zjy使翻页时全选全不选按钮变成不选中状态
    // $("#summaryBox").prop("checked",false);
    return false;
}

// 根据roleIdArray查询roleList
function getRoleListByRoleIdArray(roleIdArray) {

    // 1.将roleIdArray转换成JSON字符串
    var requestBody = JSON.stringify(roleIdArray);

    // 2.发送Ajax请求
    var ajaxResult = $.ajax({
        "url": "role/get/list/by/id/list.json",
        "type": "post",
        "data": requestBody,
        "contentType": "application/json;charset=UTF-8",
        "dataType": "json",
        "async": false
    });

    // 3.获取JSON对象类型的响应体
    var resultEntity = ajaxResult.responseJSON;

    // 4.验证是否成功
    var result = resultEntity.result;

    if (result == "SUCCESS") {

        // 5.如果成功，则返回roleList
        return resultEntity.data;
    }

    if (result == "FAILED") {
        layer.msg(resultEntity.message);
        return null;
    }

    return null;

}


function showRemoveConfirmModal() {

    // 1.将模态框显示出来
    $("#confirmModal").modal("show");

    // 2.根据roleIdList获取roleList
    var roleList = getRoleListByRoleIdArray(window.roleIdArray);

    // 3.清空#confirmModalTableBody
    $("#confirmModalTableBody").empty();

    // 4.填充#confirmModalTableBody
    for (var i = 0; i < roleList.length; i++) {

        // 5.获取角色相关数据
        var role = roleList[i];

        var id = role.id;

        var name = role.name;

        var trHTML = "<tr><td>" + id + "</td><td>" + name + "</td></tr>";

        // 6.执行填充
        $("#confirmModalTableBody").append(trHTML);
    }

}