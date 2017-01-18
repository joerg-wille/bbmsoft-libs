package net.bbmsoft.keyboard.remote

import java.rmi.RemoteException
import java.rmi.server.UnicastRemoteObject
import java.util.Map
import java.util.concurrent.CountDownLatch
import java.util.concurrent.atomic.AtomicReference
import java.util.function.Supplier
import net.bbmsoft.keyboard.KeyCode
import net.bbmsoft.keyboard.KeyMap
import net.bbmsoft.keyboard.ScanCodeSet
import net.bbmsoft.keyboard.VirtualKeyboardController
import net.bbmsoft.keyboard.impl.VirtualKeyboardControllerBase
import org.eclipse.xtend.lib.annotations.Accessors

class LocalKeyboardControllerWrapper extends UnicastRemoteObject implements RemoteVirtualKeyboardController {

	@Accessors final VirtualKeyboardControllerBase localController
	final Map<Listener, RemoteListenerWrapper> listenerMap

	new(VirtualKeyboardControllerBase localController) throws RemoteException {
		super()
		this.localController = localController
		this.listenerMap = newHashMap
	}

	override addListener(Listener listener) {

		val localListener = synchronized (this.listenerMap) {
				listener.localListener
			}

		runLater[
			this.localController.addListener(localListener)
		]
	}

	override armListener(Listener listener) throws RemoteException {
		synchronized (this.listenerMap) {
			this.listenerMap.forEach[$1.armed = listener == $0]
		}
	}

	override getScanCodeSet() {
		waitAndGet[this.localController.scanCodeSet]
	}

	override getTypeMaticDelay() {
		waitAndGet[this.localController.typeMaticDelay]
	}

	override getTypeMaticRate() {
		waitAndGet[this.localController.typeMaticRate]
	}

	override isTypeMaticEnabled() {
		waitAndGet[this.localController.typeMaticEnabled]
	}

	override removeListener(Listener listener) {

		val localListener = synchronized (this.listenerMap) {
				this.listenerMap.remove(listener)
			}

		if (localListener != null) {
			runLater[
				this.localController.removeListener(localListener)
			]
		}
	}

	override setKeyMap(KeyMap value) {
		runLater[this.localController.keyMap = value]
	}

	override setScanCodeSet(ScanCodeSet value) {
		runLater[this.localController.scanCodeSet = value]
	}

	override setTypeMaticDelay(long value) {
		runLater[this.localController.typeMaticDelay = value]
	}

	override setTypeMaticEnabled(boolean value) {
		runLater[this.localController.typeMaticEnabled = value]
	}

	override setTypeMaticRate(double value) {
		runLater[this.localController.typeMaticRate = value]
	}

	override showAltDown(boolean value) {
		runLater[this.localController.showAltDown(value)]
	}

	override showAltGraphDown(boolean value) {
		runLater[this.localController.showAltGraphDown(value)]
	}

	override showCapsLockOn(boolean value) {
		runLater[this.localController.showCapsLockOn(value)]
	}

	override showCtrlDown(boolean value) {
		runLater[this.localController.showCtrlDown(value)]
	}

	override showNumLockOn(boolean value) {
		runLater[this.localController.showNumLockOn(value)]
	}

	override showOsDown(boolean value) {
		runLater[this.localController.showOsDown(value)]
	}

	override showScrollLockOn(boolean value) {
		runLater[this.localController.showScrollLockOn(value)]
	}

	override showShiftDown(boolean value) {
		runLater[this.localController.showShiftDown(value)]
	}

	private def runLater(Runnable r) {
		this.localController.virtualKeyboardPlatformExecutor.execute(r)
	}

	private def getLocalListener(Listener listener) {
		this.listenerMap.get(listener) ?: (new RemoteListenerWrapper(listener)[removeListener(listener)] => [
			this.listenerMap.put(listener, it)
		])
	}

	private def <T> T waitAndGet(Supplier<T> supplier) {

		val latch = new CountDownLatch(1)
		val value = new AtomicReference<T>

		runLater[
			try {
				value.set = supplier.get
			} finally {
				latch.countDown
			}
		]

		latch.await
		value.get
	}

	static class RemoteListenerWrapper implements VirtualKeyboardController.Listener {

		final Listener remoteListener
		final Runnable cleanup

		volatile boolean offline
		volatile boolean armed

		new(Listener remoteListener, Runnable cleanup) {
			this.remoteListener = remoteListener
			this.cleanup = cleanup
		}

		override fireBreak(KeyCode keyCode, int[] breakCode) {
			if (armed && !offline) {
				try {
					this.remoteListener.fireBreak(keyCode, breakCode)
				} catch (RemoteException e) {
					this.offline = true
					this.cleanup.run
				}
			}
		}

		override fireMake(KeyCode keyCode, int[] makeCode, boolean typematic) {
			if (armed && !offline) {
				try {
					this.remoteListener.fireMake(keyCode, makeCode, typematic)
				} catch (RemoteException e) {
					this.offline = true
					this.cleanup.run
				}
			}
		}

	}
}
