package shionn.ubk.raid;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.context.annotation.SessionScope;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import shionn.ubk.db.dao.ItemDao;
import shionn.ubk.db.dao.PlayerWhishDao;
import shionn.ubk.db.dao.RaidDao;
import shionn.ubk.db.dbo.PlayerWish;
import shionn.ubk.db.dbo.Raid;
import shionn.ubk.db.dbo.RaidEntry;
import shionn.ubk.db.dbo.SortOrder;


@Controller
@SessionScope
public class RaidController implements Serializable {
	private static final long serialVersionUID = -6557111787828849090L;

	@Autowired
	private SqlSession session;

	private SortOrder order = SortOrder.clazz;

	@RequestMapping(value = "/raid", method = RequestMethod.GET)
	public ModelAndView list() {
		RaidDao dao = session.getMapper(RaidDao.class);
		List<Raid> raids = dao.listRunnings();
		for (Raid raid : raids) {
			raid.setPlayers(dao.listRunningPlayer(raid.getId(), order));
		}
		return new ModelAndView("raid").addObject("runnings", raids);
	}

	@RequestMapping(value = "/raid/add", method = RequestMethod.POST)
	public String createRaid(@RequestParam("name") String name,
			@RequestParam("date") @DateTimeFormat(pattern = "yyyy-MM-dd") Date date,
			@RequestParam("point") int point,
			RedirectAttributes attr) {
		session.getMapper(RaidDao.class).create(name, date, point);
		session.commit();
		return "redirect:/raid";
	}

	@RequestMapping(value = "/raid/update", method = RequestMethod.POST)
	public String updateRaid(@ModelAttribute("raid") Raid raid, RedirectAttributes attr) {
		RaidDao dao = session.getMapper(RaidDao.class);
		if (!raid.isRunning()) {
			dao.closeLootedWish(raid.getId());
		}
		dao.update(raid);
		session.commit();
		return "redirect:/raid";
	}

	@RequestMapping(value = "/raid/edit/member/{id}", method = RequestMethod.GET)
	public ModelAndView editRaidMember(@PathVariable("id") int id) {
		RaidDao dao = session.getMapper(RaidDao.class);
		Raid raid = dao.read(id);
		raid.setPlayers(dao.readPlayers(id));
		return new ModelAndView("raid-member").addObject("raid", raid);
	}

	@RequestMapping(value = "/raid/edit/member/{id}", method = RequestMethod.POST)
	public String editRaidMember(@PathVariable("id") int id, @ModelAttribute("raid") Raid raid) {
		RaidDao dao = session.getMapper(RaidDao.class);
		dao.removeRaidPlayerWish(id);
		dao.removeRaidEntry(id);
		for (RaidEntry e : raid.getPlayers()) {
			if (e.isMember()) {
				dao.addMember(id, e.getPlayer().getId(), e.isBench(), e.isVisible());
				for (PlayerWish w : session.getMapper(PlayerWhishDao.class)
						.viewPlayerWish(e.getPlayer().getId())) {
					dao.addRaidPlayerWish(id, e.getPlayer().getId(), w.getItem().getId(),
							w.getRatio());
				}
			}
		}
		session.commit();
		return "redirect:/raid";
	}

	@RequestMapping(value = "/raid/loot/{raid}/{player}", method = RequestMethod.GET)
	public ModelAndView editRaidLoot(@PathVariable("raid") int raid,
			@PathVariable("player") int player) {
		return new ModelAndView("raid-loot").addObject("raid", raid).addObject("player", player)
				.addObject("items", session.getMapper(ItemDao.class).list());
	}

	@RequestMapping(value = "/raid/loot/{raid}/{player}", method = RequestMethod.POST)
	public String addRaidLoot(@PathVariable("raid") int raid,
			@PathVariable("player") int player, @RequestParam("item") int item,
			@RequestParam("ratio") int ratio) {
		session.getMapper(RaidDao.class).addLoot(raid, player, item, ratio);
		session.commit();
		return "redirect:/raid";
	}

	@RequestMapping(value = "/raid/loot/{raid}/{player}/{item}", method = RequestMethod.GET)
	public String rmRaidLoot(@PathVariable("raid") int raid,
			@PathVariable("player") int player, @PathVariable("item") int item) {
		session.getMapper(RaidDao.class).removeLoot(raid, player, item);
		session.commit();
		return "redirect:/raid";
	}

	@RequestMapping(value = "/raid/sort/{order}", method = RequestMethod.GET)
	public String orderBy(@PathVariable("order") SortOrder order) {
		this.order = order;
		return "redirect:/raid";
	}

}
