package net.bbmsoft.fx.osk

import java.util.Map
import javafx.application.Platform
import javafx.beans.value.ChangeListener
import javafx.event.ActionEvent
import javafx.scene.Node
import javafx.scene.Scene
import javafx.scene.control.IndexRange
import javafx.scene.control.TextField
import javafx.scene.control.TextInputControl
import javafx.scene.input.KeyEvent
import javafx.stage.Window
import net.bbmsoft.keyboard.KeyCode
import net.bbmsoft.keyboard.VirtualKeyboardIOHandler
import org.eclipse.xtend.lib.annotations.Accessors

import static javafx.scene.input.KeyCode.*

import static extension java.util.Objects.*

class OskFxNodeConnectorImpl implements VirtualKeyboardIOHandler.Listener, OskFxNodeConnector {

	final NodeAttachableVirtualKeyboard keyboard

	@Accessors(PUBLIC_GETTER) Node targetNode

	@Accessors(PUBLIC_GETTER) Scene targetScene

	final ChangeListener<Node> focusListener

	final ChangeListener<String> targetTextListener
	final ChangeListener<IndexRange> targetSelectionListener

	new(NodeAttachableVirtualKeyboard keyboard) {

		this.keyboard = keyboard

		if (this.keyboard != null) {
			this.targetTextListener = [this.keyboard.setIndicatorText($2)]
			this.targetSelectionListener = [this.keyboard.setIndicatorSelection($2.start, $2.end)]
		} else {
			this.targetTextListener = null
			this.targetSelectionListener = null
		}

		this.focusListener = [
			attach($2, true)
		]
	}

	override keyPressed(KeyCode keyCode, int[] makeCode, boolean shiftDown, boolean ctrlDown, boolean altDown,
		boolean altGraphDown, boolean osDown, boolean typematic) {

		if (this.targetNode == null) {
			return
		}

		val jfxCode = keyCode.toJfxKeyCode

		if (jfxCode == null) {
			return
		}

		val e = new KeyEvent(this.targetNode, this.targetNode, KeyEvent.KEY_PRESSED, '', '', jfxCode, shiftDown,
			ctrlDown, altDown, osDown)
		this.targetNode.fireEvent(e)
	}

	override keyReleased(KeyCode keyCode, int[] breakCode, boolean shiftDown, boolean ctrlDown, boolean altDown,
		boolean altGraphDown, boolean osDown) {

		if (this.targetNode == null) {
			return
		}

		val jfxCode = keyCode.toJfxKeyCode

		if (jfxCode == null) {
			return
		}

		val e = new KeyEvent(this.targetNode, this.targetNode, KeyEvent.KEY_RELEASED, '', '', jfxCode, shiftDown,
			ctrlDown, altDown, osDown)

		this.targetNode.fireEvent(e)
	}

	override keyTyped(KeyCode keyCode, int[] makeCode, String character, boolean shiftDown, boolean ctrlDown,
		boolean altDown, boolean altGraphDown, boolean osDown, boolean typematic) {

		if (this.targetNode == null) {
			return
		}

		val jfxCode = keyCode.toJfxKeyCode

		if (jfxCode == null) {
			return
		}

		val e = new KeyEvent(this.targetNode, this.targetNode, KeyEvent.KEY_TYPED, character, character, jfxCode,
			shiftDown, ctrlDown, altDown, osDown)

		this.targetNode.fireEvent(e)
	}

	override void attach(Window window) {

		window.requireNonNull("Window must not be null!")

		attach(window.scene)
	}

	override void attach(Scene scene) {

		scene.requireNonNull("Scene must not be null!")

		targetScene?.focusOwnerProperty?.removeListener(focusListener)

		targetScene = scene => [focusOwnerProperty.addListener(focusListener)]
	}

	override void attach(Node target) {
		attach(target, false)
	}

	private def void attach(Node target, boolean autoAttach) {

		if (!autoAttach) {
			targetScene?.focusOwnerProperty?.removeListener(focusListener)
			targetScene = null
		}

		target.requireNonNull("Target node must not be null!")

		targetNode = target

		target => [
			requestFocus
			if (it instanceof TextInputControl) {
				if(this.targetTextListener != null) textProperty.addListener = this.targetTextListener
				if(this.targetSelectionListener != null) selectionProperty.addListener = this.targetSelectionListener
				this.keyboard?.setIndicatorText(text)
				this.keyboard?.requestInputIndicatorFocus
				Platform.runLater [
					selectAll
				]
			}
		]
	}

	override void detach() {

		if (targetNode instanceof TextInputControl) {
			if(this.targetTextListener != null) targetNode.textProperty.removeListener = this.targetTextListener
			if(this.targetSelectionListener != null) targetNode.selectionProperty.removeListener = this.
				targetSelectionListener
		}

		targetScene?.focusOwnerProperty?.removeListener(focusListener)
		targetScene = null
		targetNode = null
	}

	def isAttached() {
		targetScene != null || targetNode != null
	}

	override enter() {
		if (this.targetNode instanceof TextField) {
			this.targetNode.fireEvent(new ActionEvent)
		}
	}

	override selectRange(int start, int end) {
		if (this.targetNode instanceof TextInputControl) {
			this.targetNode.selectRange(start, end)
		}
	}

	override setCaretPosition(int value) {
		if (this.targetNode instanceof TextInputControl) {
			this.targetNode.positionCaret = value
		}
	}

	override setText(String value) {
		if (this.targetNode instanceof TextInputControl) {
			this.targetNode.text = value
		}
	}

	private def javafx.scene.input.KeyCode toJfxKeyCode(KeyCode code) {
		toJfxKeyCode.get(code)
	}

