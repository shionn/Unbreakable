package shionn.ubk.db.dao;

import java.util.List;

import org.apache.ibatis.annotations.Many;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Result;
import org.apache.ibatis.annotations.Results;
import org.apache.ibatis.annotations.Select;

import shionn.ubk.db.dbo.Loot;
import shionn.ubk.db.dbo.Raid;
import shionn.ubk.db.dbo.RaidEntry;

public interface RaidHistoricDao {

	@Select("SELECT r.id, r.name, r.date, r.instance, ev.ev, ev.initial_ev " //
			+ "FROM      raid    AS r " //
			+ "LEFT JOIN raid_ev AS ev ON r.id = ev.raid " //
			+ "ORDER BY date DESC")
	@Results({ @Result(column = "id", property = "id"),
			@Result(column = "id", property = "players", many = @Many(select = "listPlayer")) })
	List<Raid> listAll();

	@Select("SELECT p.id, name, class, rank, raid, r.bench " //
			+ "FROM player AS p " //
			+ "INNER JOIN raid_entry AS r ON p.id = r.player AND r.raid = #{raid} "
			+ "WHERE r.visible = true " //
			+ "ORDER BY class, name")
	@Results({ @Result(column = "name", property = "player.name"),
			@Result(column = "class", property = "player.clazz"),
			@Result(column = "rank", property = "player.rank"),
			@Result(column = "{player=id,raid=raid}", property = "loots", many = @Many(select = "listLoot")) })
	List<RaidEntry> listPlayer(@Param("raid") int raid);

	@Select("SELECT item_name, attribution, gp, initial_gp " //
			+ "FROM loot_history " //
			+ "WHERE player_id = #{player} AND raid = #{raid} " //
			+ "ORDER BY item_name ")
	@Results({ @Result(column = "item_name", property = "item.name") })
	public List<Loot> listLoot(@Param("player") int player, @Param("raid") int raid);
}
