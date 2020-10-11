package shionn.ubk.db.dbo;

import java.util.Date;

public class Loot {

	private Player player;
	private Item item;
	private int gp;
	private int initialGp;
	private LootAttribution attribution;
	private Date lootDate;

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

	public int getGp() {
		return gp;
	}

	public void setGp(int gp) {
		this.gp = gp;
	}

	public int getInitialGp() {
		return initialGp;
	}

	public void setInitialGp(int initialGp) {
		this.initialGp = initialGp;
	}

	public LootAttribution getAttribution() {
		return attribution;
	}

	public void setAttribution(LootAttribution attribution) {
		this.attribution = attribution;
	}

	public Date getLootDate() {
		return lootDate;
	}

	public void setLootDate(Date lootDate) {
		this.lootDate = lootDate;
	}

}
