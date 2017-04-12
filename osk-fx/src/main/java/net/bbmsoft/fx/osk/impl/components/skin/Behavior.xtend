package net.bbmsoft.fx.osk.impl.components.skin

import java.util.concurrent.Executors
import java.util.concurrent.ScheduledExecutorService
import java.util.concurrent.ScheduledFuture
import java.util.concurrent.TimeUnit
import javafx.application.Platform
import javafx.event.EventTarget
import javafx.event.EventType
import javafx.scene.Node
import javafx.scene.control.TextInputControl
import javafx.scene.input.KeyEvent
import javafx.scene.input.MouseEvent
import javafx.scene.input.TouchEvent
import net.bbmsoft.fx.osk.OSK
import net.bbmsoft.fx.osk.impl.components.KeyButton
import net.bbmsoft.fx.osk.impl.layout.KeyCode
import net.bbmsoft.fxtended.annotations.css.PseudoClasses

import static extension javafx.event.Event.*

@PseudoClasses("touched")
class Behavior {

	final static ScheduledExecutorService executor = Executors.newScheduledThreadPool(1)
	ScheduledFuture<?> repeatFuture

	final KeyButton key

	ScheduledFuture<?> touchUpFuture

	boolean armed

	boolean down

	new(KeyButton button) {
		this.key = button
	}

	def onTouchPress(TouchEvent e) {
		pressed
	}

	def onMousePress(MouseEvent e) {
		if (!e.synthesized) {
			pressed
		}
	}

	def onTouchRelease(TouchEvent e) {
		released
	}

	def onMouseRelease(MouseEvent e) {
		if (!e.synthesized) {
			released
		}
	}

	private def pressed() {
		touchUpFuture?.cancel(false)
		Platform.runLater[key.pseudoClassStateChanged(PSEUDO_CLASS_TOUCHED, true)]
		this.down = true
		this.armed = true
		key.code.keyDown
	}

	private def released() {
		touchUpFuture = executor.schedule([
			Platform.runLater[key.pseudoClassStateChanged(PSEUDO_CLASS_TOUCHED, false)]
		], key.touchUpDelay, TimeUnit.MILLISECONDS)
		key.code.keyUp
		this.down = false
		this.armed = false
	}

	def onEntered(MouseEvent e) {
		if (this.down) {
			this.armed = true
			key.code.triggerRepeat
		}
	}

	def onExited(MouseEvent e) {
		this.repeatFuture?.cancel(false)
		this.armed = false
	}

	private def keyDown(KeyCode keyCode) {

		keyCode.firePressed
		if(key.code.isUnicode) keyCode.fireTyped
		keyCode.triggerRepeat
	}

	private def triggerRepeat(KeyCode keyCode) {

		this.repeatFuture?.cancel(false)

		if (keyCode.canRepeat) {
			keyCode.doTriggerRepeat
		}

	}

	private def doTriggerRepeat(KeyCode keyCode) {

		val delay = OSK.repeatDelay
		val repDelay = 1000 / OSK.repeatFrequency

		this.repeatFuture = executor.scheduleAtFixedRate([Platform.runLater[keyCode.repeat]], delay, repDelay,
			TimeUnit.MILLISECONDS)
	}

	private def repeat(KeyCode it) {
		firePressed
		if(isUnicode) fireTyped
	}

	private def keyUp(KeyCode keyCode) {

		this.repeatFuture?.cancel(false)

		if (this.armed) {

			keyCode.fireReleased

			if (key.code.isUnicode && (key.osk.lockShift && key.osk.shiftDown && !key.osk.capsLock)) {
				key.osk.shiftDown = false
			}

			if (key.code.isUnicode && (key.osk.lockShift && key.osk.ctrlDown)) {
				key.osk.ctrlDown = false
			}

			if (key.code.isUnicode && (key.osk.lockShift && key.osk.altDown)) {
				key.osk.altDown = false
			}

			if (key.code.isUnicode && (key.osk.lockShift && key.osk.altGraphDown)) {
				key.osk.altGraphDown = false
			}

			if (key.code.isUnicode && (key.osk.lockShift && key.osk.metaDown)) {
				key.osk.metaDown = false
			}
		}
	}

