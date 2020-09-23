package shionn.ubk.raid.dispatcher;

enum LineType {
	Tank(true, RaidPresence.Present),
	Hunter(true, RaidPresence.Present),
	Priest(true, RaidPresence.Present),
	Warrior(true, RaidPresence.Present),
	Mage(true, RaidPresence.Present),
	Paladin(true, RaidPresence.Present),
	Rogue(true, RaidPresence.Present),
	Warlock(true, RaidPresence.Present),
	Druid(true, RaidPresence.Present),
	Late(false, RaidPresence.Late),
	Bench(false, RaidPresence.Bench),
	Tentative(false, RaidPresence.Tentative),
	Absence(false, RaidPresence.Absence);

	private boolean haveClasse;
	private RaidPresence presence;

	private LineType(boolean haveClasse, RaidPresence presence) {
		this.haveClasse = haveClasse;
		this.presence = presence;
	}

	public boolean haveClasse() {
		return haveClasse;
	}

	public RaidPresence presence() {
		return presence;
	}
}
