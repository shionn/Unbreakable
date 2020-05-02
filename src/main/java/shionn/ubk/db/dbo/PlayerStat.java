package shionn.ubk.db.dbo;

import java.util.List;

public class PlayerStat {
	private Player player;
	private int ratio;
	private int nbRaid;
	private int nbRaidWithoutLoot;
	private int nbLoot;
	private List<RaidAttendance> attendances;

	public Player getPlayer() {
		return player;
	}

	public void setPlayer(Player player) {
		this.player = player;
	}

	public int getRatio() {
		return ratio;
	}

	public void setRatio(int ratio) {
		this.ratio = ratio;
	}

	public int getNbRaid() {
		return nbRaid;
	}

	public void setNbRaid(int nbRaid) {
		this.nbRaid = nbRaid;
	}

	public int getNbRaidWithoutLoot() {
		return nbRaidWithoutLoot;
	}

	public void setNbRaidWithoutLoot(int nbRaidWithoutLoot) {
		this.nbRaidWithoutLoot = nbRaidWithoutLoot;
	}

	public int getNbLoot() {
		return nbLoot;
	}

	public void setNbLoot(int nbLoot) {
		this.nbLoot = nbLoot;
	}

	public List<RaidAttendance> getAttendances() {
		return attendances;
	}

	public void setAttendances(List<RaidAttendance> attendances) {
		this.attendances = attendances;
	}

}
