package shionn.ubk.db.dbo;

public enum LootAttribution {
	wishList("WL", true), primary("+1", true), secondary("+2", false), bag("0", false);
	private String shorten;
	private boolean displayGp;

	private LootAttribution(String shorten, boolean displayGp) {
		this.shorten = shorten;
		this.displayGp = displayGp;
	}

	public String getShorten() {
		return shorten;
	}

	public boolean isDisplayGp() {
		return displayGp;
	}
}
