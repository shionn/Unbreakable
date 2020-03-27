package shionn.ubk.db.dbo;

import java.util.List;

public class Player {

	private int id;
	private String name;
	private PlayerClass clazz;
	private PlayerRank rank;
	private List<PlayerWish> wishes;

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public PlayerClass getClazz() {
		return clazz;
	}

	public void setClazz(PlayerClass clazz) {
		this.clazz = clazz;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public PlayerRank getRank() {
		return rank;
	}

	public void setRank(PlayerRank rank) {
		this.rank = rank;
	}

	public List<PlayerWish> getWishes() {
		return wishes;
	}

	public void setWishes(List<PlayerWish> wishes) {
		this.wishes = wishes;
	}
}
