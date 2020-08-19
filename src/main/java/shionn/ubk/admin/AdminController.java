package shionn.ubk.admin;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import shionn.ubk.db.dao.ItemDao;
import shionn.ubk.db.dao.PlayerDao;
import shionn.ubk.db.dbo.Item;
import shionn.ubk.db.dbo.ItemSlot;
import shionn.ubk.db.dbo.Player;
import shionn.ubk.db.dbo.PlayerClass;
import shionn.ubk.db.dbo.PlayerRank;
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
				.addObject("slots", ItemSlot.values()) //
				.addObject("players", session.getMapper(PlayerDao.class).listAllPlayers())
				.addObject("items", session.getMapper(ItemDao.class).list())
		;
	}

	@CacheEvict(cacheNames = { "priority", "historic", "statistic" }, allEntries = true)
	@RequestMapping(value = "/admin/create-player", method = RequestMethod.POST)
	public String createPlayer(@RequestParam("pseudo") String pseudo,
			@RequestParam("class") PlayerClass clazz, @RequestParam("rank") PlayerRank rank,
			RedirectAttributes attr) {
		session.getMapper(PlayerDao.class).create(pseudo, clazz, rank);
		session.commit();
		attr.addFlashAttribute("message", "Personnage crée");
		return "redirect:/admin";
	}

	@RequestMapping(value = "/admin/edit-player", method = RequestMethod.POST)
	public ModelAndView openEditPlayer(@RequestParam(name = "id") int id) {
		Player player = session.getMapper(PlayerDao.class).readOne(id);
		return new ModelAndView("edit-player").addObject("player", player)
				.addObject("playerclasses", PlayerClass.values())
				.addObject("playerranks", PlayerRank.values());
	}

	@CacheEvict(cacheNames = { "priority", "historic", "statistic" }, allEntries = true)
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
	public String createItem(@ModelAttribute("item") Item item, 
			RedirectAttributes attr) {
		item.setGp(new EvgpComputer().computeGp(item.getIlvl(), item.getSlot()));
		ItemDao dao = session.getMapper(ItemDao.class);
		dao.create(item);
		for (PlayerClass clazz : item.getClasses()) {
			if (clazz != null) {
				dao.createItemAssignment(item.getId(), clazz);
			}
		}
		session.commit();
		attr.addFlashAttribute("message", "Item crée");
		return "redirect:/admin";
	}

	@RequestMapping(value = "/admin/edit-item", method = RequestMethod.POST)
	public ModelAndView openEditItem(@RequestParam(name = "id") int id) {
		Item item = session.getMapper(ItemDao.class).readOne(id);
		return new ModelAndView("edit-item")
				.addObject("item", item)
				.addObject("playerclasses", PlayerClass.values()) //
				.addObject("raids", RaidInstance.values())
				.addObject("slots", ItemSlot.values());
	}

	@CacheEvict(cacheNames = { "priority", "historic", "statistic" }, allEntries = true)
	@RequestMapping(value = "/admin/edit-item/{id}", method = RequestMethod.POST)
	public String editItem(@ModelAttribute("item") Item item, @PathVariable("id") int id) {
		ItemDao dao = session.getMapper(ItemDao.class);
		item.setId(id);
		item.setGp(new EvgpComputer().computeGp(item.getIlvl(), item.getSlot()));
		dao.update(item);
		dao.deleteItemAssignment(item.getId());
		for (PlayerClass clazz : item.getClasses()) {
			if (clazz != null) {
				dao.createItemAssignment(item.getId(), clazz);
			}
		}
		session.commit();
		return "redirect:/admin";
	}

}
