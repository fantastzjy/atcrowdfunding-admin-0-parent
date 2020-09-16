package com.atguigu.crowd.funding.service.api;

import com.atguigu.crowd.funding.entity.Role;
import com.github.pagehelper.PageInfo;

import java.util.List;

/**
 * @create 2020-09-07-11:42
 */
public interface RoleService {
    PageInfo<Role> queryForKeywordWithPage(Integer pageNum, Integer pageSize, String keyword);

    List<Role> getRoleListByIdList(List<Integer> roleIdList);

    public void batchRemove(List<Integer> roleIdList);

    void saveRole(String roleName);

    void updateRole(Role role);

}
