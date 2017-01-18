package net.bbmsoft.bbm.rest

import java.io.IOException
import javax.servlet.ServletException
import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse
import org.eclipse.jetty.server.Request
import org.eclipse.jetty.server.handler.HandlerList

class GlobalPluginHandler extends HandlerList {
	
	private static class PluginHandlerHolder {
		static final GlobalPluginHandler instance = new GlobalPluginHandler
	}
	
	def static getInstance() {
		PluginHandlerHolder.instance
	}
	
	override handle(String target, Request baseRequest, HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		super.handle(target, baseRequest, request, response)
		response.status = HttpServletResponse.SC_OK
		baseRequest.handled = true
	}
	
}