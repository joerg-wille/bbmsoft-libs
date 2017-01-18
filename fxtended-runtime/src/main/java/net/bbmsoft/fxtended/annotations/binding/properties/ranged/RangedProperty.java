package net.bbmsoft.fxtended.annotations.binding.properties.ranged;

import javafx.beans.property.Property;

public interface RangedProperty<N extends Number> extends Property<Number> {

	// public default double clamp(Number value) {
	//
	// double nan = getNaNValue().doubleValue();
	//
	// if (Double.isNaN(value.doubleValue())) {
	// return nan;
	// }
	//
	// double min = getMin().doubleValue();
	// double max = getMax().doubleValue();
	// double theValue = value.doubleValue();
	//
	// if (theValue < min)
	// return min;
	// else if (theValue > max)
	// return max;
	// else
	// return theValue;
	// }

	public abstract N getNaNValue();

	public abstract N getMax();

	public abstract N getMin();
}
