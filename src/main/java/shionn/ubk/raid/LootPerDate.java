package shionn.ubk.raid;

import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

import shionn.ubk.db.dbo.Loot;
import shionn.ubk.db.dbo.LootAttribution;

public class LootPerDate {

	private List<Loot> loots;

	public LootPerDate(List<Loot> loots) {
		this.loots = loots;
	}

	public List<Date> getDates() {
		return loots.stream().map(l -> l.getLootDate()).distinct().collect(Collectors.toList());
	}

	public List<Loot> getLoots(Date date, LootAttribution attribution) {
		return loots.stream()
				.filter(l -> l.getLootDate().equals(date) && l.getAttribution() == attribution)
				.collect(Collectors.toList());
	}

}
