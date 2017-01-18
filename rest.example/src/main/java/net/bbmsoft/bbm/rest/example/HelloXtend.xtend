package net.bbmsoft.bbm.rest.example

import net.bbmsoft.bbm.rest.Get
import net.bbmsoft.bbm.rest.HttpHandler
import net.bbmsoft.bbm.rest.ServerStub
import net.bbmsoft.bbm.rest.SendFile

/**
 *
 * @author Sven Efftinge, Michael Bachmann
 *
 */
@HttpHandler class HelloXtend {

	@Get('/sayHello/:name') def sayHello() '''
		<html>
		  <title>Hello «name»!</title>
		  <body>
		    <h1>Hello «name»!</h1>
		  </body>
		</html>
	'''

	@Get('/sayHello/:firstName/:LastName') def sayHello() '''
		<html>
		  <title>Hello «firstName» «LastName»!</title>
		  <body>
		    <h1>Hello «firstName» «LastName»!</h1>
		  </body>
		</html>
	'''

	@SendFile('println.html')
	@Get('/println/:arg') def println() {
		println(arg)
	}

	@SendFile('println.html')
	@Get('/println') def println() {
		this.println(request.getParameter('arg'), target, baseRequest, request, response)
	}

	def static void main(String[] args) throws Exception {
		ServerStub.launch(new HelloXtend, 4711)
	}

}
