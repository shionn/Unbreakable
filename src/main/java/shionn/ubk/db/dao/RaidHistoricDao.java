package shionn.ubk.db.dao;

import java.util.List;

import org.apache.ibatis.annotations.Many;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Result;
import org.apache.ibatis.annotations.Results;
import org.apache.ibatis.annotations.Select;

import shionn.ubk.db.dbo.Item;
import shionn.ubk.db.dbo.Raid;
import shionn.ubk.db.dbo.RaidEntry;

public interface RaidHistoricDao {

	@Select("SELECT * FROM raid ORDER BY date DESC")
	@Results({ @Result(column = "id", property = "id"),
			@Result(column = "id", property = "players", many = @Many(select = "listPlayer")) })
	List<Raid> listAll();

	@Select("SELECT p.id, name, class, rank, raid, r.bench " //
			+ "FROM player AS p " //
			+ "INNER JOIN raid_entry AS r ON p.id = r.player AND r.raid = #{raid} "
			+ "WHERE r.visible = true " //
			+ "ORDER BY class, name")
	@Results({ @Result(column = "name", property = "player.name"),
			@Result(column = "class", property = "player.clazz"),
			@Result(column = "rank", property = "player.rank"),
			@Result(column = "{player=id,raid=raid}", property = "items", many = @Many(select = "listLoot")) })
	List<RaidEntry> listPlayer(@Param("raid") int raid);

	@Select("SELECT i.name, i.id, l.ratio " //
			+ "FROM player_loot AS l " //
			+ "INNER JOIN item AS i ON i.id = l.item "
			+ "WHERE l.player = #{player} AND l.raid = #{raid} " //
			+ "ORDER BY name ")
	public List<Item> listLoot(@Param("player") int player, @Param("raid") int raid);
}
