package com.atguigu.crowd.funding.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.atguigu.crowd.funding.entity.Admin;
import com.atguigu.crowd.funding.util.CrowdFundingConstant;

public class LoginInterceptor extends HandlerInterceptorAdapter {

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {

		// 通过request对象获取HttpSession对象
		HttpSession session = request.getSession();
		// 从Session域尝试获取已登录用户对象
		Admin admin = (Admin) session.getAttribute(CrowdFundingConstant.ATTR_NAME_LOGIN_ADMIN);
		// 如果没有获取到Admin对象
		if (admin == null) {

			// 将提示消息存入request域
			request.setAttribute(CrowdFundingConstant.ATTR_NAME_MESSAGE, CrowdFundingConstant.MESSAGE_ACCESS_DENIED);

			// 转发到登录页面
			request.getRequestDispatcher("/WEB-INF/admin-login.jsp").forward(request, response);

			return false;
		}

		// 如果admin对象有效，则放行继续执行后续操作
		return true;
	}

}
