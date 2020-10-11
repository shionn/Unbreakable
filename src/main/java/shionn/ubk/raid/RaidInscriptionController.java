package shionn.ubk.raid;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class RaidInscriptionController {

	@RequestMapping("/raid-inscription/{token}")
	public ModelAndView openInscription(@PathVariable("token") String token) {

		return new ModelAndView("raid-inscription");
	}

}
