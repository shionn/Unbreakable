package shionn.ubk.wish;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import shionn.ubk.db.dao.ItemDao;
import shionn.ubk.db.dao.PlayerDao;
import shionn.ubk.db.dao.PlayerWhishDao;
import shionn.ubk.db.dbo.Item;
import shionn.ubk.db.dbo.Player;
import shionn.ubk.db.dbo.PlayerWish;

@Controller
public class WishListController {
	@Autowired
	private SqlSession session;

	@RequestMapping(value = "/wish", method = RequestMethod.GET)
	public ModelAndView list(@RequestParam(defaultValue = "-1", name = "player") int player) {
		ModelAndView view = new ModelAndView("wish").addObject("players", session.getMapper(PlayerDao.class).list());
		if (player !=-1) {
			view.addObject("player", readPlayer(player))
					.addObject("items", readItems());
		}
		return view;
	}

	@RequestMapping(value = "/wish/update", method = RequestMethod.POST)
	public ModelAndView update(@ModelAttribute("player") Player player) {
		Integer sum = player.getWishes().stream().map(w -> w.getRatio()).reduce(0, (a, b) -> a + b);
		if (sum != 100) {
			throw new IllegalArgumentException("Somme des ratios différentes de 100");
		}
		PlayerWhishDao dao = session.getMapper(PlayerWhishDao.class);
		for (PlayerWish wish : player.getWishes()) {
			if (wish.getItem().getId() != 0) {
				dao.update(player, wish);
			}
		}
		List<Integer> items = player.getWishes().stream().map(w -> w.getItem().getId()).filter(id -> id != 0)
				.collect(Collectors.toList());
		dao.disable(player.getId(), items);
		session.commit();
		return list(player.getId());
	}

	private Player readPlayer(int id) {
		Player player = session.getMapper(PlayerWhishDao.class).viewPlayer(id);
		while (player.getWishes().size() < 5) {
			PlayerWish wish = new PlayerWish();
			wish.setItem(noneItem());
			wish.setRatio(0);
			List<PlayerWish> wishes = new ArrayList<PlayerWish>(player.getWishes());
			wishes.add(wish);
			player.setWishes(wishes);
		}
		return player;
	}

	private List<Item> readItems() {
		List<Item> items = new ArrayList<>(session.getMapper(ItemDao.class).list());
		items.add(0, noneItem());
		return items;
	}

	private Item noneItem() {
		Item item = new Item();
		item.setName("---");
		item.setId(0);
		return item;
	}



//	@RequestMapping(value = "/wish", method = RequestMethod.G)
//	public ModelAndView open(@RequestParam("player") int player) {
//		return new ModelAndView("wish") //
	//				.;
//	}

}
