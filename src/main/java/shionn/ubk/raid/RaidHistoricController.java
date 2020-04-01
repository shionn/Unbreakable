package shionn.ubk.raid;

import java.io.Serializable;
import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.context.annotation.SessionScope;
import org.springframework.web.servlet.ModelAndView;

import shionn.ubk.db.dao.RaidHistoricDao;
import shionn.ubk.db.dbo.Raid;


@Controller
@SessionScope
public class RaidHistoricController implements Serializable {
	private static final long serialVersionUID = -6557111787828849090L;

	@Autowired
	private SqlSession session;

	@RequestMapping(value = "/historic/raid", method = RequestMethod.GET)
	public ModelAndView list() {
		RaidHistoricDao dao = session.getMapper(RaidHistoricDao.class);
		List<Raid> raids = dao.listAll();
		return new ModelAndView("raid-historic").addObject("raids", raids);
	}


}
