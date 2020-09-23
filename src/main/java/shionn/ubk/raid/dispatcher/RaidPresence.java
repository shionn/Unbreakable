package shionn.ubk.raid.dispatcher;

enum RaidPresence {
	Present(1), Late(3), Bench(2), Tentative(4), Absence(99);

	private int priority;

	private RaidPresence(int priority) {
		this.priority = priority;
	}

	public int priority() {
		return priority;
	}
}
