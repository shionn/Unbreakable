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

import shionn.ubk.db.dao.frag.AttendanceFragDao;
import shionn.ubk.db.dbo.Loot;
import shionn.ubk.db.dbo.LootAttribution;
import shionn.ubk.db.dbo.Priority;
import shionn.ubk.db.dbo.Raid;
import shionn.ubk.db.dbo.RaidEntry;
import shionn.ubk.db.dbo.RaidInstance;
import shionn.ubk.db.dbo.SortOrder;


public interface RaidDao extends AttendanceFragDao {

	@Select("SELECT * FROM raid WHERE running IS true ORDER BY date ASC")
	public List<Raid> listRunnings();

	@Select("SELECT * " //
			+ "FROM player AS p " //
			+ "INNER JOIN raid_entry AS e ON e.player = p.id AND e.raid = #{raid} "
			+ "ORDER BY ${order.sql}")
	@Results({ @Result(column = "id", property = "player.id"),
			@Result(column = "name", property = "player.name"),
			@Result(column = "display_name", property = "player.displayName"),
			@Result(column = "rank", property = "player.rank"),
			@Result(column = "class", property = "player.clazz"),
			@Result(column = "{player=id, raid=raid}", property = "loots", many = @Many(select = "listLoot")) })
	public List<RaidEntry> listRunningPlayer(@Param("raid") int raid,
			@Param("order") SortOrder order);

	@Select("SELECT i.name, i.id, l.attribution " //
			+ "FROM       player_loot AS l " //
			+ "INNER JOIN item AS i   ON i.id = l.item " //
			+ "WHERE l.player = #{player} AND l.raid = #{raid} " //
			+ "ORDER BY name ")
	@Results({
			@Result(column = "name", property = "item.name"),
			@Result(column = "id", property = "item.id") })
	public List<Loot> listLoot(@Param("player") int player, @Param("raid") int raid);

	@Insert("INSERT INTO raid (name, instance, date, running) " //
			+ "VALUES (#{name}, #{instance}, #{date}, true)")
	public void create(@Param("name") String name, @Param("instance") RaidInstance instance,
			@Param("date") Date date);

	@Update("UPDATE raid SET name = #{name}, instance = #{instance}, " //
			+ "date = #{date}, running = #{running}, reroll_as_main = #{rerollAsMain} " //
			+ "WHERE id = #{id} ")
	public void update(Raid raid);

	@Select("SELECT * FROM raid WHERE id = #{id}")
	public Raid read(int id);

	@Select("SELECT p.id, p.name, p.class, p.rank, p.display_name, " //
			+ "  r.raid AS member, r.bench, " //
			+ "  IFNULL(r.visible, true) AS visible, " //
			+ "  p.rank = 'reroll' AS reroll, p.rank = 'pu' AS pu " //
			+ "FROM       player      AS p " //
			+ "LEFT JOIN  raid_entry  AS r ON r.player = p.id AND r.raid = #{raid} " //
			+ "WHERE p.rank != 'inactif' " //
			+ "ORDER BY pu, reroll, class, name")
	@Results({ @Result(column = "id", property = "player.id"),
			@Result(column = "name", property = "player.name"),
			@Result(column = "display_name", property = "player.displayName"),
			@Result(column = "class", property = "player.clazz"),
			@Result(column = "rank", property = "player.rank") })
	public List<RaidEntry> readPlayers(@Param("raid") int raid);

	@Delete("DELETE FROM raid_player_wish WHERE raid = #{raid}")
	public int removeRaidPlayerWish(@Param("raid") int raid);

	@Delete("DELETE FROM raid_entry WHERE raid = #{raid}")
	public int removeRaidEntry(@Param("raid") int raid);

	@Insert("INSERT INTO raid_entry (raid, player, bench, visible) VALUES (#{raid}, #{player}, #{bench}, #{visible})")
	public int addMember(@Param("raid") int raid, @Param("player") int player,
			@Param("bench") boolean bench, @Param("visible") boolean visible);

	@Insert("INSERT INTO raid_player_wish (raid, player, item, attribution) "
			+ "VALUES (#{raid}, #{player}, #{item}, #{attribution})")
	public int addRaidPlayerWish(@Param("raid") int raid, @Param("player") int player,
			@Param("item") int item, @Param("attribution") LootAttribution attribution);

	@Insert("INSERT INTO player_loot (raid, player, item, attribution, wl) "
			+ "VALUES(#{raid}, #{player}, #{item}, #{attribution}, #{wl})")
	public int addLoot(@Param("raid") int raid, //
			@Param("player") int player, //
			@Param("item") int item, //
			@Param("attribution") LootAttribution attribution, //
			@Param("wl") boolean wl);

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

	@Update("UPDATE raid SET running = true WHERE id = #{id}")
	public void startEdit(@Param("id") int id);

