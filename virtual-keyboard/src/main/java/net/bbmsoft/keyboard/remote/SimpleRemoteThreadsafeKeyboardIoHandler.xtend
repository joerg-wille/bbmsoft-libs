package net.bbmsoft.keyboard.remote

import net.bbmsoft.keyboard.impl.SimpleThreadsafeKeyboardIoHandler
import net.bbmsoft.keyboard.VirtualKeyboardController
import net.bbmsoft.keyboard.KeyMap

class SimpleRemoteThreadsafeKeyboardIoHandler extends SimpleThreadsafeKeyboardIoHandler implements RemoteVirtualKeyboardController.Listener {

	new(VirtualKeyboardController controller, KeyMap keyMap) {
		super(controller, keyMap)
	}

}