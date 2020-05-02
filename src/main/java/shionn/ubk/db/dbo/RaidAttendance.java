package shionn.ubk.db.dbo;

public class RaidAttendance {

	private int attendance;
	private RaidInstance instance;
	private RaidAttendancePeriod period;

	public int getAttendance() {
		return attendance;
	}

	public void setAttendance(int attendance) {
		this.attendance = attendance;
	}

	public RaidInstance getInstance() {
		return instance;
	}

	public void setInstance(RaidInstance instance) {
		this.instance = instance;
	}

	public RaidAttendancePeriod getPeriod() {
		return period;
	}

	public void setPeriod(RaidAttendancePeriod period) {
		this.period = period;
	}

}
