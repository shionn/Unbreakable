package shionn.ubk.db.dbo;

public class Armory {

	private int item;
	private String itemName;
	private int player;
	private String playerName;
	private PlayerClass clazz;
	private LootAttribution attribution;
	private boolean wl;
	private boolean optained;
	private boolean editable;


	public int getItem() {
		return item;
	}

	public void setItem(int item) {
		this.item = item;
	}

	public String getItemName() {
		return itemName;
	}

	public void setItemName(String itemName) {
		this.itemName = itemName;
	}

	public int getPlayer() {
		return player;
	}

	public void setPlayer(int player) {
		this.player = player;
	}

	public String getPlayerName() {
		return playerName;
	}

	public void setPlayerName(String playerName) {
		this.playerName = playerName;
	}

	public PlayerClass getClazz() {
		return clazz;
	}

	public void setClazz(PlayerClass clazz) {
		this.clazz = clazz;
	}

	public void setAttribution(LootAttribution attribution) {
		this.attribution = attribution;
	}

	public LootAttribution getAttribution() {
		return attribution;
	}

	public void setWl(boolean wl) {
		this.wl = wl;
	}

	public boolean isWl() {
		return wl;
	}

	public void setOptained(boolean optained) {
		this.optained = optained;
	}

	public boolean isOptained() {
		return optained;
	}

	public boolean isEditable() {
		return editable;
	}

	public void setEditable(boolean editable) {
		this.editable = editable;
	}

	public String getStatus() {
		if (attribution == null) {
			return "af";
		}
		if (wl) {
			return LootAttribution.wishList.getShorten();
		}
		return attribution.getShorten();
	}

	public String getBgColor() {
		if (!optained) {
			return "yellow";
		}
		return "lightGreen";
	}

}
