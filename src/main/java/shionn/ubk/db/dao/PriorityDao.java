package shionn.ubk.db.dao;

import java.util.List;

import org.apache.ibatis.annotations.Result;
import org.apache.ibatis.annotations.Results;
import org.apache.ibatis.annotations.Select;

import shionn.ubk.db.dbo.Priority;

public interface PriorityDao {

	@Select("SELECT p.name AS player_name, p.rank AS player_rank, p.class AS player_class, "
			+ "i.name AS item_name, " //
			+ "point, ratio " //
			+ "FROM item_priority AS ip "
			+ "INNER JOIN player  AS p ON p.id = ip.player AND p.rank != 'inactif' "
			+ "INNER JOIN item    AS i ON i.id = ip.item "
			+ "ORDER BY item_name ASC, point DESC, ratio DESC")
	@Results({ @Result(column = "player_name", property = "player.name"),
			@Result(column = "player_rank", property = "player.rank"),
			@Result(column = "player_class", property = "player.clazz"),
			@Result(column = "item_name", property = "item.name") })
	List<Priority> list();

}
