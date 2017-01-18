package net.bbmsoft.bbm.rest

import org.eclipse.jetty.server.Server
import org.eclipse.jetty.server.handler.AbstractHandler
import java.util.HashMap
import java.util.Map

class ServerStub {
	
	static Map<Integer, Server> servers = new HashMap
	
	def static launch(AbstractHandler theHandler, int port) {
		
		if(servers.get(port) != null) {
			throw new IllegalStateException('Server already running at port ' + port)
		}
		
		servers.put(port, new Server(port) => [
			handler = theHandler
			start
			join
		])
	}
	
	def static stop(int port) {
		servers.remove(port) => [
			if(it == null) {
				throw new IllegalStateException('No server running at port ' + port)
			} else {
				stop
			}
		]
	}
}