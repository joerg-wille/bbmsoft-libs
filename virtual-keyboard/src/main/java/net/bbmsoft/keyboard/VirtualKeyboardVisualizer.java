package net.bbmsoft.keyboard;

public interface VirtualKeyboardVisualizer {

	public abstract void showShiftDown(boolean value);
	public abstract void showCtrlDown(boolean value);
	public abstract void showAltDown(boolean value);
	public abstract void showAltGraphDown(boolean value);
	public abstract void showOsDown(boolean value);

	public abstract void showCapsLockOn(boolean value);
	public abstract void showNumLockOn(boolean value);
	public abstract void showScrollLockOn(boolean value);

	public abstract void setKeyMap(KeyMap map);
}
