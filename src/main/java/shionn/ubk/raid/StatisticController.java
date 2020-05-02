package shionn.ubk.raid;

import java.io.Serializable;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.context.annotation.SessionScope;
import org.springframework.web.servlet.ModelAndView;

import shionn.ubk.db.dao.StatisticDao;

@Controller
@SessionScope
public class StatisticController implements Serializable{
	private static final long serialVersionUID = -2644193431390094901L;
	@Autowired
	private SqlSession session;

	@RequestMapping(value = "/statistic", method = RequestMethod.GET)
	public ModelAndView getStatistic() {
		return new ModelAndView("statistic").addObject("stats",
				session.getMapper(StatisticDao.class).listStatistic());
	}

}
