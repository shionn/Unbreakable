package shionn.ubk.db.dbo;

public class Item {

	private int id;
	private String name;
	private RaidInstance raid;
	private String boss;

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

}
