package shionn.ubk.db.dbo;

public class Item {

	private int id;
	private String name;
	private RaidInstance raid;
	private String boss;
	private int ratio;
	private LootAttribution attribution;

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

	public LootAttribution getAttribution() {
		return attribution;
	}

	public void setAttribution(LootAttribution attribution) {
		this.attribution = attribution;
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

	public int getRatio() {
		return ratio;
	}

	public void setRatio(int ratio) {
		this.ratio = ratio;
	}

}
