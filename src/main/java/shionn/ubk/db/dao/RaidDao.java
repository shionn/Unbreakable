package shionn.ubk.db.dao;

import java.util.Date;
import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Result;
import org.apache.ibatis.annotations.Results;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

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
			@Result(column = "id", property = "player.id") })
	public List<RaidEntry> listRunningPlayer(@Param("raid") int raid,
			@Param("order") SortOrder order);

	@Insert("INSERT INTO raid (name, date, point, running) "
			+ "VALUES (#{name}, #{date}, #{point}, true)")
	public void create(@Param("name") String name, @Param("date") Date date,
			@Param("point") int point);

	@Update("UPDATE raid SET name = #{name}, " //
			+ "start = #{start}, end = #{end}, " //
			+ "running = #{running}, boss = #{boss} " //
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

	//
	//	@Insert("INSERT INTO `dkp-entry` (player, raid, user, reason, `value-type`, value, `date`) "
	//			+ "VALUE (#{player}, #{raid}, #{author}, #{reason}, 'amount', #{dkp}, #{date} )")
	//	public int addDkpEntry(@Param("player") int player, @Param("raid") int raid,
	//			@Param("author") int author, @Param("reason") String reason,
	//			@Param("dkp") int dkp, @Param("date") Date date);

}
