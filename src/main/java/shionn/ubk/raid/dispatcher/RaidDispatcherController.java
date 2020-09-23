package shionn.ubk.raid.dispatcher;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.context.annotation.SessionScope;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

@Controller
@SessionScope
public class RaidDispatcherController implements Serializable {
	private static final long serialVersionUID = 3592977951569087553L;
	private static final Logger logger = LoggerFactory.getLogger(RaidDispatcherController.class);

	private List<Player> players = new ArrayList<>();
	private List<Raid> raids = new ArrayList<>();

	@RequestMapping(value = "/raid-dispatcher", method = RequestMethod.GET)
	public ModelAndView open() {
		return new ModelAndView("raid-dispatcher").addObject("raids", raids);
	}

	@RequestMapping(value = "/raid-dispatcher/move/{player-name}", method = RequestMethod.GET)
	public String move(@PathVariable("player-name") String name) {
		Player player = players.stream().filter(p -> name.equals(p.getName())).findFirst().get();
		Raid currentRaid = raids.stream().filter(r -> r.getPlayers().contains(player)).findFirst()
				.get();
		raids.stream().filter(r -> r != currentRaid).findFirst().get().getPlayers().add(player);
		currentRaid.getPlayers().remove(player);
		return "redirect:/raid-dispatcher";
	}

	@RequestMapping(value = "/raid-dispatcher", method = RequestMethod.POST)
	public String open(@RequestParam("file") MultipartFile file) throws IOException {
		if (raids.size() >= 2) {
			throw new IllegalArgumentException("Max 2 Raid");
		}
		try (InputStreamReader isr = new InputStreamReader(file.getInputStream());
				BufferedReader reader = new BufferedReader(isr)) {
			String line = reader.readLine();
			String raidName = file.getOriginalFilename() + " " + reader.readLine().split(",")[0];
			Raid raid = new Raid();
			raid.setName(raidName);
			raids.add(raid);
			while (line != null) {
				String[] cels = line.split(",");
				LineType mode = readLineType(cels[0]);
				if (mode != null) {
					for (int i = 1; i < cels.length; i++) {
						Matcher m = Pattern.compile("--\\*\\*(?<name>.*)\\*\\*--(?<role>.*)")
								.matcher(cels[i]);
						if (m.find()) {
							String name = m.group("name");
							Player player = players.stream().filter(p -> name.equals(p.getName()))
									.findFirst().orElseGet(() -> {
										Player p = new Player();
										p.setName(name);
										players.add(p);
										return p;
									});
							if (mode.haveClasse()) {
								player.setRole(ClassRole.valueOf(m.group("role")));
							}
							player.setRaidPresence(raidName, mode.presence());
						} else {
							logger.error("Illegal cel: " + cels[i]);
						}
					}
				}
				line = reader.readLine();
			}
		}
		rebuildRaid();
		return "redirect:/raid-dispatcher";
	}

	private void rebuildRaid() {
		raids.stream().forEach(r -> r.setPlayers(new ArrayList<>()));
		for (Player p : players) {
			if (!p.getRaidByPriority().isEmpty()) {
				raids.stream().filter(r -> p.getRaidByPriority().get(0).equals(r.getName()))
						.findFirst().ifPresent(r -> r.getPlayers().add(p));
			}
		}
	}

	private LineType readLineType(String cel) {
		try {
			return LineType.valueOf(cel);
		} catch (RuntimeException e) {
			return null;
		}
	}

}
