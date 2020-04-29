package shionn.ubk.wish;

import java.util.Iterator;
import java.util.List;
import java.util.stream.Collectors;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import shionn.ubk.db.dao.PriorityDao;
import shionn.ubk.db.dbo.Priority;
import shionn.ubk.db.dbo.User;

@Controller
public class PriorityController {
	@Autowired
	private SqlSession session;
	@Autowired
	private User user;

	@RequestMapping(value = "/priority", method = RequestMethod.GET)
	public ModelAndView list() {
		List<Priority> dbs = session.getMapper(PriorityDao.class).list(orderBy());
		List<List<Priority>> collect = dbs.stream()
				.map(p -> p.getItem()).distinct().map(item -> dbs.stream()
						.filter(p -> p.getItem().equals(item)).collect(Collectors.toList()))
				.collect(Collectors.toList());
		if (user.isMdc()) {
			for (List<Priority> priorities : collect) {
				Iterator<Priority> ite = priorities.iterator();
				Priority previous = ite.next();
				previous.setOrder(1);
				while (ite.hasNext()) {
					Priority current = ite.next();
					if (current.equals(previous)) {
						current.setOrder(previous.getOrder());
					} else {
						current.setOrder(previous.getOrder() + 1);
					}
					previous = current;
				}
			}
		}
		return new ModelAndView("priority").addObject("priorities", collect);
	}

	private String orderBy() {
		if (user.isMdc()) {
			return "item_name ASC, looted ASC, point ASC";
		}
		return "item_name ASC, player_name ASC";
	}

}
