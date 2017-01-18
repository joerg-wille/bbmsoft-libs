package net.bbmsoft.fxtended.annotations.binding.processor;

public enum PropertyType {
	DOUBLE, FLOAT, INTEGER, LONG, BOOLEAN, STRING, COLOR, PAINT, FONT, ENUM, OBJECT;

	public boolean isNumber() {
		return this.equals(DOUBLE) || this.equals(FLOAT)
				|| this.equals(INTEGER) || this.equals(LONG);
	}
}
