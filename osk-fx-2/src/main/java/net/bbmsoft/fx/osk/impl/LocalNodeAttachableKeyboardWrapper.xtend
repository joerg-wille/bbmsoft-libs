package net.bbmsoft.fx.osk.impl

import java.rmi.server.UnicastRemoteObject
import net.bbmsoft.fx.osk.NodeAttachableVirtualKeyboard
import net.bbmsoft.fx.osk.RemoteNodeAttachableKeyboard
import java.rmi.RemoteException

class LocalNodeAttachableKeyboardWrapper extends UnicastRemoteObject implements RemoteNodeAttachableKeyboard {

	final NodeAttachableVirtualKeyboard localNodeAttachable

	new(NodeAttachableVirtualKeyboard localNodeAttachable) throws RemoteException {
		super()
		this.localNodeAttachable = localNodeAttachable
	}

	override requestInputIndicatorFocus() {
		this.localNodeAttachable.requestInputIndicatorFocus
	}

	override setIndicatorSelection(int start, int end) {
		this.localNodeAttachable.setIndicatorSelection(start, end)
	}

	override setIndicatorText(String text) {
		this.localNodeAttachable.indicatorText = text
	}

}