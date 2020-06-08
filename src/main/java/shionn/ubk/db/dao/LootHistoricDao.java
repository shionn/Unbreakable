package shionn.ubk.db.dao;

import java.util.List;

import org.apache.ibatis.annotations.Many;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Result;
import org.apache.ibatis.annotations.Results;
import org.apache.ibatis.annotations.Select;

import shionn.ubk.db.dbo.Item;
import shionn.ubk.db.dbo.Player;

public interface LootHistoricDao {

	@Select("SELECT * FROM player WHERE rank != 'inactif' ORDER BY class, name")
	@Results({ @Result(column = "id", property = "loots", many = @Many(select = "listItems")),
			@Result(column = "class", property = "clazz") })
	List<Player> listAll();

	@Select("SELECT item_name AS name, item_big AS big, loot_date, attribution " //
			+ "FROM loot_history " //
			+ "WHERE player_id = #{id} " //
			+ "ORDER BY loot_date DESC ")
	List<Item> listItems(@Param("id") int player);
}
