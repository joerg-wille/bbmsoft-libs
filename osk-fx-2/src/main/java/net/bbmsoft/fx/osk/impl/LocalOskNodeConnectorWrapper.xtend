package net.bbmsoft.fx.osk.impl

import java.rmi.server.UnicastRemoteObject
import net.bbmsoft.fx.osk.OskFxNodeConnector
import net.bbmsoft.fx.osk.RemoteOskFxNodeConnector
import java.rmi.RemoteException

class LocalOskNodeConnectorWrapper extends UnicastRemoteObject implements RemoteOskFxNodeConnector {

	final OskFxNodeConnector localConnector

	new(OskFxNodeConnector localConnector) throws RemoteException {
		super()
		this.localConnector = localConnector
	}

	override enter() {
		this.localConnector.enter
	}

	override selectRange(int start, int end) {
		this.localConnector.selectRange(start, end)
	}

	override setCaretPosition(int value) {
		this.localConnector.caretPosition = value
	}

	override setText(String value) {
		this.localConnector.text = value
	}

}
