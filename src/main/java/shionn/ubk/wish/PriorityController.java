package shionn.ubk.wish;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import shionn.ubk.db.dao.PlayerWhishDao;
import shionn.ubk.db.dao.PriorityDao;
import shionn.ubk.db.dbo.Priority;
import shionn.ubk.db.dbo.User;

@Controller
public class PriorityController {
	@Autowired
	private SqlSession session;
	@Autowired
	private User user;

	@Cacheable(cacheNames = "priority", keyGenerator = "UserRoleKeyGenerator")
	@RequestMapping(value = "/priority", method = RequestMethod.GET)
	public ModelAndView list() {
		List<Priority> dbs = session.getMapper(PriorityDao.class).list(orderBy());
		List<List<Priority>> collect = new PrioritiesBuilder().groupByItem(dbs, user);
		return new ModelAndView("priority").addObject("priorities", collect);
	}

	@RequestMapping(value = "/priority/{player}/{item}", method = RequestMethod.GET)
	@CacheEvict(cacheNames = { "priority" }, allEntries = true)
	@ResponseBody
	public String updateSelected(@PathVariable("player") int player,
			@PathVariable("item") int item) {
		session.getMapper(PlayerWhishDao.class).updateSelected(player, item);
		session.commit();
		return "done";
	}

	private String orderBy() {
		if (user.isMdc()) {
			return "item_name ASC, looted ASC, evgp_ratio ASC";
		}
		return "item_name ASC, player_name ASC";
	}

}
