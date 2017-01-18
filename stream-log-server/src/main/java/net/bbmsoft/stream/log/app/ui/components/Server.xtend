package net.bbmsoft.stream.log.app.ui.components

import org.eclipse.xtend.lib.annotations.Accessors

class Server {

	@Accessors final int port
	@Accessors final String name

	new(String name, int port) {
		this.port = port
		this.name = name
	}

	override toString() {
		'''«name» («port»)'''
	}

}