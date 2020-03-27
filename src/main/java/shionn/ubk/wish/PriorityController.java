package shionn.ubk.wish;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import shionn.ubk.db.dao.PriorityDao;

@Controller
public class PriorityController {
	@Autowired
	private SqlSession session;

	@RequestMapping(value = "/priority", method = RequestMethod.GET)
	public ModelAndView list() {
		return new ModelAndView("priority").addObject("priorities",
				session.getMapper(PriorityDao.class).list());
	}

}
