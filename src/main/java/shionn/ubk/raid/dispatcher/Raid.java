package shionn.ubk.raid.dispatcher;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

public class Raid {
	private String name;

	private List<Player> players = new ArrayList<>();

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public List<Player> getPlayers() {
		return players;
	}

	public void setPlayers(List<Player> players) {
		this.players = players;
	}

	public List<Player> getTanks() {
		return getPlayers(ClassRole.Tank, ClassRole.Bear, ClassRole.ProtPaladin);
	 }

	public List<Player> getPlayers(ClassRole... roles) {
		return players.stream().filter(p -> Arrays.asList(roles).contains(p.getRole()))
				.sorted((a, b) -> Integer.compare(a.getRole().ordinal(), b.getRole().ordinal()))
				.collect(Collectors.toList());
	}
}
