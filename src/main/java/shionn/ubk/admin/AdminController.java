package shionn.ubk.admin;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import shionn.ubk.db.dao.PlayerDao;
import shionn.ubk.db.dbo.Player;
import shionn.ubk.db.dbo.PlayerClass;
import shionn.ubk.db.dbo.PlayerRank;
import shionn.ubk.db.dbo.User;

@Controller
public class AdminController {
	@Autowired
	private SqlSession session;
	@Autowired
	private User user;

	@RequestMapping(value = "/admin", method = RequestMethod.GET)
	public ModelAndView admin() {
		return new ModelAndView("admin") //
				.addObject("playerclasses", PlayerClass.values()) //
				.addObject("playerranks", PlayerRank.values())
				.addObject("players", session.getMapper(PlayerDao.class).list())
		;
	}

	@RequestMapping(value = "/admin/create-player", method = RequestMethod.POST)
	public String getCreateUser(@RequestParam("pseudo") String pseudo,
			@RequestParam("class") PlayerClass clazz, @RequestParam("rank") PlayerRank rank,
			RedirectAttributes attr) {
		session.getMapper(PlayerDao.class).create(pseudo, clazz, rank);
		session.commit();
		attr.addFlashAttribute("message", "Personnage crée");
		return "redirect:/admin";
	}

	@RequestMapping(value = "/admin/edit-player", method = RequestMethod.POST)
	public ModelAndView editPlayer(@RequestParam(name = "id") int id) {
		Player player = session.getMapper(PlayerDao.class).readOne(id);
		return new ModelAndView("edit-player").addObject("player", player)
				.addObject("playerclasses", PlayerClass.values())
				.addObject("playerranks", PlayerRank.values());
	}

	@RequestMapping(value = "/admin/edit-player/{id}", method = RequestMethod.POST)
	public String openEditPlayerForm(@PathVariable(name = "id") int id,
			@RequestParam(name = "class") PlayerClass clazz,
			@RequestParam(name = "rank") PlayerRank rank,
			@RequestParam(name = "name") String name) {
		PlayerDao dao = session.getMapper(PlayerDao.class);
		dao.updatePlayer(id, name, clazz, rank);
		session.commit();
		return "redirect:/admin";
	}
}
