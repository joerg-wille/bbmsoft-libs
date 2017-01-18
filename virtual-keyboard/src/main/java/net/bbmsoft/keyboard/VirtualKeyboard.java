package net.bbmsoft.keyboard;

/**
 *
 * This interface represents a virtual keyboard. This could for example be a
 * JavaFX or Swing application that has a GUI resembling a keyboard or an
 * abstraction layer providing keyboard functionality for a network or hardware
 * device.
 * <p>
 * Implementations of this interface are expected to generate or react to actual
 * key strokes and call all registered listeners with the according key codes.
 * For example if the implementing class provides a keyboard like UI and the
 * user clicks/touches the A-key, {@link Listener#pressed(KeyCode)
 * pressed(KeyCode.A)} and {@link Listener#released(KeyCode)
 * released(KeyCode.A)} should be called on all listeners.
 * <p>
 * Implementations should not take care of mapping keyboard layouts, producing
 * Strings or characters from the events or handling typematic (repetition of
 * keys being held pressed). This is the job of the
 * {@link VirtualKeyboardController} handling this keyboard implementation.
 * <p>
 * Normally the only listener expected to be registered to this interface and
 * the only class calling any of this interfacee's functions is an instance of
 * the {@link VirtualKeyboardController}.
 *
 * @author Michael Bachmann
 *
 */
public interface VirtualKeyboard {

	/**
	 * Whenever a key of a {@link VirtualKeyboard} is pressed or released, this
	 * listener is informed about it. There will always be one press and one
	 * release call with the same {@link KeyCode}. Transforming the code into
	 * proper make and break codes and deciding when and how often to send them
	 * (e.g. to stick to certain scan code set conventions or to implement a
	 * typematic function) is the responsibility of the
	 * {@link VirtualKeyboardController} that registered this listener.
	 *
	 * @author Michael Bachmann
	 *
	 */
	public interface Listener {

		public abstract void pressed(KeyCode code);

		public abstract void released(KeyCode code);
	}

	public abstract boolean addListener(Listener listener);

	public abstract boolean removeListener(Listener listener);
}
