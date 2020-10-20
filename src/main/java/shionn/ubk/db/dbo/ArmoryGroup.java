package shionn.ubk.db.dbo;

import java.util.List;
import java.util.stream.Collectors;

public class ArmoryGroup {
	private RaidInstance raid;
	private List<Armory> players;
	private List<Armory> items;
	private List<Armory> armories;

	public RaidInstance getRaid() {
		return raid;
	}

	public void setRaid(RaidInstance raid) {
		this.raid = raid;
	}

	public List<Armory> getPlayers() {
		return players;
	}

	public List<Armory> getPlayers(PlayerClass clazz) {
		return players.stream().filter(p -> p.getClazz() == clazz).collect(Collectors.toList());
	}

	public void setPlayers(List<Armory> players) {
		this.players = players;
	}

	public List<Armory> getItems() {
		return items;
	}

	public List<Armory> getItems(PlayerClass clazz) {
		return items.stream().filter(i -> i.getClazz() == clazz).collect(Collectors.toList());
	}

	public void setItems(List<Armory> items) {
		this.items = items;
	}

	public List<Armory> getArmories() {
		return armories;
	}

	public void setArmories(List<Armory> armories) {
		this.armories = armories;
	}

	public String getStatus(int item, int player) {
		return armories.stream().filter(a -> a.getItem() == item && a.getPlayer() == player).findFirst()
				.orElse(new Armory()).getStatus();
	}

	public String getBgColor(int item, int player) {
		return armories.stream().filter(a -> a.getItem() == item && a.getPlayer() == player).findFirst()
				.orElse(new Armory()).getBgColor();
	}

}
