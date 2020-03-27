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

import shionn.ubk.db.dao.ItemDao;
import shionn.ubk.db.dao.PlayerDao;
import shionn.ubk.db.dbo.Item;
import shionn.ubk.db.dbo.Player;
import shionn.ubk.db.dbo.PlayerClass;
import shionn.ubk.db.dbo.PlayerRank;
import shionn.ubk.db.dbo.Raid;
import shionn.ubk.db.dbo.RaidInstance;

@Controller
public class AdminController {
	@Autowired
	private SqlSession session;

	@RequestMapping(value = "/admin", method = RequestMethod.GET)
	public ModelAndView admin() {
		return new ModelAndView("admin") //
				.addObject("playerclasses", PlayerClass.values()) //
				.addObject("playerranks", PlayerRank.values()) //
				.addObject("raids", RaidInstance.values()) //
				.addObject("players", session.getMapper(PlayerDao.class).list())
				.addObject("items", session.getMapper(ItemDao.class).list())
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
	public String editPlayer(@PathVariable(name = "id") int id,
			@RequestParam(name = "class") PlayerClass clazz,
			@RequestParam(name = "rank") PlayerRank rank,
			@RequestParam(name = "name") String name) {
		PlayerDao dao = session.getMapper(PlayerDao.class);
		dao.updatePlayer(id, name, clazz, rank);
		session.commit();
		return "redirect:/admin";
	}

	@RequestMapping(value = "/admin/create-item", method = RequestMethod.POST)
	public String getCreateUser(@RequestParam("name") String name,
			@RequestParam("boss") String boss, @RequestParam("raid") Raid raid,
			RedirectAttributes attr) {
		session.getMapper(ItemDao.class).create(name, raid, boss);
		session.commit();
		attr.addFlashAttribute("message", "Item crée");
		return "redirect:/admin";
	}

	@RequestMapping(value = "/admin/edit-item", method = RequestMethod.POST)
	public ModelAndView editItem(@RequestParam(name = "id") int id) {
		Item item = session.getMapper(ItemDao.class).readOne(id);
		return new ModelAndView("edit-item").addObject("item", item).addObject("raids",
				RaidInstance.values());
	}

	@RequestMapping(value = "/admin/edit-item/{id}", method = RequestMethod.POST)
	public String editItem(@PathVariable(name = "id") int id,
			@RequestParam(name = "raid") Raid raid, @RequestParam(name = "boss") String boss,
			@RequestParam(name = "name") String name) {
		ItemDao dao = session.getMapper(ItemDao.class);
		dao.update(id, name, raid, boss);
		session.commit();
		return "redirect:/admin";
	}

}
