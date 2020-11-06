package shionn.ubk.db.dao;

import java.util.List;

import org.apache.ibatis.annotations.Many;
import org.apache.ibatis.annotations.Result;
import org.apache.ibatis.annotations.Results;
import org.apache.ibatis.annotations.Select;

import shionn.ubk.db.dao.frag.AttendanceFragDao;
import shionn.ubk.db.dbo.ItemStatic;
import shionn.ubk.db.dbo.PlayerStat;

public interface StatisticDao extends AttendanceFragDao {

	@Select("SELECT player, name, display_name, class, rank, " //
			+ "nb_loot, nb_raid, nb_raid_without_loot, " //
			+ "ev, gp, ROUND(ratio*100) AS evgp_ratio, " //
			+ "rank = 'reroll' AS reroll, rank = 'pu' AS pu  " //
			+ "FROM player_statistic " //
			+ "WHERE rank != 'inactif' " //
			+ "ORDER BY reroll, class, name ")
	@Results({ @Result(column = "player", property = "player.id"),
			@Result(column = "name", property = "player.name"),
			@Result(column = "display_name", property = "player.displayName"),
			@Result(column = "class", property = "player.clazz"),
			@Result(column = "rank", property = "player.rank"),
			@Result(column = "player", property = "attendances", many = @Many(select = "listAttendance")) })
	List<PlayerStat> listPlayerStatistic();

	@Select("SELECT i.id, i.name, count(pl.player) AS count, max(r.date) AS last " //
			+ "FROM       item        AS i " //
			+ "INNER JOIN player_loot AS pl ON i.id = pl.item " //
			+ "INNER JOIN player      AS p  ON p.id = pl.player AND p.rank != 'inactif' " //
			+ "INNER JOIN raid        AS r  ON r.id = pl.raid " //
			+ "GROUP BY id " //
			+ "ORDER BY name ")
	List<ItemStatic> listItemStatistic();

}
