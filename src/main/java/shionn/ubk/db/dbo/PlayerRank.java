package shionn.ubk.db.dbo;

public enum PlayerRank {
	test("Test"),
	casu("Membre"),
	reroll("Reroll"),
	pu("Associé"),
	membre("Raider"),
	inactif("Inactif");

	private String fr;

	private PlayerRank(String fr) {
		this.fr = fr;
	}

	public String getFr() {
		return fr;
	}
}
