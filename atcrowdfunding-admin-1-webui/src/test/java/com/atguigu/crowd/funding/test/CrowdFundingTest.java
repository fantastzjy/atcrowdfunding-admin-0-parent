package com.atguigu.crowd.funding.test;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

import javax.sql.DataSource;

import com.atguigu.crowd.funding.entity.Role;
import com.atguigu.crowd.funding.mapper.RoleMapper;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.atguigu.crowd.funding.entity.Admin;
import com.atguigu.crowd.funding.mapper.AdminMapper;
import com.atguigu.crowd.funding.service.api.AdminService;

// 需要用spring-test的这个依赖
@RunWith(SpringJUnit4ClassRunner.class)
//注意书写的格式,多个文件加花括号
@ContextConfiguration(locations = { "classpath:spring-persist-mybatis.xml", "classpath:spring-persist-tx.xml" })
public class CrowdFundingTest {

	// import javax.sql.DataSource; 注意DataSource导入的是这个包，根据引入的jdbc的依赖
	// 这个是jdbc定义的datasource
	@Autowired
	private DataSource dataSource;
	@Autowired
	private AdminService adminService;

	@Autowired
	private AdminMapper adminMapper;

	@Autowired
	private RoleMapper roleMapper;

	@Test
	public void testSaveAdmin() {
		for(int i = 0;i < 100; i++) {
			roleMapper.insert(new Role(null, "role"+i));
		}
	}

	@Test
	public void testAdminMapperSearch() {
		String keyword = "";
		List<Admin> list = adminMapper.selectAdminListByKeyword(keyword);

		for (Admin admin : list) {
			System.out.println(admin);
		}
	}
	
	@Test
	public void batchSaveAdmin() {
		for(int i = 500; i < 1000; i++) {
			adminMapper.insert(new Admin(null, "fantast"+i, "E10ADC3949BA59ABBE56E057F20F883E", "用户"+i, "email"+i+"@qq.com", null));
		}
	}
	

//	@Test
//	public void testTx() {
//		adminService.updateAdmin();
//	}

	@Test
	public void testMybatis() {
		List<Admin> adminList = adminService.getAll();
		for (Admin admin : adminList) {
			System.out.println(admin);
		}
	}

	@Test
	public void testConnection() throws SQLException {
		Connection connection = dataSource.getConnection();

		System.out.println(connection);
	}

}