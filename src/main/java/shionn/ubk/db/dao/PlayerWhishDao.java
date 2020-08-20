package shionn.ubk.db.dao;

import java.util.List;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Many;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Result;
import org.apache.ibatis.annotations.Results;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import shionn.ubk.db.dbo.Player;
import shionn.ubk.db.dbo.PlayerWish;

public interface PlayerWhishDao {

	@Select("SELECT * FROM player WHERE id = #{id}")
	@Results({ @Result(column = "id", property = "id"),
			@Result(column = "class", property = "clazz"),
			@Result(column = "id", property = "wishes", many = @Many(select = "viewPlayerWish")) })
	Player viewPlayer(int player);

	@Select("SELECT i.name   AS item_name, " //
			+ "     i.id     AS item_id, " //
			+ "     pw.ratio " //
			+ "FROM       player_wish AS pw " //
			+ "INNER JOIN item        AS i  ON i.id = pw.item " //
			+ "WHERE player   = #{id} "//
			+ "  AND running  = true")
	@Results({ @Result(column = "item_name", property = "item.name"),
			@Result(column = "item_id", property = "item.id") })
	List<PlayerWish> viewPlayerWish(@Param("id") int player);

	@Insert("INSERT INTO player_wish (player, item, ratio) "
			+ "VALUES (#{player.id}, #{wish.item.id}, #{wish.ratio}) "
			+ "ON DUPLICATE KEY UPDATE ratio = #{wish.ratio}, running = true")
	int update(@Param("player") Player player, @Param("wish") PlayerWish wish);

	@Update("<script>UPDATE player_wish " //
			+ "  SET running = false " //
			+ "WHERE player = #{player} " //
			+ "  AND item NOT IN "
			+ "<foreach item='r' collection='items' open='(' close=')' separator=','>#{r}</foreach>"
			+ "</script>")
	int disable(@Param("player") int player, @Param("items") List<Integer> items);

	@Update("UPDATE player_wish " //
			+ "SET selected = NOT(selected) " //
			+ "WHERE player = #{player} AND item = #{item}")
	int updateSelected(@Param("player") int player, @Param("item") int item);

}