	@Select("SELECT p.name        AS player_name, " //
			+ "  p.rank           AS player_rank, " //
			+ "  p.class          AS player_class, " //
			+ "  p.id             AS player_id, " //
			+ "  ip.point, " //
			+ "  ip.attribution, " //
			+ "  ip.nb_raid, " //
			+ "  ip.nb_loot, " //
			+ "  pl.raid          IS NOT NULL AS looted, " //
			+ "  ip.nb_raid_without_loot, " //
			+ "  ip.nb_raid_wait, " //
			+ "  ip.ev, " //
			+ "  ip.gp, " //
			+ "  ip.evgp_ratio " //
			+ "FROM item_priority     AS ip " //
			+ "INNER JOIN player      AS p  ON p.id  = ip.player     AND p.rank != 'inactif' "
			+ "INNER JOIN raid_entry  AS re ON re.player = ip.player AND re.raid = #{raid} "
			+ "LEFT  JOIN player_loot AS pl ON pl.player = ip.player AND pl.item = ip.item " //
			+ "WHERE ip.item = #{item} " //
			+ "ORDER BY evgp_ratio ASC")
	@Results({
			@Result(column = "player_name", property = "player.name"),
			@Result(column = "player_rank", property = "player.rank"),
			@Result(column = "player_class", property = "player.clazz"),
			@Result(column = "player_id", property = "player.id"),
			@Result(column = "player_id", property = "stat.attendances", many = @Many(select = "listAttendance")),
			@Result(column = "nb_raid", property = "stat.nbRaid"),
			@Result(column = "nb_loot", property = "stat.nbLoot"),
			@Result(column = "nb_raid_without_loot", property = "stat.nbRaidWithoutLoot"),
			@Result(column = "ev", property = "stat.ev"),
			@Result(column = "gp", property = "stat.gp"),
			@Result(column = "evgp_ratio", property = "stat.evgpRatio") })
	List<Priority> listItemHelp(@Param("item") int item, @Param("raid") int raid);

	@Select("SELECT p.name      AS player_name, " //
			+ "  p.rank         AS player_rank, " //
			+ "  p.class        AS player_class, " //
			+ "  p.id           AS player_id, " //
			+ "  ip.point, " // ?
			+ "  ip.attribution, " //
			+ "  ip.nb_raid, " //
			+ "  ip.nb_loot, " //
			+ "  pl.raid IS NOT NULL   AS looted, " //
			+ "  ip.nb_raid_without_loot, " //
			+ "  ip.nb_raid_wait, " //
			+ "  ip.ev, " //
			+ "  ip.er, " //
			+ "  ip.gp, " //
			+ "  ip.evgp_ratio, " //
			+ "  ip.ergp_ratio, " //
			+ "  ip.item AS item_id, " //
			+ "  ip.item_name AS item_name, " //
			+ "  i.boss AS item_boss, " //
			+ "  ip.last_loot_date " //
			+ "FROM item_priority     AS ip " //
			+ "INNER JOIN player      AS p  ON ip.player = p.id      AND p.rank != 'inactif' "
			+ "INNER JOIN raid_entry  AS re ON ip.player = re.player AND re.raid = #{raid} "
			+ "INNER JOIN raid        AS r  ON re.raid   = r.id "
			+ "INNER JOIN item        AS i  ON ip.item   = i.id      AND i.raid  = r.instance "
			+ "LEFT  JOIN player_loot AS pl ON ip.player = pl.player AND pl.item = ip.item "
			+ "ORDER BY item_name, evgp_ratio ASC")
	@Results({
			@Result(column = "item_id", property = "item.id"),
			@Result(column = "item_name", property = "item.name"),
			@Result(column = "item_boss", property = "item.boss"),
			@Result(column = "player_name", property = "player.name"),
			@Result(column = "player_rank", property = "player.rank"),
			@Result(column = "player_class", property = "player.clazz"),
			@Result(column = "player_id", property = "player.id"),
			@Result(column = "player_id", property = "stat.attendances", many = @Many(select = "listAttendance")),
			@Result(column = "nb_raid", property = "stat.nbRaid"),
			@Result(column = "nb_loot", property = "stat.nbLoot"),
			@Result(column = "nb_raid_without_loot", property = "stat.nbRaidWithoutLoot"),
			@Result(column = "last_loot_date", property = "stat.lastLootDate"),
			@Result(column = "ev", property = "stat.ev"),
			@Result(column = "er", property = "stat.er"),
			@Result(column = "gp", property = "stat.gp"),
			@Result(column = "evgp_ratio", property = "stat.evgpRatio"),
			@Result(column = "ergp_ratio", property = "stat.ergpRatio") })
	List<Priority> listWishList(@Param("raid") int id);

}
