package shionn.ubk.db.dao;

import java.util.List;

import org.apache.ibatis.annotations.Many;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Result;
import org.apache.ibatis.annotations.Results;
import org.apache.ibatis.annotations.Select;

import shionn.ubk.db.dbo.Priority;
import shionn.ubk.db.dbo.RaidAttendance;

public interface PriorityDao {

	@Select("SELECT p.name AS player_name, p.rank AS player_rank, p.class AS player_class, p.id AS player_id, "
			+ "i.name AS item_name, i.id AS item_id, " //
			+ "ip.point, ip.ratio, ip.nb_raid, ip.nb_loot, " //
			+ "pl.raid IS NOT NULL AS looted, " //
			+ "ip.nb_raid_without_loot, ip.nb_raid_wait " //
			+ "FROM item_priority AS ip " //
			+ "INNER JOIN player  AS p      ON p.id = ip.player AND p.rank != 'inactif' "
			+ "INNER JOIN item    AS i      ON i.id = ip.item "
			+ "LEFT  JOIN player_loot AS pl ON pl.player = ip.player AND pl.item = ip.item "
			+ "ORDER BY ${orderBy}")
	@Results({ @Result(column = "player_name", property = "player.name"),
			@Result(column = "player_rank", property = "player.rank"),
			@Result(column = "player_class", property = "player.clazz"),
			@Result(column = "player_id", property = "player.id"),
			@Result(column = "player_id", property = "attendances", many = @Many(select = "listAttendance")),
			@Result(column = "item_name", property = "item.name"),
			@Result(column = "item_id", property = "item.id") })
	List<Priority> list(@Param("orderBy") String orderBy);

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

}
