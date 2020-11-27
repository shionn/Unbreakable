package shionn.ubk.wish;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import shionn.ubk.db.dbo.Priority;

public class DecoratedGroupedPriorities extends ArrayList<DecoratedPriorities> {
	private static final long serialVersionUID = 5133535923684114165L;

	public DecoratedGroupedPriorities(List<DecoratedPriorities> priorities) {
		super(priorities);
	}

	public String getLuaData() {
		StringBuilder builder = new StringBuilder().append("local data = {\n");
		SimpleDateFormat format = new SimpleDateFormat("dd/MM");
		stream().forEach(group -> {
			builder.append("  [\"").append(formatItemName(group)).append("\"] = {\n");
			group.stream().forEach(p -> //
			builder.append("    { player = \"").append(p.getPlayer().getName()) //
					.append("\", ev = ").append(p.getStat().getEv()) //
					.append(", er = ").append(p.getStat().getEr()) //
					.append(", gp = ").append(p.getStat().getGp()) //
					.append(", last_loot = \"").append(formatDate(format, p)) //
					.append("\" },\n"));
			builder.append("  },\n");
		});
		builder.append("};");
		return builder.toString();
	}

	private String formatDate(SimpleDateFormat format, Priority p) {
		return p.getStat().getLastLootDate() == null ? "-"
				: format.format(p.getStat().getLastLootDate());
	}

	private String formatItemName(DecoratedPriorities group) {
		String name = group.get(0).getItem().getName();
		name = name.replaceAll(" \\(.*\\)", "");
		return name.toLowerCase();
	}

	@Override
	public String toString() {
		return getLuaData();
	}

}
