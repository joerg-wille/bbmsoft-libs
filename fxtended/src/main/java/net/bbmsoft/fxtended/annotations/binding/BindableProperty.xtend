package net.bbmsoft.fxtended.annotations.binding

import java.lang.annotation.ElementType
import java.lang.annotation.Target
import org.eclipse.xtend.lib.macro.Active
import net.bbmsoft.fxtended.annotations.binding.processor.BindablePropertyProcessor

/**
 * Instructs the Xtend compiler to create a bindable property from this field.
 *
 * @author Michael Bachmann
 */
@Target(ElementType.FIELD)
@Active(BindablePropertyProcessor)
annotation BindableProperty {
	Class<?> value = Object
	boolean synchronize = false
}