package shionn.ubk.security;

import org.apache.commons.codec.digest.DigestUtils;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.AuthorityUtils;
import org.springframework.stereotype.Controller;

import shionn.ubk.db.dao.UserDao;
import shionn.ubk.db.dbo.User;

/**
 * Code sous licence GPLv3 (http://www.gnu.org/licenses/gpl.html)
 *
 * @author <b>Shionn</b>, shionn@gmail.com <i>http://shionn.org</i><br>
 *         GCS d- s+:+ a+ C++ UL/M P L+ E--- W++ N K- w-- M+ t+ 5 X R+ !tv b+ D+ G- e+++ h+ r- y+
 */
@Controller
public class AuthenticationProvider implements org.springframework.security.authentication.AuthenticationProvider {

	@Autowired
	private SqlSession session;

	@Override
	public boolean supports(Class<?> type) {
		return type == UsernamePasswordAuthenticationToken.class;
	}

	@Override
	public Authentication authenticate(Authentication authentication) {
		User user = session.getMapper(UserDao.class).read((String) authentication.getPrincipal());
		if (user == null) {
			throw new BadCredentialsException("Utilisateur Inconnu");
		} else if (checkPassword((UsernamePasswordAuthenticationToken) authentication, user)) {
			authentication = new UsernamePasswordAuthenticationToken(authentication.getPrincipal(),
					authentication.getCredentials(),
					AuthorityUtils
							.createAuthorityList(
									user.getRole() == null ? new String[0]
											: user.getRole().split(":")));
		} else {
			throw new BadCredentialsException("Mauvais Mdp");
		}
		return authentication;
	}

	private boolean checkPassword(UsernamePasswordAuthenticationToken token, User user) {
		return user.getPass().equals(encodePassword(token));
	}

	private String encodePassword(UsernamePasswordAuthenticationToken token) {
		return DigestUtils.sha256Hex((String) token.getCredentials());
	}
}
