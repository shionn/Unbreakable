package shionn.ubk.db.dao;

import java.util.List;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import shionn.ubk.db.dbo.Item;
import shionn.ubk.db.dbo.ItemSlot;
import shionn.ubk.db.dbo.RaidInstance;

public interface ItemDao {

	@Insert("INSERT INTO item (name, raid, boss, ilvl, slot, big) " //
			+ "VALUES (#{name}, #{raid}, #{boss}, #{ilvl}, #{slot}, #{big}) ")
	int create(@Param("name") String name, @Param("raid") RaidInstance raid,
			@Param("boss") String boss, @Param("ilvl") int ilvl, @Param("slot") ItemSlot slot,
			@Param("big") boolean big);

	@Select("SELECT * FROM item ORDER BY name")
	List<Item> list();

	@Select("SELECT * FROM item where id = #{id}")
	Item readOne(int id);

	@Update("UPDATE item SET name = #{name}, raid = #{raid}, boss = #{boss}, "
			+ "ilvl = #{ilvl}, slot = #{slot}, big = #{big} "
			+ "WHERE id = #{id}")
	int update(@Param("id") int id, @Param("name") String name, @Param("raid") RaidInstance raid,
			@Param("boss") String boss, @Param("ilvl") int ilvl, @Param("slot") ItemSlot slot,
			@Param("big") boolean big);

}
