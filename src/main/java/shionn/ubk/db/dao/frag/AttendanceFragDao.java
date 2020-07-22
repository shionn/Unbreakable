package shionn.ubk.db.dao.frag;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import shionn.ubk.db.dbo.RaidAttendance;

public interface AttendanceFragDao {
	@Select("( " //
			+ "  SELECT instance, attendance, 'always' AS period " //
			+ "  FROM raid_attendance " //
			+ "  WHERE player = #{id} " //
			+ ") UNION ( " //
			+ "  SELECT instance, attendance, 'day14' AS period " //
			+ "  FROM last_raid_attendance " //
			+ "  WHERE player = #{id} " //
			+ ") ORDER BY period ASC, instance ASC")
	List<RaidAttendance> listAttendance(@Param("id") int player);

}
