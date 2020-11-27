package shionn.ubk.db.dbo;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class PlayerStat {
	private Player player;
	private int nbRaid;
	private int nbRaidWithoutLoot;
	private int nbLoot;
	private int ev, er, gp, evgpRatio, ergpRatio;
	private int evInitial, erInitial;
	private List<RaidAttendance> attendances = new ArrayList<RaidAttendance>();
	private Date lastLootDate;

	public Player getPlayer() {
		return player;
	}

	public void setPlayer(Player player) {
		this.player = player;
	}

	public int getRatio() {
		return nbRaid == 0 ? 0 : nbLoot * 100 / nbRaid;
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

	public RaidAttendance getAttendance(RaidInstance instance, RaidAttendancePeriod period) {
		return attendances.stream()
				.filter(a -> a.getInstance() == instance && a.getPeriod() == period).findFirst()
				.orElseGet(() -> new RaidAttendance());
	}

	public int getEv() {
		return ev;
	}

	public void setEv(int ev) {
		this.ev = ev;
	}

	public int getGp() {
		return gp;
	}

	public void setGp(int gp) {
		this.gp = gp;
	}

	public int getEvgpRatio() {
		return evgpRatio;
	}

	public void setEvgpRatio(int evgpRatio) {
		this.evgpRatio = evgpRatio;
	}

	public int getEr() {
		return er;
	}

	public void setEr(int er) {
		this.er = er;
	}

	public int getErgpRatio() {
		return ergpRatio;
	}

	public void setErgpRatio(int ergpRatio) {
		this.ergpRatio = ergpRatio;
	}

	public Date getLastLootDate() {
		return lastLootDate;
	}

	public void setLastLootDate(Date lastLootDate) {
		this.lastLootDate = lastLootDate;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + evgpRatio;
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		PlayerStat other = (PlayerStat) obj;
		if (evgpRatio != other.evgpRatio)
			return false;
		return true;
	}

	public int getErInitial() {
		return erInitial;
	}

	public void setErInitial(int erInitial) {
		this.erInitial = erInitial;
	}

	public int getEvInitial() {
		return evInitial;
	}

	public void setEvInitial(int evInitial) {
		this.evInitial = evInitial;
	}

}
