<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<div id="addModal" class="modal fade" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <form role="form">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal"
                            aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                    <h4 class="modal-title">尚筹网系统弹窗</h4>
                </div>
                <div class="modal-body">
                    <input type="text" id="roleNameInput" class="form-control"
                           placeholder="请输入角色名称"/>
                </div>
                <div class="modal-footer">
                    <button id="addModalBtn" type="button" class="btn btn-success">
                        <i class="glyphicon glyphicon-plus"></i> 保存
                    </button>
                    <button type="reset" class="btn btn-primary">
                        <%--要想实现重置功能必须和要重置的文本框放在同一个form表单中--%>
                        <i class="glyphicon glyphicon-refresh"></i> 重置
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>