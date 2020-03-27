package shionn.ubk.db.dao;

import java.util.Date;
import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Many;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Result;
import org.apache.ibatis.annotations.Results;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import shionn.ubk.db.dbo.Item;
import shionn.ubk.db.dbo.Raid;
import shionn.ubk.db.dbo.RaidEntry;
import shionn.ubk.db.dbo.SortOrder;


public interface RaidDao {

	@Select("SELECT * FROM raid WHERE running IS true")
	public List<Raid> listRunnings();

	@Select("SELECT * " //
			+ "FROM player AS p " //
			+ "INNER JOIN raid_entry AS e ON e.player = p.id AND e.raid = #{raid} "
			+ "ORDER BY ${order.sql}")
	@Results({ @Result(column = "id", property = "player.id"),
			@Result(column = "name", property = "player.name"),
			@Result(column = "rank", property = "player.rank"),
			@Result(column = "class", property = "player.clazz"),
			@Result(column = "{player=id, raid=raid}", property = "items", many = @Many(select = "listLoot")) })
	public List<RaidEntry> listRunningPlayer(@Param("raid") int raid,
			@Param("order") SortOrder order);

	@Select("SELECT i.name, i.id " //
			+ "FROM player_loot AS l "
			+ "INNER JOIN item AS i ON i.id = l.item "
			+ "WHERE l.player = #{player} AND l.raid = #{raid} " //
			+ "ORDER BY name ")
	public List<Item> listLoot(@Param("player") int player, @Param("raid") int raid);

	@Insert("INSERT INTO raid (name, date, point, running) "
			+ "VALUES (#{name}, #{date}, #{point}, true)")
	public void create(@Param("name") String name, @Param("date") Date date,
			@Param("point") int point);

	@Update("UPDATE raid SET name = #{name}, " //
			+ "date = #{date}, running = #{running}, point = #{point} " //
			+ "WHERE id = #{id} ")
	public void update(Raid raid);

	@Select("SELECT * FROM raid WHERE id = #{id}")
	public Raid read(int id);

	@Select("SELECT p.id, p.name, p.class, p.rank, r.raid AS member " //
			+ "FROM       player      AS p " //
			+ "LEFT JOIN  raid_entry  AS r ON r.player = p.id AND r.raid = #{raid} " //
			+ "WHERE p.rank != 'inactif' " //
			+ "ORDER by name")
	@Results({ @Result(column = "id", property = "player.id"),
			@Result(column = "name", property = "player.name"),
			@Result(column = "class", property = "player.clazz"),
			@Result(column = "rank", property = "player.rank") })
	public List<RaidEntry> readPlayers(@Param("raid") int raid);

	@Delete("DELETE FROM raid_player_wish WHERE raid = #{raid}")
	public int removeRaidPlayerWish(@Param("raid") int raid);

	@Delete("DELETE FROM raid_entry WHERE raid = #{raid}")
	public int removeRaidEntry(@Param("raid") int raid);

	@Insert("INSERT INTO raid_entry (raid, player) VALUES (#{raid}, #{player})")
	public int addMember(@Param("raid") int raid, @Param("player") int player);

	@Insert("INSERT INTO raid_player_wish (raid, player, item, ratio) "
			+ "VALUES (#{raid}, #{player}, #{item}, #{ratio})")
	public int addRaidPlayerWish(@Param("raid") int raid, @Param("player") int player,
			@Param("item") int item, @Param("ratio") int ratio);

	@Insert("INSERT INTO player_loot (raid, player, item) VALUES(#{raid}, #{player}, #{item})")
	public int addLoot(@Param("raid") int raid, @Param("player") int player,
			@Param("item") int item);

	@Delete("DELETE FROM player_loot WHERE raid = #{raid} AND player = #{player} AND item = #{item}")
	public int removeLoot(@Param("raid") int raid, @Param("player") int player,
			@Param("item") int item);

	@Update("UPDATE       player_wish AS pw "
			+ "INNER JOIN player_loot AS pl ON pw.player = pl.player "
			+ "                            AND pw.item   = pl.item "
			+ "                            AND pl.raid   = #{raid} " //
			+ "SET pw.running = false "
	)
	public void closeLootedWish(@Param("raid") int raid);
}
