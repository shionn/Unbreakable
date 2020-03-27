package shionn.ubk.security;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ScopedProxyMode;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.context.annotation.RequestScope;

import shionn.ubk.db.dao.UserDao;
import shionn.ubk.db.dbo.User;

@Component
public class CurrentUserFactory {

	@Autowired
	private SqlSession session;

	@Bean
	@RequestScope(proxyMode = ScopedProxyMode.TARGET_CLASS)
	public User buildAuthentifiedUser() {
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		if (auth instanceof AnonymousAuthenticationToken) {
			return new User();
		}
		return session.getMapper(UserDao.class).read(auth.getName());
	}

}
