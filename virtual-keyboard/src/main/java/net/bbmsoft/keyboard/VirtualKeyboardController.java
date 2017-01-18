package net.bbmsoft.keyboard;

/**
 * This interface is meant to handle the events and set statuses on a
 * {@link VirtualKeyboard}.
 * <p>
 * It can implement software that for example
 * <ul>
 * <li>emulates a hardware device to create key events on an operating system
 * level</li>
 * <li>is directly integrated into a GUI application to provide an
 * on-screen-keyboard</li>
 * <li>runs on a device implementing the USB HID class to act as an actual
 * hardware keyboard</li>
 * <li>...</li>
 * </ul>
 * <p>
 * In most cases it makes sense if an implementation of this interface also
 * implements the {@link VirtualKeyboard.Listener} interface.
 *
 * @author Michael Bachmann
 *
 */

public interface VirtualKeyboardController extends VirtualKeyboardVisualizer {
	/**
	 * Whenever a key of the {@link VirtualKeyboard} controlled by this
	 * controller is pressed or released, this listener is informed about it.
	 * The {@link KeyCode} passed to the according listener function will always
	 * be a valid make or break code matching the configured scan code set. If
	 * typematic is enabled, holding a key down will trigger a series of pressed
	 * events according to the configured delay and rate.
	 *
	 * @author Michael Bachmann
	 *
	 */
	public interface Listener {

		public abstract void fireMake(KeyCode keyCode, int[] makeCode, boolean typematic);

		public abstract void fireBreak(KeyCode keyCode, int[] breakCode);
	}

	public default VirtualKeyboardVisualizer getVirtualKeyboardVisualizer() {
		return null;
	}

	public abstract boolean addListener(Listener listener);

	public abstract boolean removeListener(Listener listener);

	public abstract void setTypeMaticEnabled(boolean value);

	public abstract boolean isTypeMaticEnabled();

	public abstract void setTypeMaticDelay(long value);

	public abstract long getTypeMaticDelay();

	public abstract void setTypeMaticRate(double value);

	public abstract double getTypeMaticRate();

	public abstract void setScanCodeSet(ScanCodeSet value);

	public abstract ScanCodeSet getScanCodeSet();

	@Override
	public default void showShiftDown(boolean value) {
		if (this.getVirtualKeyboardVisualizer() != null) {
			this.getVirtualKeyboardVisualizer().showShiftDown(value);
		}
	}

	@Override
	public default void showCtrlDown(boolean value) {
		if (this.getVirtualKeyboardVisualizer() != null) {
			this.getVirtualKeyboardVisualizer().showCtrlDown(value);
		}
	}

	@Override
	public default void showAltDown(boolean value) {
		if(this.getVirtualKeyboardVisualizer() != null) {
			this.getVirtualKeyboardVisualizer().showAltDown(value);
		}
	}

	@Override
	public default void showAltGraphDown(boolean value) {
		if(this.getVirtualKeyboardVisualizer() != null) {
			this.getVirtualKeyboardVisualizer().showAltGraphDown(value);
		}
	}

	@Override
	public default void showOsDown(boolean value) {
		if(this.getVirtualKeyboardVisualizer() != null) {
			this.getVirtualKeyboardVisualizer().showOsDown(value);
		}
	}

	@Override
	public default void showCapsLockOn(boolean value) {
		if(this.getVirtualKeyboardVisualizer() != null) {
			this.getVirtualKeyboardVisualizer().showCapsLockOn(value);
		}
	}

	@Override
	public default void showNumLockOn(boolean value) {
		if(this.getVirtualKeyboardVisualizer() != null) {
			this.getVirtualKeyboardVisualizer().showNumLockOn(value);
		}
	}

	@Override
	public default void showScrollLockOn(boolean value) {
		if(this.getVirtualKeyboardVisualizer() != null) {
			this.getVirtualKeyboardVisualizer().showScrollLockOn(value);
		}
	}

	@Override
	public default void setKeyMap(KeyMap value) {
		if(this.getVirtualKeyboardVisualizer() != null) {
			this.getVirtualKeyboardVisualizer().setKeyMap(value);
		}
	}

}
