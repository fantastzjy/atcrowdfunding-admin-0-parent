package com.atguigu.crowd.funding.handler;

import com.atguigu.crowd.funding.entity.ResultEntity;
import com.atguigu.crowd.funding.entity.Role;
import com.atguigu.crowd.funding.service.api.RoleService;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * @create 2020-09-07-12:45
 */
//@Controller
//@ResponseBody
    @RestController
public class RoleHandler {
    @Autowired
    RoleService roleService;


    // @ResponseBody
    @RequestMapping("/role/update/role")
    public ResultEntity<String> updateRole(Role role) {

        roleService.updateRole(role);

        return ResultEntity.successWithoutData();
    }

//     @ResponseBody
    @RequestMapping("/role/save/role")
    public ResultEntity<String> saveRole(@RequestParam("roleName") String roleName) {

        roleService.saveRole(roleName);

        return ResultEntity.successWithoutData();
    }

//    @ResponseBody
    @RequestMapping("/role/batch/remove")
    public ResultEntity<String> batchRemove(@RequestBody List<Integer> roleIdList) {
        roleService.batchRemove(roleIdList);
        return ResultEntity.successWithoutData();
    }


//    @ResponseBody
    @RequestMapping("/role/get/list/by/id/list")
    public ResultEntity<List<Role>> getRoleListByIdList(@RequestBody List<Integer> roleIdList) {

        List<Role> roleList = roleService.getRoleListByIdList(roleIdList);

        return ResultEntity.successWithData(roleList);
    }


//    @ResponseBody
    @RequestMapping("/role/search/by/keyword")
    public ResultEntity<PageInfo<Role>> search(
            @RequestParam(value = "pageNum", defaultValue = "1") Integer pageNum,
            @RequestParam(value = "pageSize", defaultValue = "10") Integer pageSize,
            @RequestParam(value = "keyword", defaultValue = "") String keyword
    ) {

        PageInfo<Role> pageInfo = roleService.queryForKeywordWithPage(pageNum, pageSize, keyword);

        return ResultEntity.successWithData(pageInfo);
    }


}
