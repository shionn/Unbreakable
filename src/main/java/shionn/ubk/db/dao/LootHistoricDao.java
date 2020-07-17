package shionn.ubk.db.dao;

import java.util.List;

import org.apache.ibatis.annotations.Many;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Result;
import org.apache.ibatis.annotations.Results;
import org.apache.ibatis.annotations.Select;

import shionn.ubk.db.dbo.Loot;
import shionn.ubk.db.dbo.Player;

public interface LootHistoricDao {

	@Select("SELECT id, name, class, rank = 'reroll' AS reroll "
			+ "FROM player " //
			+ "WHERE rank != 'inactif' " //
			+ "ORDER BY reroll, class, name")
	@Results({
			@Result(column = "id", property = "loots", many = @Many(select = "listLoots")),
			@Result(column = "class", property = "clazz") })
	List<Player> listAll();

	@Select("SELECT item_name, item_big, loot_date, attribution " //
			+ "FROM loot_history " //
			+ "WHERE player_id = #{id} " //
			+ "ORDER BY loot_date DESC ")
	@Results({
			@Result(column = "item_name", property = "item.name"),
			@Result(column = "item_big", property = "item.big") })
	List<Loot> listLoots(@Param("id") int player);

	@Select("SELECT lh.item_name,      " //
			+ "  lh.item_big,          " //
			+ "  lh.loot_date,         " //
			+ "  lh.attribution,       " //
			+ "  lh.player_name        " //
			+ "FROM loot_history AS lh " //
			+ "WHERE attribution IN ('wishList', 'primary') " //
			+ "ORDER BY loot_date DESC ")
	@Results({
			@Result(column = "player_name", property = "player.name"),
			@Result(column = "item_name", property = "item.name"),
			@Result(column = "item_big", property = "item.big") })
	List<Loot> listWl();


}
