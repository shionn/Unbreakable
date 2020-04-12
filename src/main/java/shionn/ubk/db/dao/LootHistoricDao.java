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

	@Select("SELECT i.name, "
			+ "CASE " //
			+ "  WHEN pw.ratio IS NOT NULL THEN 'wishList' " //
			+ "  WHEN pl.ratio = 10        THEN 'primary' "
			+ "  WHEN i.id = 82            THEN 'bag' " //
			+ "  ELSE 'secondary' " //
			+ "END AS attribution " //
			+ "FROM player_loot       AS pl " //
			+ "INNER JOIN item        AS i  ON i.id = pl.item "
			+ "LEFT  JOIN player_wish AS pw ON i.id = pw.item AND pw.player = pl.player " //
			+ "WHERE pl.player = #{id} ")
	List<Item> listItems(@Param("id") int player);
}
