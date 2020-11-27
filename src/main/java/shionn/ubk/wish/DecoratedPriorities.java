package shionn.ubk.wish;

import java.util.ArrayList;
import java.util.List;

import shionn.ubk.db.dbo.Priority;

public class DecoratedPriorities extends ArrayList<Priority> {
	private static final long serialVersionUID = -7200155067634690665L;

	public DecoratedPriorities(List<Priority> priorities) {
		super(priorities);
	}

	public String getCopyData() {
		StringBuilder builder = new StringBuilder();
		builder.append("Joueur\t%\tev\tgp\n");
		stream().forEach(p -> builder.append(p.getPlayer().getName()).append('\t')
				.append(p.getStat().getEvgpRatio()).append("%\t").append(p.getStat().getEv())
				.append('/').append(p.getStat().getGp()).append('\n'));
		return builder.toString();
	}

	@Override
	public String toString() {
		return getCopyData();
	}

}
