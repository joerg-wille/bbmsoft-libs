package net.bbmsoft.keyboard.impl

import net.bbmsoft.keyboard.KeyCode
import net.bbmsoft.keyboard.KeyMap
import net.bbmsoft.keyboard.ScanCodeSet
import net.bbmsoft.keyboard.VirtualKeyboardController
import org.eclipse.xtend.lib.annotations.Accessors

class SimpleThreadsafeKeyboardIoHandler extends ThreadSafeVirtualKeyboardIOHandlerBase {

	@Accessors final VirtualKeyboardController controller

	boolean shiftDown
	boolean ctrlDown
	boolean altDown
	boolean altGraphDown
	boolean osDown

	boolean capsLockOn
	boolean numLockOn
	boolean scrollLockOn

	KeyCode capsOffKey
	KeyMap keyMap
	ScanCodeSet scanCodeSet

	boolean stickyModifiersEnabled

	new(VirtualKeyboardController controller, KeyMap keyMap) {

		this.controller = controller

		this.controller.typeMaticEnabled = true
		this.controller.typeMaticDelay = 750
		this.controller.typeMaticRate = 20

		this.capsOffKey = KeyCode.CAPS_LOCK
		this.setKeyMap = keyMap
		this.setScanCodeSet = ScanCodeSet.SET_USB

		this.stickyModifiersEnabled = true

	}

	override getCapsOffKey() {
		synchronized (this.lock) {
			this.capsOffKey
		}
	}

	override getController() {
		synchronized (this.lock) {
			this.controller
		}
	}

	override getKeyMap() {
		synchronized (this.lock) {
			this.keyMap
		}
	}

	override setKeyMap(KeyMap value) {

		synchronized(this.lock) {
			this.keyMap = value
			this.controller.keyMap = value
		}
	}

	override getScanCodeSet() {
		synchronized (this.lock) {
			this.scanCodeSet
		}
	}

	override isAltDown() {
		synchronized (this.lock) {
			this.altDown
		}
	}

	override isAltGraphDown() {
		synchronized (this.lock) {
			this.altGraphDown
		}
	}

	override isCapsLockOn() {
		synchronized (this.lock) {
			this.capsLockOn
		}
	}

	override isCtrlDown() {
		synchronized (this.lock) {
			this.ctrlDown
		}
	}

	override isNumLockOn() {
		synchronized (this.lock) {
			this.numLockOn
		}
	}

	override isOsDown() {
		synchronized (this.lock) {
			this.osDown
		}
	}

	override isScrollLockOn() {
		synchronized (this.lock) {
			this.scrollLockOn
		}
	}

	override isShiftDown() {
		synchronized (this.lock) {
			this.shiftDown
		}
	}

	override isStickyModifiersEnabled() {
		synchronized (this.lock) {
			this.stickyModifiersEnabled
		}
	}

	override setAltDown(boolean value) {
		synchronized (this.lock) {
			this.altDown = value
		}
	}

	override setAltGraphDown(boolean value) {
		synchronized (this.lock) {
			this.altGraphDown = value
		}
	}

	override setCapsLockOn(boolean value) {
		synchronized (this.lock) {
			this.capsLockOn = value
		}
	}

	override setCapsOffKey(KeyCode value) {
		synchronized (this.lock) {
			this.capsOffKey = value
		}
	}

	override setCtrlDown(boolean value) {
		synchronized (this.lock) {
			this.ctrlDown = value
		}
	}

	override setNumLockOn(boolean value) {
		synchronized (this.lock) {
			this.numLockOn = value
		}
	}

	override setOsDown(boolean value) {
		synchronized (this.lock) {
			this.osDown = value
		}
	}

	override setScanCodeSet(ScanCodeSet value) {
		synchronized (this.lock) {
			this.scanCodeSet = value
			this.controller.scanCodeSet = value
		}
	}

	override setScrollLockOn(boolean value) {
		synchronized (this.lock) {
			this.scrollLockOn = value
		}
	}

	override setShiftDown(boolean value) {
		synchronized (this.lock) {
			this.shiftDown = value
		}
	}

	override setStickyModifiersEnabled(boolean value) {
		synchronized (this.lock) {
			this.stickyModifiersEnabled = value
		}
	}

}
