package shionn.ubk.db.dao;

import java.util.List;

import org.apache.ibatis.annotations.One;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Result;
import org.apache.ibatis.annotations.Results;
import org.apache.ibatis.annotations.Select;

import shionn.ubk.db.dbo.Priority;

public interface PriorityDao {

	@Select("SELECT p.name AS player_name, p.rank AS player_rank, p.class AS player_class, p.id AS player_id, "
			+ "i.name AS item_name, i.id AS item_id, " //
			+ "ip.point, ip.ratio, " //
			+ "pl.raid IS NOT NULL AS looted " //
			+ "FROM item_priority AS ip "
			+ "INNER JOIN player  AS p      ON p.id = ip.player AND p.rank != 'inactif' "
			+ "INNER JOIN item    AS i      ON i.id = ip.item "
			+ "LEFT  JOIN player_loot AS pl ON pl.player = ip.player AND pl.item = ip.item "
			+ "ORDER BY item_name ASC, looted ASC, point DESC, ratio DESC")
	@Results({ @Result(column = "player_name", property = "player.name"),
			@Result(column = "player_rank", property = "player.rank"),
			@Result(column = "player_class", property = "player.clazz"),
			@Result(column = "item_name", property = "item.name"),
			@Result(column = "player_id", property = "nbRaid", one = @One(select = "countRaid")),
			@Result(column = "player_id", property = "nbLoot", one = @One(select = "countLoot")),
			@Result(column = "item_id", property = "item.id") })
	List<Priority> list();

	@Select("SELECT COUNT(raid) FROM raid_entry WHERE player = #{player}")
	int countRaid(@Param("player") int player);

	@Select("SELECT SUM(ratio)/10 FROM player_loot WHERE player = #{player}")
	int countLoot(@Param("player") int player);

}
