package shionn.ubk.db.dao;

import java.util.List;

import org.apache.ibatis.annotations.Many;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Result;
import org.apache.ibatis.annotations.Results;
import org.apache.ibatis.annotations.Select;

import shionn.ubk.db.dbo.ItemStatic;
import shionn.ubk.db.dbo.PlayerStat;
import shionn.ubk.db.dbo.RaidAttendance;

public interface StatisticDao {

	@Select("SELECT p.id AS player, p.name, p.class, p.rank, "
			+ "IFNULL(ip.point,0) AS point, IFNULL(ip.nb_loot,0) AS nb_loot, " //
			+ "IFNULL(ip.nb_raid,0) AS nb_raid, " //
			+ "IFNULL(ip.nb_raid_without_loot,0) AS nb_raid_without_loot, " //
			+ "p.rank = 'reroll' AS reroll " //
			+ "FROM player             AS p " //
			+ "LEFT JOIN item_priority AS ip ON p.id = ip.player " //
			+ "WHERE p.rank != 'inactif' " //
			+ "GROUP BY player " //
			+ "ORDER BY reroll, class, name ")
	@Results({ @Result(column = "player", property = "player.id"),
			@Result(column = "name", property = "player.name"),
			@Result(column = "class", property = "player.clazz"),
			@Result(column = "rank", property = "player.rank"),
			@Result(column = "player", property = "attendances", many = @Many(select = "listAttendance")) })
	List<PlayerStat> listPlayerStatistic();

	@Select("( " //
			+ "  SELECT instance, attendance, 'always' AS period " //
			+ "  FROM raid_attendance " //
			+ "  WHERE player = #{id} " //
			+ ") UNION ( " //
			+ "  SELECT instance, attendance, 'day14' AS period " //
			+ "  FROM last_raid_attendance " //
			+ "  WHERE player = #{id} " //
			+ ") ORDER BY period ASC, instance ASC")
	List<RaidAttendance> listAttendance(@Param("id") int player);

	@Select("SELECT i.id, i.name, count(pl.player) AS count, max(r.date) AS last " //
			+ "FROM       item        AS i " //
			+ "INNER JOIN player_loot AS pl ON i.id = pl.item " //
			+ "INNER JOIN player      AS p  ON p.id = pl.player AND p.rank != 'inactif' " //
			+ "INNER JOIN raid        AS r  ON r.id = pl.raid " //
			+ "GROUP BY id " //
			+ "ORDER BY name ")
	List<ItemStatic> listItemStatistic();

}
