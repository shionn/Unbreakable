package shionn.ubk.cache;

import java.lang.reflect.Method;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.interceptor.KeyGenerator;
import org.springframework.stereotype.Component;

import shionn.ubk.db.dbo.User;

@Component("UserRoleKeyGenerator")
public class UserRoleKeyGenerator implements KeyGenerator {

	@Autowired
	private User user;

	@Override
	public Object generate(Object target, Method method, Object... params) {
		String role = user.getRole();
		if (role == null) {
			role = "null";
		}
		return role;
	}

}
