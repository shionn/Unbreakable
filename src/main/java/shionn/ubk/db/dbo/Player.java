package shionn.ubk.db.dbo;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

public class Player {

	private int id;
	private String name;
	private String displayName;
	private PlayerClass clazz;
	private PlayerRank rank;
	private List<PlayerWish> wishes;
	private List<Loot> loots;
	private String token;
	private int main;

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

	public List<Loot> getLoots(LootAttribution attribution) {
		return loots.stream().filter(l -> l.getAttribution() == attribution)
				.collect(Collectors.toList());
	}

	public List<Loot> getLoots() {
		return loots;
	}

	public void setLoots(List<Loot> loots) {
		this.loots = loots;
	}

	public boolean isRank(PlayerRank... ranks) {
		return Arrays.asList(ranks).contains(rank);
	}

	public String getToken() {
		return token;
	}

	public void setToken(String token) {
		this.token = token;
	}

	public String getDisplayName() {
		return displayName == null ? name : displayName;
	}

	public void setDisplayName(String displayName) {
		this.displayName = displayName;
	}

	public int getMain() {
		return main;
	}

	public void setMain(int main) {
		this.main = main;
	}
}
