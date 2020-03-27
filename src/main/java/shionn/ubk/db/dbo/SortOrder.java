package shionn.ubk.db.dbo;

public enum SortOrder {
	name("name ASC"), point("point DESC, ratio DESC"), clazz("class ASC, name ASC");

	private String sql;

	private SortOrder(String sql) {
		this.sql = sql;
	}

	public String getSql() {
		return sql;
	}

}
