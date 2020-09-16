package com.atguigu.crowd.funding.service.api;

import java.util.List;

import com.atguigu.crowd.funding.entity.Admin;
import com.github.pagehelper.PageInfo;

public interface AdminService {

	List<Admin> getAll();

	void updateAdmin(Admin admin);

	Admin login(String loginAcct, String userPswd);


	PageInfo<Admin> queryForKeywordSearch(Integer pageNum, Integer pageSize, String keyword);

	void batchRemove(List<Integer> adminIdList);

	void saveAdmin(Admin admin);

	Admin getAdminById(Integer adminId);


	
	
}
