package net.bbmsoft.fxtended.annotations.binding.properties.ranged

import javafx.beans.property.IntegerPropertyBase
import org.eclipse.xtend.lib.annotations.Accessors

class RangedIntegerProperty extends IntegerPropertyBase implements RangedProperty<Integer> {

	final Object bean
	
	final String name
	
	@Accessors
	Integer min = Integer.MIN_VALUE
	
	@Accessors
	Integer max = Integer.MAX_VALUE
	
	@Accessors
	Integer NaNValue = 0
	
	new(Object bean, String name) {

		this.bean = bean
		this.name = name
	}
	
	new(Object bean, String name, int value) {

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
	
	override set(int newValue) {
		super.set(newValue.clamp.intValue)
	}
	
	override setValue(Number v) {
		super.setValue(v.clamp)
	}
	
	override get() {
		super.get.clamp.intValue
	}

	override getValue() {
		super.getValue.clamp.intValue
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