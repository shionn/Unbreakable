package shionn.ubk.admin;

import shionn.ubk.db.dbo.ItemSlot;

/**
 * https://wowwiki.fandom.com/wiki/EPGP
 */
public class EvgpComputer {

	public int computeGp(int ilvl, ItemSlot slot, int ratio) {
		return (int) (ilvl * ilvl * slot.getGpRatio() * ratio / 100);
	}

}
