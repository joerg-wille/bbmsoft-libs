package net.bbmsoft.keyboard;

/**
 *
 * Receives raw keyboard scan codes and turns them into semantic key events that
 * are associated with a string/character and transport information about which
 * modifier keys were pressed. Also sets LED status on the keyboard.
 *
 * @author Michael Bachmann
 *
 */

public interface VirtualKeyboardIOHandler {

	public interface Listener {

		public void keyPressed(KeyCode keyCode, int[] makeCode, boolean shiftDown, boolean ctrlDown, boolean altDown,
				boolean altGraphDown, boolean osDown, boolean typematic);

		public void keyTyped(KeyCode keyCode, int[] makeCode, String character, boolean shiftDown, boolean ctrlDown,
				boolean altDown, boolean altGraphDown, boolean osDown, boolean typematic);

		public void keyReleased(KeyCode keyCode, int[] breakCode, boolean shiftDown, boolean ctrlDown, boolean altDown,
				boolean altGraphDown, boolean osDown);

	}

	public abstract VirtualKeyboardController getController();

	public abstract KeyMap getKeyMap();

	public abstract void setKeyMap(KeyMap value);

	public abstract boolean addListener(Listener listener);

	public abstract boolean removeListener(Listener listener);

	public abstract void setStickyModifiersEnabled(boolean value);

	public abstract boolean isStickyModifiersEnabled();

	public abstract void setScanCodeSet(ScanCodeSet value);

	public abstract ScanCodeSet getScanCodeSet();

	public abstract void setCapsOffKey(KeyCode value);

	public abstract KeyCode getCapsOffKey();

	public boolean isCapsLockOn();

	public void setCapsLockOn(boolean value);

	public boolean isNumLockOn();

	public void setNumLockOn(boolean value);

	public boolean isScrollLockOn();

	public void setScrollLockOn(boolean value);

	public boolean isShiftDown();

	public void setShiftDown(boolean value);

	public boolean isCtrlDown();

	public void setCtrlDown(boolean value);

	public boolean isAltDown();

	public void setAltDown(boolean value);

	public boolean isAltGraphDown();

	public void setAltGraphDown(boolean value);

	public boolean isOsDown();

	public void setOsDown(boolean value);

}
