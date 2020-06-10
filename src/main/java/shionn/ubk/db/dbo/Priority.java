package shionn.ubk.db.dbo;

import java.util.List;

public class Priority {
	private Item item;
	private Player player;
	private int order;
	private int point;
	private int ratio;
	private int nbRaid;
	private int nbRaidWithoutLoot;
	private int nbRaidWait;
	private int nbLoot;
	private int ev;
	private int gp;
	private int evgpRatio;
	private boolean looted;
	private List<RaidAttendance> attendances;

	public Item getItem() {
		return item;
	}

	public void setItem(Item item) {
		this.item = item;
	}

	public Player getPlayer() {
		return player;
	}

	public void setPlayer(Player player) {
		this.player = player;
	}

	public void setOrder(int order) {
		this.order = order;
	}

	public int getOrder() {
		return order;
	}

	public void setPoint(int point) {
		this.point = point;
	}

	public int getPoint() {
		return point;
	}

	public void setRatio(int ratio) {
		this.ratio = ratio;
	}

	public int getRatio() {
		return ratio;
	}

	public boolean isLooted() {
		return looted;
	}

	public void setLooted(boolean looted) {
		this.looted = looted;
	}

	public int getNbRaid() {
		return nbRaid;
	}

	public void setNbRaid(int nbRaid) {
		this.nbRaid = nbRaid;
	}

	public int getNbLoot() {
		return nbLoot;
	}

	public void setNbLoot(int nbLoot) {
		this.nbLoot = nbLoot;
	}

	public int getNbRaidWithoutLoot() {
		return nbRaidWithoutLoot;
	}

	public void setNbRaidWithoutLoot(int nbRaidWithoutLoot) {
		this.nbRaidWithoutLoot = nbRaidWithoutLoot;
	}

	public int getNbRaidWait() {
		return nbRaidWait;
	}

	public void setNbRaidWait(int nbRaidWait) {
		this.nbRaidWait = nbRaidWait;
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

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + evgpRatio;
		result = prime * result + ((item == null) ? 0 : item.hashCode());
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
		Priority other = (Priority) obj;
		if (evgpRatio != other.evgpRatio)
			return false;
		if (item == null) {
			if (other.item != null)
				return false;
		} else if (!item.equals(other.item))
			return false;
		return true;
	}



}
