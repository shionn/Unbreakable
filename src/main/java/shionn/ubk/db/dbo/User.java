package shionn.ubk.db.dbo;

import org.apache.commons.lang3.StringUtils;

public class User {

	private int id;
	private String pass;
	private String role;

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getPass() {
		return pass;
	}

	public void setPass(String pass) {
		this.pass = pass;
	}

	public String getRole() {
		return role;
	}

	public void setRole(String role) {
		this.role = role;
	}

	public boolean isAdmin() {
		return role != null && role.contains("ADMIN");
	}

	public boolean isMdc() {
		return role != null && role.contains("MDC");
	}

	public boolean isSuperAdmin() {
		return role != null && role.contains("SUPER_ADMIN");
	}

	public boolean isMl() {
		return role != null && role.contains("ML");
	}

	public String getRoles() {
		return StringUtils.join(role, ", ");
	}
}
