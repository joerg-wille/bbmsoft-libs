package net.bbmsoft.jna.annotations

import java.lang.annotation.ElementType
import java.lang.annotation.Target
import net.bbmsoft.jna.annotations.impl.JnaProcessor
import org.eclipse.xtend.lib.macro.Active

@Target(ElementType.TYPE)
@Active(JnaProcessor)
annotation JNA {
	String value
}