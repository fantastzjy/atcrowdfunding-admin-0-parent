// 声明函数封装导航条初始化操作
//和业务不相关的参数尽量不要以参数的形式传进来
function initPagination() {

	// 声明变量存储总记录数
	// var totalRecord = ${requestScope['PAGE-INFO'].total};

	// 声明变量存储分页导航条显示时的属性设置
	var paginationProperties = {
		num_edge_entries : 3,			//边缘页数
		num_display_entries : 5,		//主体页数
		callback : pageselectCallback,	//回调函数
		items_per_page : window.pageSize,	//每页显示数据数量，就是pageSize
		current_page : (window.pageNum - 1),//当前页页码	   current_page从0开始   pageNum从1开始
		prev_text : "LAST",			//上一页文本
		next_text : "NEXT"			//下一页文本
	};

	// 显示分页导航条
	$("#Pagination").pagination(window.totalRecord, paginationProperties);
}

// 在每一次点击“上一页”、“下一页”、“页码”时执行这个函数跳转页面
//在这里传参没用，这俩参数是这个函数自带的参数，写死了
function pageselectCallback(pageIndex,jq) {

	// 将全局变量中的pageNum修改为最新值
	window.pageNum = pageIndex + 1;

	// pageIndex从0开始，pageNum从1开始
	// 跳转页面
	//window.keyword    js的全局变量
	window.location.href = "admin/query/for/search.html?pageNum="+(pageIndex + 1)+"&keyword="+window.keyword;

	return false;
}

// 封装执行批量删除的函数
function doBatchRemove(adminIdArray) {

	// 将JSON数组转换为JSON字符串
	// var a = [1,2,3,4,5];					数组类型
	// var b = "[1,2,3,4,5]";				字符串类型
	// var c = {"userName":"tom"};			对象类型
	// var d = "{\"userName\":\"tom\"}";	字符串类型
	// 发送Ajax请求执行批量删除
	var requestBody = JSON.stringify(adminIdArray);

	// 发送Ajax请求将adminIdArray发送给handler方法
	$.ajax({
		"url":"admin/batch/remove.json",	// 服务器端接收请求的URL地址
		"type":"post",	// 设置请求方式为POST
		"contentType":"application/json;charset=UTF-8",	// 设置请求体内容类型，告诉服务器当前请求体发送的是JSON数据
		"data":requestBody,	// 请求体真正要发送给服务器的数据
		"dataType":"json",		// 把服务器端返回的数据当作JSON格式解析
		"success":function(response) {		// 服务器处理请求成功后执行的函数，响应体以参数形式传入当前函数
			console.log(response);

			var result = response.result;

			if(result == "SUCCESS") {
				// 跳转页面
				window.location.href = "admin/query/for/search.html?pageNum="+window.pageNum+"&keyword="+window.keyword;
			}

			if(result == "FAILED") {
				alert(response.message);
				return ;
			}

		},
		"error":function(response) {	// 服务器处理请求失败后执行的函数，响应体以参数形式传入当前函数
			alert(response.message);
			return ;
		}
	});

}