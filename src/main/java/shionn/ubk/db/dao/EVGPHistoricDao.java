package shionn.ubk.db.dao;

import java.util.List;

import org.apache.ibatis.annotations.Many;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Result;
import org.apache.ibatis.annotations.Results;
import org.apache.ibatis.annotations.Select;

import shionn.ubk.db.dbo.EvgpHistory;
import shionn.ubk.db.dbo.Loot;

public interface EVGPHistoricDao {

	@Select("SELECT * FROM player_ev_er_history ORDER BY date DESC, instance, class, name ")
	@Results({
			@Result(column = "player", property = "player.id"),
			@Result(column = "name", property = "player.name"),
			@Result(column = "class", property = "player.clazz"),
			@Result(column = "raid", property = "raid.id"),
			@Result(column = "raid_name", property = "raid.name"),
			@Result(column = "date", property = "raid.date"),
			@Result(column = "instance", property = "raid.instance"),
			@Result(column = "ev", property = "stat.ev"),
			@Result(column = "ev_initial", property = "stat.evInitial"),
			@Result(column = "er", property = "stat.er"),
			@Result(column = "er_initial", property = "stat.erInitial"),
			@Result(column = "{player=player, raid=raid}", property = "player.loots", many = @Many(select = "listPlayerLoot"))
	})
	List<EvgpHistory> listAll();

	@Select("SELECT * " //
			+ "FROM loot_history " //
			+ "WHERE player_id = #{player} AND raid = #{raid} AND attribution = 'primary' ")
	@Results({
			@Result(column = "item_name", property = "item.name"),
			@Result(column = "item_big", property = "item.big"), })
	List<Loot> listPlayerLoot(@Param("player") int player, @Param("raid") int raid);

}
