package shionn.ubk.security;

import org.apache.commons.codec.digest.DigestUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component
public class PlayerToken {

	@Autowired
	@Value("${player.token.salt}")
	private String salt = "salt";

	public String build(String name) {
		String salted = name.substring(0, name.length() / 2) + salt + name.substring(name.length() / 2);
		return DigestUtils.sha512Hex(salted);
	}

}