	private def firePressed(KeyCode keyCode) {

		switch (keyCode) {
			case SHIFT_L,
			case SHIFT_R:
				key.osk.shiftDown = !key.osk.shiftDown
			case CAPS: {
				key.osk.capsLock = !key.osk.capsLock
				key.osk.shiftDown = key.osk.capsLock
			}
			case CONTROL_L,
			case CONTROL_R:
				key.osk.ctrlDown = !key.osk.lockShift || !key.osk.ctrlDown
			case ALT_L,
			case ALT_R:
				key.osk.altDown = !key.osk.lockShift || !key.osk.altDown
			case ALT_GRAPH:
				key.osk.altGraphDown = !key.osk.lockShift || !key.osk.altGraphDown
			case OS_L,
			case OS_R:
				key.osk.metaDown = !key.osk.lockShift || !key.osk.metaDown
			default: {
			}
		}

		keyCode.sendPressed
	}

	private def fireReleased(KeyCode keyCode) {

		switch (keyCode) {
			case SHIFT_L,
			case SHIFT_R:
				if(key.osk.capsLock || !key.osk.lockShift) key.osk.shiftDown = !key.osk.shiftDown
			case CONTROL_L,
			case CONTROL_R:
				if(!key.osk.lockShift) key.osk.ctrlDown = false
			case ALT_L,
			case ALT_R:
				if(!key.osk.lockShift) key.osk.altDown = false
			case ALT_GRAPH:
				if(!key.osk.lockShift) key.osk.altGraphDown = false
			case OS_L,
			case OS_R:
				key.osk.metaDown = false
			default: {
			}
		}

		keyCode.sendReleased
	}

	private def Void fireTyped(KeyCode keyCode) {
		keyCode.sendTyped
		null
	}

	private def sendPressed(KeyCode code) {

		key.osk.targetNode ?: key.osk.targetScene => [
			updateFocus(key.osk.inputIndicator ?: it)
			it?.fireEvent(createEvent(KeyEvent.KEY_PRESSED, code))
		]
	}

	private def sendReleased(KeyCode code) {

		key.osk.targetNode ?: key.osk.targetScene => [
			updateFocus(key.osk.inputIndicator ?: it)
			it?.fireEvent(createEvent(KeyEvent.KEY_RELEASED, code))
		]
	}

	private def sendTyped(KeyCode code) {

		key.osk.targetNode ?: key.osk.targetScene => [
			updateFocus(key.osk.inputIndicator ?: it)
			it?.fireEvent(createEvent(KeyEvent.KEY_TYPED, code))
		]
	}

	private def updateFocus(Object target) {
		if (target instanceof Node) {
			if (!target.focused) {
				target.requestFocus
				if (target instanceof TextInputControl) {
					if(target.text !== null) target.positionCaret(target.text.length)
				}
			}
		}
	}

	private def KeyEvent createEvent(EventTarget eventTarget, EventType<KeyEvent> type, KeyCode keyCode) {

		val source = eventTarget
		val target = eventTarget
		val eventType = type
		val character = keyCode.character
		val text = character
		val code = keyCode

		val shiftDown = key.osk.shiftDown
		val controlDown = key.osk.ctrlDown
		val altDown = key.osk.altDown
		val metaDown = key.osk.metaDown

		new KeyEvent(source, target, eventType, character, text, code.toJfxKeyCode, shiftDown, controlDown, altDown,
			metaDown)
	}

	private def getCharacter(KeyCode keyCode) {

		val it = key.osk
		val extension map = key.osk.getLayout.keyMap

		if (!keyCode.isUnicode) {
			""
		} else if (!shiftDown && !altDown && !altGraphDown && !ctrlDown && !metaDown) {
			keyCode.get?.defaultChar ?: ""
		} else if (shiftDown && !altDown && !altGraphDown && !ctrlDown && !metaDown) {
			keyCode.get?.shiftChar ?: ""
		} else if (!shiftDown && !altDown && altGraphDown && !ctrlDown && !metaDown) {
			keyCode.get?.altChar ?: ""
		} else {
			""
		}
	}
}
