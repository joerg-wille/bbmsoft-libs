package net.bbmsoft.keyboard.remote

import java.rmi.RemoteException
import java.rmi.server.UnicastRemoteObject
import java.util.HashMap
import java.util.Map
import net.bbmsoft.keyboard.KeyCode
import net.bbmsoft.keyboard.KeyMap
import net.bbmsoft.keyboard.ScanCodeSet
import net.bbmsoft.keyboard.VirtualKeyboardController
import org.eclipse.xtend.lib.annotations.Accessors

class RemoteKeyboardControllerWrapper implements VirtualKeyboardController {

	@Accessors final RemoteVirtualKeyboardController remoteController
	final Map<Listener, LocalListenerWrapper> listenerMap

	volatile boolean offline

	new(RemoteVirtualKeyboardController remoteController) {
		this.remoteController = remoteController
		this.listenerMap = new HashMap
	}

	override addListener(Listener listener) {

		if (offline) {
			return false
		}

		try {
			val remoteListener = synchronized (this.listenerMap) {
					listener.remoteListener
				}
			this.remoteController.addListener(remoteListener)
			true
		} catch (RemoteException e) {
			this.offline = true
			false
		}
	}

	def void armListener(Listener listener) {

		if (offline) {
			return
		}

		try {
			val remoteListener = synchronized (this.listenerMap) {
					listener.remoteListener
				}
			this.remoteController.armListener(remoteListener)
		} catch (RemoteException e) {
			this.offline = true
		}
	}

	override getScanCodeSet() {

		if (offline) {
			return null
		}

		try {
			return this.remoteController.scanCodeSet
		} catch (RemoteException e) {
			this.offline = true
			return null
		}
	}

	override getTypeMaticDelay() {

		if (offline) {
			return -1l
		}

		try {
			return this.remoteController.typeMaticDelay
		} catch (RemoteException e) {
			this.offline = true
			return -1l
		}
	}

	override getTypeMaticRate() {

		if (offline) {
			return -1.0
		}

		try {
			return this.remoteController.typeMaticRate
		} catch (RemoteException e) {
			this.offline = true
			return -1.0
		}
	}

	override isTypeMaticEnabled() {

		if (offline) {
			return false
		}

		try {
			return this.remoteController.typeMaticEnabled
		} catch (RemoteException e) {
			this.offline = true
			return false
		}
	}

	override removeListener(Listener listener) {

		if (offline) {
			return false
		}

		try {
			val remoteListener = synchronized (this.listenerMap) {
					this.listenerMap.remove(listener)
				}
			if (remoteListener != null) {
				this.remoteController.removeListener(remoteListener)
				return true
			} else {
				return false
			}
		} catch (RemoteException e) {
			this.offline = true
			return false
		}
	}

	override setScanCodeSet(ScanCodeSet value) {

		if (offline) {
			return
		}

		try {
			this.remoteController.scanCodeSet = value
		} catch (RemoteException e) {
			this.offline = true
		}
	}

	override setTypeMaticDelay(long value) {

		if (offline) {
			return
		}

		try {
			this.remoteController.typeMaticDelay = value
		} catch (RemoteException e) {
			this.offline = true
		}
	}

	override setTypeMaticEnabled(boolean value) {

		if (offline) {
			return
		}

		try {
			this.remoteController.typeMaticEnabled = value
		} catch (RemoteException e) {
			this.offline = true
		}
	}

	override setTypeMaticRate(double value) {

		if (offline) {
			return
		}

		try {
			this.remoteController.typeMaticRate = value
		} catch (RemoteException e) {
			this.offline = true
		}
	}

	override showShiftDown(boolean value) {

		if (offline) {
			return
		}

		try {
			this.remoteController.showShiftDown(value)
		} catch (RemoteException e) {
			this.offline = true
		}
	}

	override showCtrlDown(boolean value) {

		if (offline) {
			return
		}

		try {
			this.remoteController.showCtrlDown(value)
		} catch (RemoteException e) {
			this.offline = true
		}
	}

	override showAltDown(boolean value) {

		if (offline) {
			return
		}

		try {
			this.remoteController.showAltDown(value)
		} catch (RemoteException e) {
			this.offline = true
		}
	}

	override showAltGraphDown(boolean value) {

		if (offline) {
			return
		}

		try {
			this.remoteController.showAltGraphDown(value)
		} catch (RemoteException e) {
			this.offline = true
		}
	}

	override showOsDown(boolean value) {

		if (offline) {
			return
		}

		try {
			this.remoteController.showOsDown(value)
		} catch (RemoteException e) {
			this.offline = true
		}
	}

	override showCapsLockOn(boolean value) {

		if (offline) {
			return
		}

		try {
			this.remoteController.showCapsLockOn(value)
		} catch (RemoteException e) {
			this.offline = true
		}
	}

	override showNumLockOn(boolean value) {

		if (offline) {
			return
		}

		try {
			this.remoteController.showNumLockOn(value)
		} catch (RemoteException e) {
			this.offline = true
		}
	}

	override showScrollLockOn(boolean value) {

		if (offline) {
			return
		}

		try {
			this.remoteController.showScrollLockOn(value)
		} catch (RemoteException e) {
			this.offline = true
		}
	}

	override setKeyMap(KeyMap value) {

		if (offline) {
			return
		}

		try {
			this.remoteController.setKeyMap(value)
		} catch (RemoteException e) {
			this.offline = true
		}
	}

	private def getRemoteListener(Listener listener) {
		this.listenerMap.get(listener) ?: (new LocalListenerWrapper(listener) => [this.listenerMap.put(listener, it)])
	}

	static class LocalListenerWrapper extends UnicastRemoteObject implements RemoteVirtualKeyboardController.Listener {

		final Listener localListener

		new(Listener localListener) throws RemoteException {
			super()
			this.localListener = localListener
		}

		override fireBreak(KeyCode keyCode, int[] breakCode) {
			this.localListener.fireBreak(keyCode, breakCode)
		}

		override fireMake(KeyCode keyCode, int[] makeCode, boolean typematic) {
			this.localListener.fireMake(keyCode, makeCode, typematic)
		}

	}

}
