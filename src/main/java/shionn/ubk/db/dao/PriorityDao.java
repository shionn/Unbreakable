package shionn.ubk.db.dao;

import java.util.List;

import org.apache.ibatis.annotations.Result;
import org.apache.ibatis.annotations.Results;
import org.apache.ibatis.annotations.Select;

import shionn.ubk.db.dbo.Priority;

public interface PriorityDao {

	@Select("SELECT p.name AS player_name, p.rank AS player_rank, p.class AS player_class, p.id AS player_id, "
			+ "i.name AS item_name, i.id AS item_id, " //
			+ "ip.point, ip.ratio, ip.nb_raid, ip.nb_loot, " //
			+ "pl.raid IS NOT NULL AS looted " //
			+ "FROM item_priority AS ip "
			+ "INNER JOIN player  AS p      ON p.id = ip.player AND p.rank != 'inactif' "
			+ "INNER JOIN item    AS i      ON i.id = ip.item "
			+ "LEFT  JOIN player_loot AS pl ON pl.player = ip.player AND pl.item = ip.item "
			+ "ORDER BY item_name ASC, looted ASC, point ASC")
	@Results({ @Result(column = "player_name", property = "player.name"),
			@Result(column = "player_rank", property = "player.rank"),
			@Result(column = "player_class", property = "player.clazz"),
			@Result(column = "item_name", property = "item.name"),
			@Result(column = "item_id", property = "item.id") })
	List<Priority> list();

}
