package shionn.ubk.db.dao;

import java.util.List;

import org.apache.ibatis.annotations.Many;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Result;
import org.apache.ibatis.annotations.Results;
import org.apache.ibatis.annotations.Select;

import shionn.ubk.db.dbo.Armory;
import shionn.ubk.db.dbo.ArmoryGroup;
import shionn.ubk.db.dbo.RaidInstance;

public interface ArmoryDao {

	@Select("SELECT distinct(raid) AS raid FROM armory ORDER BY raid")
	@Results({ @Result(column = "raid", property = "raid"),
			@Result(column = "raid", property = "players", many = @Many(select = "listPlayers")),
			@Result(column = "raid", property = "items", many = @Many(select = "listItems")),
			@Result(column = "raid", property = "armories", many = @Many(select = "listArmories"))
		})
	List<ArmoryGroup> listGroups();

	@Select("SELECT player, player_name, class AS clazz " //
			+ "FROM armory WHERE raid = #{raid} " //
			+ "GROUP BY player ORDER BY player_name")
	List<Armory> listPlayers(@Param("raid") RaidInstance raid);

	@Select("SELECT item, item_name, class AS clazz " //
			+ "FROM armory WHERE raid = #{raid} " //
			+ "GROUP BY item, clazz ORDER BY item_name")
	List<Armory> listItems(@Param("raid") RaidInstance raid);

	@Select("SELECT * FROM armory WHERE raid = #{raid} ")
	List<Armory> listArmories(@Param("raid") RaidInstance raid);

}
