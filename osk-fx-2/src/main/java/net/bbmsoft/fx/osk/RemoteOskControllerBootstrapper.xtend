package net.bbmsoft.fx.osk

import java.net.URL
import java.rmi.registry.LocateRegistry
import net.bbmsoft.fx.osk.impl.LocalOskControllerWrapper

class RemoteOskControllerBootstrapper {

	def createController(URL boardLayout) {

		val osk = new OskFx => [load = boardLayout]
		val controller = new OskFxController(osk)
		val controllerWrapper = new LocalOskControllerWrapper(controller, osk)

		val registry = LocateRegistry.getRegistry
		registry.rebind('controller', controllerWrapper)

		osk.addListener(controller)

		osk -> controllerWrapper
	}
}
