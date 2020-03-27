package shionn.ubk.wish;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

@Controller
public class WishListController {
	@Autowired
	private SqlSession session;

}
