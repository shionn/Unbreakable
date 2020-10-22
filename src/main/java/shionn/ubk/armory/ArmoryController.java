package shionn.ubk.armory;

import java.io.Serializable;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.context.annotation.SessionScope;
import org.springframework.web.servlet.ModelAndView;

import shionn.ubk.db.dao.ArmoryDao;
import shionn.ubk.db.dbo.PlayerClass;


@Controller
@SessionScope
public class ArmoryController implements Serializable {
	private static final long serialVersionUID = 1L;

	@Autowired
	private SqlSession session;


	@RequestMapping(value = "/armory", method = RequestMethod.GET)
	public ModelAndView list() {
		ArmoryDao dao = session.getMapper(ArmoryDao.class);
		return new ModelAndView("armory") //
				.addObject("groups", dao.listGroups()) //
				.addObject("classes", PlayerClass.values());
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

}
