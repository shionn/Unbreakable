package shionn.ubk.armory;

import java.io.Serializable;
import java.util.List;
import java.util.stream.Collectors;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.context.annotation.SessionScope;
import org.springframework.web.servlet.ModelAndView;

import shionn.ubk.db.dao.ArmoryDao;
import shionn.ubk.db.dbo.ArmoryGroup;
import shionn.ubk.db.dbo.PlayerClass;
import shionn.ubk.db.dbo.RaidInstance;


@Controller
@SessionScope
public class ArmoryController implements Serializable {
	private static final long serialVersionUID = 1L;

	@Autowired
	private SqlSession session;
	private PlayerClass clazz;
	private RaidInstance raid;


	@RequestMapping(value = "/armory", method = RequestMethod.GET)
	public ModelAndView list() {
		ArmoryDao dao = session.getMapper(ArmoryDao.class);
		List<ArmoryGroup> groups = dao.listGroups();
		if (raid != null) {
			groups = groups.stream().filter(g -> g.getRaid() == raid).collect(Collectors.toList());
		}
		if (clazz !=null) {
			for (ArmoryGroup group : groups) {
				group.setPlayers(group.getPlayers().stream().filter(p -> p.getClazz() == clazz)
						.collect(Collectors.toList()));
			}
		}
		return new ModelAndView("armory") //
				.addObject("groups", groups) //
				.addObject("classes",
						clazz == null ? PlayerClass.values() : new PlayerClass[] { clazz });
	}

	@RequestMapping(value = "/armory/{player}/{item}", method = RequestMethod.GET)
	public String toggle(@PathVariable("player") int player, @PathVariable("item") int item) {
		ArmoryDao dao = session.getMapper(ArmoryDao.class);
		if (dao.isPlayerStuff(player, item)) {
			dao.removePlayerStuff(player, item);
		} else {
			dao.addPlayerStuff(player, item);
		}
		session.commit();
		return "redirect:/armory";
	}

	@RequestMapping(value = "/armory/all", method = RequestMethod.GET)
	public String resetFilter() {
		this.raid = null;
		this.clazz = null;
		return "redirect:/armory";
	}

	@RequestMapping(value = "/armory/raid/{raid}", method = RequestMethod.GET)
	public String filterRaid(@PathVariable("raid") RaidInstance raid) {
		this.raid = raid;
		return "redirect:/armory";
	}

	@RequestMapping(value = "/armory/class/{clazz}", method = RequestMethod.GET)
	public String filterRaid(@PathVariable("clazz") PlayerClass clazz) {
		this.clazz = clazz;
		return "redirect:/armory";
	}

}
