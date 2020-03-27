package shionn.ubk.db.dao;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import shionn.ubk.db.dbo.User;

public interface UserDao {

	@Select("SELECT * FROM user WHERE email = #{email}")
	User read(String email);

	@Insert("INSERT INTO user (name, email, pass) VALUES ( #{name}, #{email}, #{pass})")
	void create(@Param("name") String pseudo, @Param("email") String email,
			@Param("pass") String pass);

}
