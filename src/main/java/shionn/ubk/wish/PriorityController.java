package shionn.ubk.wish;

import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import shionn.ubk.db.dao.PriorityDao;
import shionn.ubk.db.dbo.Item;
import shionn.ubk.db.dbo.Priority;

@Controller
public class PriorityController {
	@Autowired
	private SqlSession session;

	@RequestMapping(value = "/priority", method = RequestMethod.GET)
	public ModelAndView list() {
		List<Priority> dbs = session.getMapper(PriorityDao.class).list();
		Map<Item, List<Priority>> collect = dbs.stream().map(p -> p.getItem()).distinct()
				.collect(Collectors.toMap(item -> item,
						item -> dbs.stream().filter(p -> p.getItem().equals(item))
						.collect(Collectors.toList())));
		for (List<Priority> priorities : collect.values()) {
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
		return new ModelAndView("priority").addObject("priorities",
				collect);
	}

}
