package com.atguigu.crowd.funding.service.impl;

import com.atguigu.crowd.funding.entity.Role;
import com.atguigu.crowd.funding.entity.RoleExample;
import com.atguigu.crowd.funding.mapper.RoleMapper;
import com.atguigu.crowd.funding.service.api.RoleService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @create 2020-09-07-11:46
 */
@Service
public class RoleServiceImpl implements RoleService {

    @Autowired
    private RoleMapper roleMapper;


    @Override
    public PageInfo<Role> queryForKeywordWithPage(Integer pageNum, Integer pageSize, String keyword) {
// 1.开启分页功能s
        PageHelper.startPage(pageNum, pageSize);

        // 2.执行查询
        List<Role> list = roleMapper.selectForKeywordSearch(keyword);

        // 3.封装为PageInfo对象
        return new PageInfo<>(list);
    }

    @Override
    public List<Role> getRoleListByIdList(List<Integer> roleIdList) {

        // 预期的SQL语句
        // select id,name from t_role where id in (1,2,3,6,12)

        // 创建实体类Role对应的Example对象
        RoleExample roleExample = new RoleExample();

        // 在Example对象中封装查询条件
        roleExample.createCriteria().andIdIn(roleIdList);

        // 执行查询
        return roleMapper.selectByExample(roleExample);
    }

    @Override
    public void batchRemove(List<Integer> roleIdList) {

        RoleExample roleExample = new RoleExample();

        roleExample.createCriteria().andIdIn(roleIdList);
        roleMapper.deleteByExample(roleExample);

    }

    @Override
    public void saveRole(String roleName) {
        roleMapper.insert(new Role(null, roleName));
    }

    @Override
    public void updateRole(Role role) {
        roleMapper.updateByPrimaryKey(role);
    }


}
