package shionn.ubk.wish;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheEvict;
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
import shionn.ubk.db.dbo.PlayerClass;
import shionn.ubk.db.dbo.PlayerWish;

@Controller
public class WishListController {
	private static final int MAX_ITEM = 20;
	@Autowired
	private SqlSession session;

	@RequestMapping(value = "/wish", method = RequestMethod.GET)
	public ModelAndView list(@RequestParam(defaultValue = "-1", name = "player") int playerId) {
		PlayerDao dao = session.getMapper(PlayerDao.class);
		ModelAndView view = new ModelAndView("wish").addObject("players", dao.listPlayers())
				.addObject("wishes", dao.listWishes());
		if (playerId != -1) {
			Player player = readPlayer(playerId);
			view.addObject("player", player).addObject("items", readItems(player.getClazz()));
		}
		return view;
	}

	@CacheEvict(cacheNames = { "priority", "historic", "statistic" }, allEntries = true)
	@RequestMapping(value = "/wish/update", method = RequestMethod.POST)
	public ModelAndView update(@ModelAttribute("player") Player player) {
		PlayerWhishDao dao = session.getMapper(PlayerWhishDao.class);
		for (PlayerWish wish : player.getWishes()) {
			if (wish.getItem().getId() != 0) {
				dao.update(player, wish);
			}
		}
		List<Integer> items = player.getWishes().stream().map(w -> w.getItem().getId()).filter(id -> id != 0)
				.collect(Collectors.toList());
		if (!items.isEmpty()) {
			dao.disable(player.getId(), items);
		}
		session.commit();
		return list(player.getId());
	}

	private Player readPlayer(int id) {
		Player player = session.getMapper(PlayerWhishDao.class).viewPlayer(id);
		while (player.getWishes().size() < MAX_ITEM) {
			PlayerWish wish = new PlayerWish();
			wish.setItem(noneItem());
			wish.setRatio(0);
			List<PlayerWish> wishes = new ArrayList<PlayerWish>(player.getWishes());
			wishes.add(wish);
			player.setWishes(wishes);
		}
		return player;
	}

	private List<Item> readItems(PlayerClass clazz) {
		List<Item> items = new ArrayList<>(session.getMapper(ItemDao.class).listForClass(clazz));
		items.add(0, noneItem());
		return items;
	}

	private Item noneItem() {
		Item item = new Item();
		item.setName("---");
		item.setId(0);
		return item;
	}

}
