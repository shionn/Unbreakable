package shionn.ubk.db.dao;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Many;
import org.apache.ibatis.annotations.Options;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Result;
import org.apache.ibatis.annotations.Results;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import shionn.ubk.db.dbo.Item;
import shionn.ubk.db.dbo.PlayerClass;

public interface ItemDao {

	@Insert("INSERT INTO item (name, raid, boss, ilvl, slot, big, gp) " //
			+ "VALUES (#{name}, #{raid}, #{boss}, #{ilvl}, #{slot}, #{big}, #{gp}) ")
	@Options(useGeneratedKeys = true, keyColumn = "id", keyProperty = "id")
	int create(Item item);

	@Insert("INSERT INTO item_assignment (item, class) VALUES (#{item}, #{class})")
	int createItemAssignment(@Param("item") int item, @Param("class") PlayerClass clazz);

	@Delete("DELETE FROM item_assignment WHERE item = #{id}")
	int deleteItemAssignment(int id);

	@Select("SELECT * FROM item ORDER BY name")
	List<Item> list();

	@Select("SELECT i.id, i.name " //
			+ "FROM       item            AS i " //
			+ "INNER JOIN item_assignment AS ia ON ia.item = i.id AND ia.class = #{class} "
			+ "ORDER BY name")
	List<Item> listForClass(PlayerClass clazz);

	@Select("SELECT * FROM item WHERE id = #{id}")
	@Results({
			@Result(column = "id", property = "id"),
			@Result(column = "id", property = "classes", many = @Many(select = "readItemAssignment")) })
	Item readOne(int id);

	@Select("SELECT class FROM item_assignment WHERE item = #{id}")
	List<PlayerClass> readItemAssignment(int id);

	@Update("UPDATE item SET name = #{name}, raid = #{raid}, boss = #{boss}, "
			+ "ilvl = #{ilvl}, slot = #{slot}, big = #{big}, gp = #{gp} "
			+ "WHERE id = #{id}")
	int update(Item item);

	@Select("SELECT * FROM item " //
			+ "WHERE raid = (SELECT instance FROM raid WHERE id = #{id}) " //
			+ "ORDER BY raid DESC, name ASC")
	List<Item> listForRaid(int raid);

	@Select("SELECT i.id, i.name, pw.attribution " //
			+ "FROM       item            AS i "
			+ "INNER JOIN item_assignment AS ia ON ia.item = i.id "
			+ "INNER JOIN player          AS p  ON p.class = ia.class AND p.id = #{player} " //
			+ "LEFT  JOIN player_wish     AS pw ON pw.item = i.id AND pw.player = p.id AND pw.running " //
			+ "WHERE i.raid = (SELECT instance FROM raid WHERE id = #{raid}) " //
			+ "ORDER BY raid DESC, name ASC")
	List<Item> listForRaidAndPlayer(@Param("raid") int raid, @Param("player") int player);


}
