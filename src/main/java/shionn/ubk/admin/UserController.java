package shionn.ubk.admin;

import org.apache.commons.codec.digest.DigestUtils;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import shionn.ubk.db.dao.UserDao;

@Controller
public class UserController {

	@Autowired
	private SqlSession session;

	@RequestMapping(value = "/create-user", method = RequestMethod.GET)
	public String getCreateUser() {
		return "create-user";
	}

	@RequestMapping(value = "/create-user", method = RequestMethod.POST)
	public String getCreateUser(@RequestParam("pseudo") String pseudo,
			@RequestParam("email") String email, @RequestParam("pass") String pass,
			@RequestParam("pass-confirm") String passConfirm,
			RedirectAttributes attr) {
		if (!pass.equals(passConfirm)) {
			attr.addFlashAttribute("error", "Les mots de passe ne correspondent pas");
		} else {
			session.getMapper(UserDao.class).create(pseudo, email, DigestUtils.sha256Hex(pass));
			session.commit();
			attr.addFlashAttribute("message", "Utilisateur crée");
		}
		return "redirect:/create-user";
	}

}
