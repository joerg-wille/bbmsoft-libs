package net.bbmsoft.fx.osk.impl.layout

import java.util.HashMap
import java.util.Map
import net.bbmsoft.keyboard.KeyCode
import net.bbmsoft.keyboard.KeyMap

class SimpleKeyMap implements KeyMap {

	final Map<KeyCode, KeyBinding> keyBindings

	new() {
		this.keyBindings = new HashMap
	}

	override getDisplayText(KeyCode keyCode) {
		this.keyBindings.get(keyCode)?.displayText
	}

	override getPrimaryChar(KeyCode keyCode) {
		this.keyBindings.get(keyCode)?.primaryCharacter
	}

	override getQuartaryChar(KeyCode keyCode) {
		this.keyBindings.get(keyCode)?.quartaryCharacter
	}

	override getSecondaryChar(KeyCode keyCode) {
		this.keyBindings.get(keyCode)?.secondaryCharacter
	}

	override getTertiaryChar(KeyCode keyCode) {
		this.keyBindings.get(keyCode)?.tertiaryCharacter
	}

	override isLetter(KeyCode keyCode) {
		val binding = this.keyBindings.get(keyCode)
		binding != null && binding.isLetter
	}

	def add(KeyBinding keyBinding) {
		this.keyBindings.put(keyBinding.keyCode, keyBinding)
	}

	def remove(KeyBinding keyBinding) {
		this.keyBindings.remove(keyBinding.keyCode)
	}

}
