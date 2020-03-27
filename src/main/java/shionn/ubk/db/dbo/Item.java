package shionn.ubk.db.dbo;

public class Item {

	private int id;
	private String name;
	private Raid raid;
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

	public Raid getRaid() {
		return raid;
	}

	public void setRaid(Raid raid) {
		this.raid = raid;
	}

	public String getBoss() {
		return boss;
	}

	public void setBoss(String boss) {
		this.boss = boss;
	}

}
