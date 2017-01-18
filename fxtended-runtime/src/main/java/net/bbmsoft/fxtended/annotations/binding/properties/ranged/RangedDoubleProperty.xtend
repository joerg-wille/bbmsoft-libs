package net.bbmsoft.fxtended.annotations.binding.properties.ranged

import javafx.beans.property.DoublePropertyBase
import org.eclipse.xtend.lib.annotations.Accessors

class RangedDoubleProperty extends DoublePropertyBase implements RangedProperty<Double> {

	final Object bean

	final String name

	@Accessors
	Double min = Double.NEGATIVE_INFINITY

	@Accessors
	Double max = Double.POSITIVE_INFINITY

	@Accessors
	Double NaNValue = Double.NaN

	new(Object bean, String name) {

		this.bean = bean
		this.name = name
	}

	new(Object bean, String name, double value) {

		super(value)

		this.bean = bean
		this.name = name
	}

	override getBean() {
		bean
	}

	override getName() {
		name
	}

	override set(double newValue) {
		super.set(newValue.clamp)
	}

	override setValue(Number v) {
		super.setValue(v.clamp)
	}

	override get() {
		super.get.clamp
	}

	override getValue() {
		super.getValue.clamp
	}

	def double clamp(Number value) {

		val nan = getNaNValue().doubleValue();

		if (Double.isNaN(value.doubleValue())) {
			return nan;
		}

		val min = getMin().doubleValue();
		val max = getMax().doubleValue();
		val theValue = value.doubleValue();

		if (theValue < min) {
			return min;
		} else if (theValue > max) {
			return max;
		} else {
			return theValue;
		}
	}
}