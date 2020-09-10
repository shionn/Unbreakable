package shionn.ubk.raid;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import shionn.ubk.db.dao.PriorityDao;
import shionn.ubk.wish.PrioritiesBuilder;

@Controller
public class BeforeRaidController {
	@Autowired
	private SqlSession session;

	@RequestMapping(value = "/beforeraid", method = RequestMethod.GET)
	public ModelAndView viewPreRaid() {
		PriorityDao dao = session.getMapper(PriorityDao.class);
		return new ModelAndView("before-raid").addObject("priorities",
				new PrioritiesBuilder().groupByItem(dao.listSelected()));
	}

}
