package net.bbmsoft.fx.osk.impl.layout;

import net.bbmsoft.keyboard.KeyCode;

public interface KeyBinding {

	public abstract KeyCode getKeyCode();
	public abstract String getPrimaryCharacter();
	public abstract String getSecondaryCharacter();
	public abstract String getTertiaryCharacter();
	public abstract String getQuartaryCharacter();
	public abstract String getDisplayText();
	public abstract boolean isLetter();
}
