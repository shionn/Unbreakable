package shionn.ubk.db.dbo;

public enum LootAttribution {
	wishList("WL"), primary("+1"), secondary("+2"), bag("0");
	private String shorten;

	private LootAttribution(String shorten) {
		this.shorten = shorten;
	}

	public String getShorten() {
		return shorten;
	}
}
