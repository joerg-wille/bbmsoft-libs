package net.bbmsoft.fx.osk.impl.layout

import java.io.Serializable
import net.bbmsoft.keyboard.KeyCode
import org.eclipse.xtend.lib.annotations.Accessors

class SimpleKeyBinding implements KeyBinding, Serializable {

	@Accessors KeyCode keyCode
	@Accessors String primaryCharacter
	@Accessors String secondaryCharacter
	@Accessors String tertiaryCharacter
	@Accessors String quartaryCharacter
	@Accessors String displayText
	@Accessors boolean letter

}
