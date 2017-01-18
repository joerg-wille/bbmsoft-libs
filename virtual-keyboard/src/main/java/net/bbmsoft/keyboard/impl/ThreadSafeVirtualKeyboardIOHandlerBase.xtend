package net.bbmsoft.keyboard.impl

import java.util.List
import net.bbmsoft.keyboard.KeyCode
import net.bbmsoft.keyboard.VirtualKeyboardController
import net.bbmsoft.keyboard.VirtualKeyboardIOHandler
import net.bbmsoft.keyboard.impl.modifiers.StickyModifier

import static net.bbmsoft.keyboard.KeyCode.*

abstract class ThreadSafeVirtualKeyboardIOHandlerBase implements VirtualKeyboardIOHandler, VirtualKeyboardController.Listener {

	final List<Listener> listeners

	final StickyModifier shift
	final StickyModifier ctrl
	final StickyModifier alt
	final StickyModifier altGraph
	final StickyModifier os

	protected final Object lock

	new() {

		this.lock = new Object

		this.shift = new StickyModifier([this.isStickyModifiersEnabled], [
			this.shiftDown = it
			this.controller.showShiftDown(it)
		])

		this.ctrl = new StickyModifier([this.isStickyModifiersEnabled], [
			this.ctrlDown = it
			this.controller.showCtrlDown(it)
		])

		this.alt = new StickyModifier([this.isStickyModifiersEnabled], [
			this.altDown = it
			this.controller.showAltDown(it)
		])

		this.altGraph = new StickyModifier([this.isStickyModifiersEnabled], [
			this.altGraphDown = it
			this.controller.showAltGraphDown(it)
		])

		this.os = new StickyModifier([this.isStickyModifiersEnabled], [
			this.osDown = it
			this.controller.showOsDown(it)
		])

		this.listeners = newArrayList
	}

	override addListener(Listener listener) {
		synchronized (this.lock) {
			this.listeners.add(listener)
		}
	}

	override removeListener(Listener listener) {
		synchronized (this.lock) {
			this.listeners.remove(listener)
		}
	}

	// this may be called from any controller thread
	override fireMake(KeyCode keyCode, int[] makeCode, boolean typematic) {
		synchronized (this.lock) {
			doFireMake(keyCode, typematic, makeCode)
		}
	}

	// this may be called from any controller thread
	override fireBreak(KeyCode keyCode, int[] breakCode) {
		synchronized (this.lock) {
			doFireBreak(keyCode, breakCode)
		}
	}

	private def void doFireBreak(KeyCode keyCode, int[] breakCode) {

		if (keyCode == SHIFT_L || keyCode == SHIFT_R) {
			this.shift.release
		}

		if (keyCode == CTRL_L || keyCode == CTRL_L) {
			this.ctrl.release
		}

		if (keyCode == ALT_L) {
			this.alt.release
		}

		if (keyCode == ALT_R) {
			this.altGraph.release
		}

		if (keyCode == OS_L || keyCode == OS_R) {
			this.os.release
		}

		if (keyCode.isInputKey) {

			this.shift.releaseUnicodeKey
			this.ctrl.releaseUnicodeKey
			this.alt.releaseUnicodeKey
			this.altGraph.releaseUnicodeKey
			this.os.releaseUnicodeKey
		}

		this.listeners.forEach [
			keyReleased(keyCode, breakCode, this.shiftDown, this.ctrlDown, this.altDown, this.altGraphDown, this.osDown)
		]
	}

	private def void doFireMake(KeyCode keyCode, boolean typematic, int[] makeCode) {

		if ((keyCode == SHIFT_L || keyCode == SHIFT_R) && !typematic) {
			this.shift.press
		}

		if ((keyCode == CTRL_L || keyCode == CTRL_R) && !typematic) {
			this.ctrl.press
		}

		if (keyCode == ALT_L && !typematic) {
			this.alt.press
		}

		if (keyCode == ALT_R && !typematic) {
			this.altGraph.press
		}

		if ((keyCode == OS_L || keyCode == OS_R) && !typematic) {
			this.os.press
		}

		if (keyCode == capsOffKey && this.capsLockOn) {
			this.capsLockOn = false
		} else if (keyCode == CAPS_LOCK && !typematic) {
			this.capsLockOn = true
		}

		if (keyCode == NUM_LOCK && !typematic) {
			this.numLockOn = !this.numLockOn
		}

		if (keyCode == SCROLL_LOCK && !typematic) {
			this.scrollLockOn = !this.scrollLockOn
		}

		if (keyCode.isInputKey) {

			this.shift.pressUnicodeKey
			this.ctrl.pressUnicodeKey
			this.alt.pressUnicodeKey
			this.altGraph.pressUnicodeKey
			this.os.pressUnicodeKey
		}

		this.listeners.forEach [

			keyPressed(keyCode, makeCode, this.shiftDown, this.ctrlDown, this.altDown, this.altGraphDown, this.osDown,
				typematic)

			if (keyCode.isInputKey) {

				val shift = (this.shiftDown && (!this.capsLockOn || !this.keyMap.isLetter(keyCode))) ||
					(this.capsLockOn && this.keyMap.isLetter(keyCode) && !this.shiftDown)

				val character = (if (shift && this.altGraphDown) {
					this.keyMap.getQuartaryChar(keyCode)
				} else if (this.altGraphDown) {
					this.keyMap.getTertiaryChar(keyCode)
				} else if (shift) {
					this.keyMap.getSecondaryChar(keyCode)
				} else {
					this.keyMap.getPrimaryChar(keyCode)
				}) ?: ''

				keyTyped(keyCode, makeCode, character, this.shiftDown, this.ctrlDown, this.altDown, this.altGraphDown,
					this.osDown, typematic)
			}

		]
	}

}
