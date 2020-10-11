package shionn.ubk.db.dbo;

public class PlayerWish {

	private Player player;
	private Item item;
	private boolean selected;
	private LootAttribution attribution;

	public Player getPlayer() {
		return player;
	}

	public void setPlayer(Player player) {
		this.player = player;
	}

	public Item getItem() {
		return item;
	}

	public void setItem(Item item) {
		this.item = item;
	}

	public boolean isSelected() {
		return selected;
	}

	public void setSelected(boolean selected) {
		this.selected = selected;
	}

	public LootAttribution getAttribution() {
		return attribution;
	}

	public void setAttribution(LootAttribution attribution) {
		this.attribution = attribution;
	}

}
