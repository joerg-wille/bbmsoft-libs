package net.bbmsoft.fx.osk.impl.components.skin

import java.util.concurrent.Executors
import java.util.concurrent.ScheduledExecutorService
import java.util.concurrent.ScheduledFuture
import java.util.concurrent.TimeUnit
import javafx.application.Platform
import javafx.scene.input.MouseEvent
import javafx.scene.input.TouchEvent
import net.bbmsoft.fx.osk.impl.components.KeyButton
import net.bbmsoft.fxtended.annotations.css.PseudoClasses

@PseudoClasses("touched")
class Behavior {

	final static ScheduledExecutorService executor = Executors.newScheduledThreadPool(1)

	final KeyButton key

	ScheduledFuture<?> touchUpFuture

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
		key.osk.press(this.key.code)
	}

	private def released() {
		touchUpFuture = executor.schedule([
			Platform.runLater[key.pseudoClassStateChanged(PSEUDO_CLASS_TOUCHED, false)]
		], key.touchUpDelay, TimeUnit.MILLISECONDS)
		key.osk.release(this.key.code)
		this.down = false
	}

	def onEntered(MouseEvent e) {
		if (this.down) {
			touchUpFuture?.cancel(false)
			Platform.runLater[key.pseudoClassStateChanged(PSEUDO_CLASS_TOUCHED, true)]
			key.osk.press(this.key.code)
		}
	}

	def onExited(MouseEvent e) {
		if(this.down) {
			touchUpFuture?.cancel(false)
			key.pseudoClassStateChanged(PSEUDO_CLASS_TOUCHED, false)
			key.osk.release(this.key.code)
		}
	}

}
