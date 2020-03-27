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


public interface PlayerDao {

	@Insert("INSERT INTO player(name, class, rank) VALUES (#{name}, #{class}, #{rank})")
	void create(@Param("name") String name, @Param("class") PlayerClass clazz,
			@Param("rank") PlayerRank rank);

	@Select("SELECT * FROM player WHERE id = #{id}")
	@Results({ @Result(column = "class", property = "clazz") })
	Player readOne(int id);

	@Select("SELECT * FROM player ORDER BY name")
	List<Player> list();

	@Update("UPDATE player " //
			+ "SET name = #{name}, class = #{class}, rank = #{rank} " //
			+ "WHERE id = #{id}")
	int updatePlayer(@Param("id") int id, @Param("name") String name,
			@Param("class") PlayerClass clazz, @Param("rank") PlayerRank rank);
}
