package net.bbmsoft.bbm.rest

import net.bbmsoft.bbm.rest.processor.HttpHandlerProcessor
import org.eclipse.xtend.lib.macro.Active

@Active(HttpHandlerProcessor)
annotation HttpHandler {
}

annotation Get {
	String value
}