package shionn.ubk.db.dbo;

import java.util.Date;
import java.util.List;

import org.springframework.format.annotation.DateTimeFormat;

public class Raid {
	private int id;
	private String name;
	@DateTimeFormat(pattern = "dd/MM/yyyy")
	private Date date;
	private boolean running;
	private int point;
	private List<RaidEntry> players;

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

	public void setPlayers(List<RaidEntry> players) {
		this.players = players;
	}

	public Date getDate() {
		return date;
	}

	public void setDate(Date date) {
		this.date = date;
	}

	public int getPoint() {
		return point;
	}

	public void setPoint(int point) {
		this.point = point;
	}

}
