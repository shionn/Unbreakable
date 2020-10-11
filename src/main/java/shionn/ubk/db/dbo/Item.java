package shionn.ubk.db.dbo;

import java.util.List;

public class Item {

	private int id;
	private String name;
	private RaidInstance raid;
	private String boss;
	private boolean big;
	private ItemSlot slot;
	private int ilvl;
	private List<PlayerClass> classes;
	private LootAttribution attribution;
	private int gp;

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public RaidInstance getRaid() {
		return raid;
	}

	public void setRaid(RaidInstance raid) {
		this.raid = raid;
	}

	public String getBoss() {
		return boss;
	}

	public void setBoss(String boss) {
		this.boss = boss;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + id;
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
		Item other = (Item) obj;
		if (id != other.id)
			return false;
		return true;
	}

	public boolean isBig() {
		return big;
	}

	public void setBig(boolean big) {
		this.big = big;
	}

	public ItemSlot getSlot() {
		return slot;
	}

	public void setSlot(ItemSlot slot) {
		this.slot = slot;
	}

	public int getIlvl() {
		return ilvl;
	}

	public void setIlvl(int ilvl) {
		this.ilvl = ilvl;
	}

	public List<PlayerClass> getClasses() {
		return classes;
	}

	public void setClasses(List<PlayerClass> classes) {
		this.classes = classes;
	}

	public void setGp(int gp) {
		this.gp = gp;
	}

	public int getGp() {
		return gp;
	}

	public boolean isAvailableFor(PlayerClass clazz) {
		return classes.contains(clazz);
	}

	public LootAttribution getAttribution() {
		return attribution;
	}

	public void setAttribution(LootAttribution attribution) {
		this.attribution = attribution;
	}
}
