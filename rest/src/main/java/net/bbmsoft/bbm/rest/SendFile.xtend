package net.bbmsoft.bbm.rest

import net.bbmsoft.bbm.rest.processor.SendFileProcessor
import org.eclipse.xtend.lib.macro.Active

@Active(SendFileProcessor)
annotation SendFile {
	String value
}