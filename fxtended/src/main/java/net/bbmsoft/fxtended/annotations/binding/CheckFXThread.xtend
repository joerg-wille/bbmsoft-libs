package net.bbmsoft.fxtended.annotations.binding

import java.lang.annotation.ElementType
import java.lang.annotation.Target
import net.bbmsoft.fxtended.annotations.binding.processor.CheckFXThreadProcessor
import org.eclipse.xtend.lib.macro.Active

/**
 * Instructs the Xtend compiler to create a check whether the annotated method is called
 * from the JavaFX Application Thread.
 *
 * @author Michael Bachmann
 */
@Target(ElementType.METHOD, ElementType.FIELD)
@Active(CheckFXThreadProcessor)
annotation CheckFXThread {
	Class<?> exception = IllegalStateException
	String message = 'Not on JavaFX Application Thread!'
}