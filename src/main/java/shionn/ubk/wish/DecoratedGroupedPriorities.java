package shionn.ubk.wish;

import java.util.ArrayList;
import java.util.List;

public class DecoratedGroupedPriorities extends ArrayList<DecoratedPriorities> {

	public DecoratedGroupedPriorities(List<DecoratedPriorities> priorities) {
		super(priorities);
	}

	public String getLuaData() {
		StringBuilder builder = new StringBuilder().append("local data = {\n");
		stream().forEach(group -> {
			builder.append("  [\"").append(formatItemName(group)).append("\"] = {\n");
			group.stream().forEach(p -> {
				builder.append("    { player = \"").append(p.getPlayer().getName())
						.append("\", ev = ").append(p.getStat().getEv()).append(", gp = ")
						.append(p.getStat().getGp()).append(" },\n");
			});
			builder.append("  },\n");
		});
		builder.append("};");
		return builder.toString();
	}

	private String formatItemName(DecoratedPriorities group) {
		String name = group.get(0).getItem().getName();
		name.replaceAll(" \\(.*\\)$", "");
		return name;
	}

	@Override
	public String toString() {
		return getLuaData();
	}

}
