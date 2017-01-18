package net.bbmsoft.fx.osk.impl

import java.rmi.RemoteException
import net.bbmsoft.fx.osk.NodeAttachableVirtualKeyboard
import net.bbmsoft.fx.osk.OskController
import net.bbmsoft.fx.osk.RemoteNodeAttachableKeyboard
import net.bbmsoft.fx.osk.RemoteOskController
import net.bbmsoft.fx.osk.RemoteOskFxNodeConnector
import net.bbmsoft.keyboard.impl.VirtualKeyboardControllerBase
import net.bbmsoft.keyboard.remote.LocalKeyboardControllerWrapper

class LocalOskControllerWrapper extends LocalKeyboardControllerWrapper implements RemoteOskController {

	final RemoteNodeAttachableKeyboard nodeAttachableWrapper
	final VirtualKeyboardControllerBase localController

	new(VirtualKeyboardControllerBase localController, NodeAttachableVirtualKeyboard navk) throws RemoteException {
		super(localController)
		this.nodeAttachableWrapper = new LocalNodeAttachableKeyboardWrapper(navk)
		this.localController = localController
	}

	override getNodeAttachable() {
		this.nodeAttachableWrapper
	}

	override addNodeConnector(RemoteOskFxNodeConnector connector) {
		if (this.localController instanceof OskController) {
			this.localController.addNodeConnector(new RemoteOskNodeConnectorWrapper(connector))
		}
	}

}
