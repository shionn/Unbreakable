package shionn.ubk.raid;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.context.annotation.SessionScope;
import org.springframework.web.servlet.ModelAndView;

import shionn.ubk.db.dao.StatisticDao;

@Controller
@SessionScope
public class StatisticController {
	@Autowired
	private SqlSession session;

	@Cacheable(cacheNames = "statistic")
	@RequestMapping(value = "/statistic", method = RequestMethod.GET)
	public ModelAndView getStatistic() {
		StatisticDao dao = session.getMapper(StatisticDao.class);
		return new ModelAndView("statistic")
				.addObject("players", dao.listPlayerStatistic())
				.addObject("items", dao.listItemStatistic());
	}

}
