package shionn.ubk.db.dbo;

public enum ItemSlot {
	back(0.55),
	chest (1),
	head(1),
	hands(0.777),
	feet(0.777),
	finger(0.55),
	legs (1),
	neck(0.55),
	offHand(0.55),
	rangedWeapon(0.42),
	shield(0.55),
	shoulder(0.777),
	trinket(0.7),
	waist(0.777), // ceinture
	wand(0.42),
	weapon1h(0.42),
	weapon2h (1),
	wrist(0.55); // poignet

	private double gpRatio;

	private ItemSlot(double gpRatio) {
		this.gpRatio = gpRatio;
	}

	public double getGpRatio() {
		return gpRatio;
	}
}
