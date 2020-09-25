package shionn.ubk.db.dbo;

public enum PlayerRank {
	test("Test"),
	casu("Casu"),
	reroll("Reroll"),
	pu("Associé"),
	membre("Membre"),
	inactif("Inactif");

	private String fr;

	private PlayerRank(String fr) {
		this.fr = fr;
	}

	public String getFr() {
		return fr;
	}
}
