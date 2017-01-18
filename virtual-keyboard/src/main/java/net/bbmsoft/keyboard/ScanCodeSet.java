package net.bbmsoft.keyboard;

public enum ScanCodeSet {

	SET_1("Set 1"), SET_2("Set 1"), SET_3("Set 3"), SET_USB("Set USB");

	private final String name;

	private ScanCodeSet(String name) {
		this.name = name;
	}

	@Override
	public String toString() {
		return name;
	}
}
