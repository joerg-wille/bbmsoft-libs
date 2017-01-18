package net.bbmsoft.fx.osk

import net.bbmsoft.fxtended.annotations.binding.BindableProperty
import net.bbmsoft.fxtended.annotations.binding.Lazy
import net.bbmsoft.keyboard.KeyCode
import net.bbmsoft.keyboard.KeyMap
import net.bbmsoft.keyboard.ScanCodeSet
import net.bbmsoft.keyboard.impl.VirtualKeyboardIOHandlerBase
import org.eclipse.xtend.lib.annotations.Accessors

import static extension net.bbmsoft.fxtended.extensions.BindingOperatorExtensions.*

class OskFxIOHandler extends VirtualKeyboardIOHandlerBase {

	@Accessors final OskFxController controller
	@Accessors final OskFx keyBoard

	@Lazy @BindableProperty boolean shiftDown
	@Lazy @BindableProperty boolean ctrlDown
	@Lazy @BindableProperty boolean altDown
	@Lazy @BindableProperty boolean altGraphDown
	@Lazy @BindableProperty boolean osDown

	@Lazy @BindableProperty boolean capsLockOn
	@Lazy @BindableProperty boolean numLockOn
	@Lazy @BindableProperty boolean scrollLockOn

	@Lazy @BindableProperty KeyCode capsOffKey
	@Lazy @BindableProperty KeyMap keyMap
	@Lazy @BindableProperty ScanCodeSet scanCodeSet

	@Lazy @BindableProperty boolean stickyModifiersEnabled

	new(OskFxController controller, OskFx keyBoard, KeyMap keyMap) {

		this.controller = controller
		this.keyBoard = keyBoard

		this.controller.scanCodeSetProperty << this.scanCodeSetProperty

		this.controller.typeMaticEnabled = true
		this.controller.typeMaticDelay = 750
		this.controller.typeMaticRate = 20

		this.keyMapProperty >> [this.controller.keyMap = it]

		this.capsOffKey = KeyCode.CAPS_LOCK
		this.keyMap = keyMap
		this.scanCodeSet = ScanCodeSet.SET_USB

		this.stickyModifiersEnabled = true

		this.capsLockOnProperty >> [this.controller.showCapsLockOn = it]
		this.numLockOnProperty >> [this.controller.showNumLockOn = it]
		this.scrollLockOnProperty >> [this.controller.showScrollLockOn = it]

	}

}
