package shionn.ubk.db.dbo;

public class RaidEntry {
	private Player player;
	private boolean member;

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

}
