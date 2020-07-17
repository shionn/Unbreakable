package shionn.ubk.db.dbo;

import java.util.List;

public class RaidEntry {
	private Player player;
	private boolean member;
	private List<Loot> loots;
	private boolean bench;
	private boolean visible;

	public Player getPlayer() {
		return player;
	}

	public void setPlayer(Player player) {
		this.player = player;
	}

	public boolean isMember() {
		return member;
	}

	public void setMember(boolean member) {
		this.member = member;
	}

	public List<Loot> getLoots() {
		return loots;
	}

	public void setLoots(List<Loot> loots) {
		this.loots = loots;
	}

	public boolean isBench() {
		return bench;
	}

	public void setBench(boolean bench) {
		this.bench = bench;
	}

	public boolean isVisible() {
		return visible;
	}

	public void setVisible(boolean visible) {
		this.visible = visible;
	}
}