	private static final Map<KeyCode, javafx.scene.input.KeyCode> toJfxKeyCode = newHashMap(
		KeyCode.ERROR -> null,
		KeyCode.ESC -> ESCAPE,
		KeyCode.DIGIT_1 -> DIGIT1,
		KeyCode.DIGIT_2 -> DIGIT2,
		KeyCode.DIGIT_3 -> DIGIT3,
		KeyCode.DIGIT_4 -> DIGIT4,
		KeyCode.DIGIT_5 -> DIGIT5,
		KeyCode.DIGIT_6 -> DIGIT6,
		KeyCode.DIGIT_7 -> DIGIT7,
		KeyCode.DIGIT_8 -> DIGIT8,
		KeyCode.DIGIT_9 -> DIGIT9,
		KeyCode.DIGIT_0 -> DIGIT0,
		KeyCode.SPECIAL_1 -> MINUS,
		KeyCode.SPECIAL_2 -> EQUALS,
		KeyCode.BACKSPACE -> BACK_SPACE,
		KeyCode.TAB -> TAB,
		KeyCode.Q -> Q,
		KeyCode.W -> W,
		KeyCode.E -> E,
		KeyCode.R -> R,
		KeyCode.T -> T,
		KeyCode.Y -> Z,
		KeyCode.U -> U,
		KeyCode.I -> I,
		KeyCode.O -> O,
		KeyCode.P -> P,
		KeyCode.SPECIAL_3 -> OPEN_BRACKET,
		KeyCode.SPECIAL_4 -> CLOSE_BRACKET,
		KeyCode.RETURN -> ENTER,
		KeyCode.CTRL_L -> CONTROL,
		KeyCode.A -> A,
		KeyCode.S -> S,
		KeyCode.D -> D,
		KeyCode.F -> F,
		KeyCode.G -> G,
		KeyCode.H -> H,
		KeyCode.J -> J,
		KeyCode.K -> K,
		KeyCode.L -> L,
		KeyCode.SPECIAL_5 -> SEMICOLON,
		KeyCode.SPECIAL_6 -> QUOTE,
		KeyCode.SPECIAL_7 -> BACK_QUOTE,
		KeyCode.SHIFT_L -> SHIFT,
		KeyCode.SPECIAL_8 -> BACK_SLASH,
		KeyCode.Z -> Z,
		KeyCode.X -> X,
		KeyCode.C -> C,
		KeyCode.V -> V,
		KeyCode.B -> B,
		KeyCode.N -> N,
		KeyCode.M -> M,
		KeyCode.SPECIAL_9 -> COMMA,
		KeyCode.SPECIAL_10 -> PERIOD,
		KeyCode.SPECIAL_11 -> SLASH,
		KeyCode.SHIFT_R -> SHIFT,
		KeyCode.NUMPAD_MULTIPLY -> MULTIPLY,
		KeyCode.ALT_L -> ALT,
		KeyCode.SPACE -> SPACE,
		KeyCode.CAPS_LOCK -> CAPS,
		KeyCode.F1 -> F1,
		KeyCode.F2 -> F2,
		KeyCode.F3 -> F3,
		KeyCode.F4 -> F4,
		KeyCode.F5 -> F5,
		KeyCode.F6 -> F6,
		KeyCode.F7 -> F7,
		KeyCode.F8 -> F8,
		KeyCode.F9 -> F9,
		KeyCode.F10 -> F10,
		KeyCode.NUM_LOCK -> NUM_LOCK,
		KeyCode.SCROLL_LOCK -> SCROLL_LOCK,
		KeyCode.NUMPAD_7 -> NUMPAD7,
		KeyCode.NUMPAD_8 -> NUMPAD8,
		KeyCode.NUMPAD_9 -> NUMPAD9,
		KeyCode.NUMPAD_MINUS -> MINUS,
		KeyCode.NUMPAD_4 -> NUMPAD4,
		KeyCode.NUMPAD_5 -> NUMPAD5,
		KeyCode.NUMPAD_6 -> NUMPAD6,
		KeyCode.NUMPAD_PLUS -> PLUS,
		KeyCode.NUMPAD_1 -> NUMPAD1,
		KeyCode.NUMPAD_2 -> NUMPAD2,
		KeyCode.NUMPAD_3 -> NUMPAD3,
		KeyCode.NUMPAD_0 -> NUMPAD0,
		KeyCode.NUMPAD_DECIMAL -> PERIOD,
		KeyCode.ALT_SYS_RQ -> null,
		KeyCode.F11 -> F11,
		KeyCode.F12 -> F12,
		KeyCode.NON_US_1 -> null,
		KeyCode.NUMPAD_ENTER -> ENTER,
		KeyCode.CTRL_R -> CONTROL,
		KeyCode.NUMPAD_DIVIDE -> DIVIDE,
		KeyCode.PRINT_SCREEN -> PRINTSCREEN,
		KeyCode.ALT_R -> ALT_GRAPH,
		KeyCode.CTRL_BREAK -> null,
		KeyCode.HOME -> HOME,
		KeyCode.ARROW_UP -> UP,
		KeyCode.PAGE_UP -> PAGE_UP,
		KeyCode.ARROW_LEFT -> LEFT,
		KeyCode.ARROW_RIGHT -> RIGHT,
		KeyCode.END -> END,
		KeyCode.ARROW_DOWN -> DOWN,
		KeyCode.PAGE_DOWN -> PAGE_DOWN,
		KeyCode.INSERT -> INSERT,
		KeyCode.DEL -> DELETE,
		KeyCode.OS_L -> WINDOWS,
		KeyCode.OS_R -> WINDOWS,
		KeyCode.MENU -> CONTEXT_MENU,
		KeyCode.POWER -> POWER,
		KeyCode.SLEEP -> null,
		KeyCode.WAKE -> null,
		KeyCode.PAUSE -> PAUSE
	)

}
