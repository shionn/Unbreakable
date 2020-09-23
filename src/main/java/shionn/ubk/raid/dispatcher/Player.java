package shionn.ubk.raid.dispatcher;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class Player {

	private String name;
	private ClassRole role;

	private Map<String, RaidPresence> raidPresence = new HashMap<>();

	public String getName() {
		return name.replace('<', '[').replace('>', ']');
	}

	public void setName(String name) {
		this.name = name;
	}

	public void setRole(ClassRole role) {
		this.role = role;
	}

	public ClassRole getRole() {
		return role;
	}

	public List<String> getRaidByPriority() {
		return raidPresence.entrySet().stream().filter(e -> e.getValue() != RaidPresence.Absence)
				.sorted((a, b) -> Integer.compare(a.getValue().priority(), b.getValue().priority()))
				.map(e -> e.getKey()).collect(Collectors.toList());
	}

	public boolean isMoveable() {
		return getRaidByPriority().size() > 1;
	}

	public boolean isLate(String raidName) {
		RaidPresence presence = raidPresence.get(raidName);
		return presence == RaidPresence.Late;
	}

	public boolean isTentative(String raidName) {
		RaidPresence presence = raidPresence.get(raidName);
		return presence == RaidPresence.Tentative;
	}

	public void setRaidPresence(String raidName, RaidPresence presence) {
		this.raidPresence.put(raidName, presence);
	}
}
