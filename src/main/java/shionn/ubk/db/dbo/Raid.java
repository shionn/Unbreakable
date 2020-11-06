package shionn.ubk.db.dbo;

import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.format.annotation.DateTimeFormat;

import shionn.ubk.wish.DecoratedPriorities;

public class Raid {
	private int id;
	private String name;
	@DateTimeFormat(pattern = "yyyy-MM-dd")
	private Date date;
	private boolean running;
	private boolean rerollAsMain;
	private List<RaidEntry> players;
	private RaidInstance instance;
	private int ev;
	private int initialEv;
	private List<DecoratedPriorities> selectedWishList;
	private List<String> bosses;

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


	public boolean isRunning() {
		return running;
	}

	public void setRunning(boolean running) {
		this.running = running;
	}

	public List<RaidEntry> getPlayers() {
		return players;
	}

	public List<RaidEntry> getPlayers(PlayerRank... ranks) {
		return players.stream().filter(p -> Arrays.asList(ranks).contains(p.getPlayer().getRank()))
				.collect(Collectors.toList());
	}

	public void setPlayers(List<RaidEntry> players) {
		this.players = players;
	}

	public Date getDate() {
		return date;
	}

	public void setDate(Date date) {
		this.date = date;
	}

	public RaidInstance getInstance() {
		return instance;
	}

	public void setInstance(RaidInstance instance) {
		this.instance = instance;
	}

	public int getEv() {
		return ev;
	}

	public void setEv(int ev) {
		this.ev = ev;
	}

	public int getInitialEv() {
		return initialEv;
	}

	public void setInitialEv(int initialEv) {
		this.initialEv = initialEv;
	}

	public void setSelectedWishList(List<DecoratedPriorities> selectedWishList) {
		this.selectedWishList = selectedWishList;
	}

	public List<DecoratedPriorities> getSelectedWishList() {
		return selectedWishList;
	}

	public void setBosses(List<String> bosses) {
		this.bosses = bosses;
	}

	public List<String> getBosses() {
		return bosses;
	}

	public void setRerollAsMain(boolean rerollAsMain) {
		this.rerollAsMain = rerollAsMain;
	}

	public boolean isRerollAsMain() {
		return rerollAsMain;
	}
}
