package net.bbmsoft.fx.osk.impl

import net.bbmsoft.keyboard.impl.SimpleThreadsafeKeyboardIoHandler
import net.bbmsoft.keyboard.VirtualKeyboardController
import net.bbmsoft.keyboard.KeyMap

class RemoteOskHandler extends SimpleThreadsafeKeyboardIoHandler {

	new(VirtualKeyboardController controller, KeyMap keyMap) {
		super(controller, keyMap)
	}

}