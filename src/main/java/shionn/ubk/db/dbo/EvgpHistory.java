package shionn.ubk.db.dbo;

public class EvgpHistory {

	private Player player;
	private boolean reroll;
	private String rerollName;
	private Raid raid;
	private PlayerStat stat;

	public Player getPlayer() {
		return player;
	}

	public void setPlayer(Player player) {
		this.player = player;
	}

	public boolean isReroll() {
		return reroll;
	}

	public void setReroll(boolean reroll) {
		this.reroll = reroll;
	}

	public String getRerollName() {
		return rerollName;
	}

	public void setRerollName(String rerollName) {
		this.rerollName = rerollName;
	}

	public Raid getRaid() {
		return raid;
	}

	public void setRaid(Raid raid) {
		this.raid = raid;
	}

	public PlayerStat getStat() {
		return stat;
	}

	public void setStat(PlayerStat stat) {
		this.stat = stat;
	}

}
