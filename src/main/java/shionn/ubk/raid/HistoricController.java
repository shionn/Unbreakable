package shionn.ubk.raid;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import shionn.ubk.db.dao.LootHistoricDao;
import shionn.ubk.db.dao.RaidHistoricDao;

@Controller
public class HistoricController {

	@Autowired
	private SqlSession session;

	@Cacheable(cacheNames = "historic", keyGenerator = "MethodNameKeyGenerator")
	@RequestMapping(value = "/historic/raid", method = RequestMethod.GET)
	public ModelAndView raids() {
		RaidHistoricDao dao = session.getMapper(RaidHistoricDao.class);
		return new ModelAndView("raid-historic").addObject("raids", dao.listAll());
	}

	@Cacheable(cacheNames = "historic", keyGenerator = "MethodNameKeyGenerator")
	@RequestMapping(value = "/historic/loot", method = RequestMethod.GET)
	public ModelAndView loots() {
		LootHistoricDao dao = session.getMapper(LootHistoricDao.class);
		return new ModelAndView("loot-historic") //
				.addObject("players", dao.listAll()) //
				.addObject("loots", new LootPerDate(dao.listWl()));
	}

}
