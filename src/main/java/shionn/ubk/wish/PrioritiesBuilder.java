package shionn.ubk.wish;

import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.apache.commons.collections.ListUtils;

import shionn.ubk.db.dbo.Item;
import shionn.ubk.db.dbo.Priority;

public class PrioritiesBuilder {

	public Map<Item, List<Priority>> groupByItem(List<Priority> prioirities) {
		return prioirities.stream()
				.collect(Collectors.toMap(Priority::getItem, Arrays::asList, ListUtils::union));
	}

}
