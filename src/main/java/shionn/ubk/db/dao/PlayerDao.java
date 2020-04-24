package shionn.ubk.db.dao;

import java.util.List;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Result;
import org.apache.ibatis.annotations.Results;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import shionn.ubk.db.dbo.Player;
import shionn.ubk.db.dbo.PlayerClass;
import shionn.ubk.db.dbo.PlayerRank;
import shionn.ubk.db.dbo.PlayerWish;


public interface PlayerDao {

	@Insert("INSERT INTO player(name, class, rank) VALUES (#{name}, #{class}, #{rank})")
	void create(@Param("name") String name, @Param("class") PlayerClass clazz,
			@Param("rank") PlayerRank rank);

	@Select("SELECT * FROM player WHERE id = #{id}")
	@Results({ @Result(column = "class", property = "clazz") })
	Player readOne(int id);

	@Select("SELECT * FROM player ORDER BY name")
	List<Player> listPlayers();

	@Select("SELECT p.name, p.class, p.rank, i.name AS item_name " //
			+ "FROM player           AS p "
			+ "LEFT JOIN player_wish AS pw ON p.id = pw.player AND pw.running = true "
			+ "LEFT JOIN item        AS i  ON i.id = pw.item " //
			+ "WHERE p.rank != 'inactif' " //
			+ "ORDER BY p.class, p.name ")
	@Results({ @Result(column = "name", property = "player.name"),
			@Result(column = "class", property = "player.clazz"),
			@Result(column = "rank", property = "player.rank"),
			@Result(column = "item_name", property = "item.name") })
	List<PlayerWish> listWishes();

	@Update("UPDATE player " //
			+ "SET name = #{name}, class = #{class}, rank = #{rank} " //
			+ "WHERE id = #{id}")
	int updatePlayer(@Param("id") int id, @Param("name") String name,
			@Param("class") PlayerClass clazz, @Param("rank") PlayerRank rank);
}
