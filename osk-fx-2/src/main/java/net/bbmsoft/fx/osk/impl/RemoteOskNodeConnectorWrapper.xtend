package net.bbmsoft.fx.osk.impl

import java.rmi.RemoteException
import net.bbmsoft.fx.osk.OskFxNodeConnector
import net.bbmsoft.fx.osk.RemoteOskFxNodeConnector
import javafx.stage.Window
import javafx.scene.Scene
import javafx.scene.Node

class RemoteOskNodeConnectorWrapper implements OskFxNodeConnector {

	final RemoteOskFxNodeConnector remoteConnector

	boolean offline

	new(RemoteOskFxNodeConnector remoteConnector) {
		this.remoteConnector = remoteConnector
	}

	override enter() {

		if (!offline) {

			try {
				this.remoteConnector.enter
			} catch (RemoteException e) {
				this.offline = true
			}
		}
	}

	override selectRange(int start, int end) {

		if (!offline) {

			try {
				this.remoteConnector.selectRange(start, end)
			} catch (RemoteException e) {
				this.offline = true
			}
		}
	}

	override setCaretPosition(int value) {

		if (!offline) {

			try {
				this.remoteConnector.caretPosition = value
			} catch (RemoteException e) {
				this.offline = true
			}
		}
	}

	override setText(String value) {

		if (!offline) {

			try {
				this.remoteConnector.text = value
			} catch (RemoteException e) {
				this.offline = true
			}
		}
	}

	override attach(Window window) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

	override attach(Scene scene) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

	override attach(Node target) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

	override detach() {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

}
