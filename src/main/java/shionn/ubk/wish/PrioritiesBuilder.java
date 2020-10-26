package shionn.ubk.wish;

import java.util.Iterator;
import java.util.List;
import java.util.stream.Collectors;

import shionn.ubk.db.dbo.Priority;
import shionn.ubk.db.dbo.User;

public class PrioritiesBuilder {

	public List<List<Priority>> groupByItem(List<Priority> prioirities, User user) {
		List<List<Priority>> collect = prioirities
				.stream().map(p -> p.getItem()).distinct().map(item -> prioirities.stream()
						.filter(p -> p.getItem().equals(item)).collect(Collectors.toList()))
				.collect(Collectors.toList());
		if (user.isMdc()) {
			for (List<Priority> priorities : collect) {
				Iterator<Priority> ite = priorities.iterator();
				Priority previous = ite.next();
				previous.setOrder(1);
				while (ite.hasNext()) {
					Priority current = ite.next();
					if (current.equals(previous)) {
						current.setOrder(previous.getOrder());
					} else {
						current.setOrder(previous.getOrder() + 1);
					}
					previous = current;
				}
			}
		}
		return collect;
	}

}
