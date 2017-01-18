package net.bbmsoft.fx.osk.impl.layout

import net.bbmsoft.fxtended.annotations.binding.BindableProperty

class KeyBinding {

	@BindableProperty KeyCode code
	@BindableProperty String defaultChar
	@BindableProperty String shiftChar
	@BindableProperty String altChar
	@BindableProperty String altGraphChar
	@BindableProperty String shiftAltChar
	@BindableProperty String shiftAltGraphChar
	@BindableProperty String displayText
}