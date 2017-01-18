package net.bbmsoft.keyboard;

import java.io.Serializable;

public interface KeyMap extends Serializable {

	public String getPrimaryChar(KeyCode keyCode);

	public String getSecondaryChar(KeyCode keyCode);

	public String getTertiaryChar(KeyCode keyCode);

	public String getQuartaryChar(KeyCode keyCode);

	public String getDisplayText(KeyCode keyCode);

	public boolean isLetter(KeyCode keyCode);
}
