package net.bbmsoft.keyboard.impl.modifiers

import java.util.function.Consumer
import java.util.function.Supplier

class StickyModifier {

	final Supplier<Boolean> sticky
	final Consumer<Boolean> listener

	int actuallyDown
	boolean prepareToStick
	boolean sticking

	new(Supplier<Boolean> sticky, Consumer<Boolean> listener) {
		this.sticky = sticky
		this.listener = listener
	}

	def void press() {

		val alreadyPressed = this.actuallyDown++ > 0

		this.prepareToStick = this.sticky.get && !alreadyPressed && !this.sticking

		if (!alreadyPressed) {
			this.listener.accept(true)
		}
	}

	def void release() {

		this.actuallyDown--

		if (this.actuallyDown > 0) {
			return
		}

		if (this.prepareToStick) {
			this.sticking = true
		} else {
			this.sticking = false
			this.listener.accept(false)
		}
	}

	def void pressUnicodeKey() {
		this.prepareToStick = false
	}

	def void releaseUnicodeKey() {
		if (this.sticking) {
			this.sticking = false
			this.listener.accept(false)
		}
	}
}
