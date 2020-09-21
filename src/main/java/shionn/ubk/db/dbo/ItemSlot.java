package shionn.ubk.db.dbo;

public enum ItemSlot {
	back(0.55, "Cape"),
	chest(1, "Torse"),
	head(1, "Casque"),
	hands(0.777, "Gant"),
	feet(0.777, "Botte"),
	finger(0.55, "Anneau"),
	legs(1, "Jambiere"),
	neck(0.55, "Collier"),
	offHand(0.55, "Main gauche"),
	rangedWeapon(0.42, "Arme a distance"),
	shield(0.55, "Bouclier"),
	shoulder(0.777, "Epauliere"),
	trinket(0.7, "Bijou"),
	waist(0.777, "Ceinture"),
	wand(0.42, "Baguette"),
	weapon1h(0.42, "Arme a une main"),
	weapon2h(1, "Arme a deux mains"),
	wrist(0.55, "Bracelet");

	private double gpRatio;
	private String fr;

	private ItemSlot(double gpRatio, String fr) {
		this.gpRatio = gpRatio;
		this.fr = fr;
	}

	public double getGpRatio() {
		return gpRatio;
	}

	public String getFr() {
		return fr;
	}
}
