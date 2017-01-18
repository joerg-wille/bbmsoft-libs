package net.bbmsoft.fx.osk

import java.net.URL
import java.util.ArrayList
import java.util.List
import java.util.ResourceBundle
import javafx.application.Platform
import javafx.beans.value.ChangeListener
import javafx.collections.FXCollections
import javafx.collections.ObservableList
import javafx.fxml.FXML
import javafx.fxml.FXMLLoader
import javafx.fxml.Initializable
import javafx.scene.Node
import javafx.scene.Parent
import javafx.scene.control.IndexRange
import javafx.scene.control.Labeled
import javafx.scene.control.TextField
import javafx.scene.control.TextInputControl
import javafx.scene.layout.GridPane
import net.bbmsoft.fx.osk.impl.components.KeyButton
import net.bbmsoft.fxtended.annotations.binding.BindableProperty
import net.bbmsoft.fxtended.annotations.binding.CheckFXThread
import net.bbmsoft.fxtended.annotations.css.PseudoClasses
import net.bbmsoft.keyboard.KeyCode
import net.bbmsoft.keyboard.KeyMap
import net.bbmsoft.keyboard.VirtualKeyboard
import net.bbmsoft.keyboard.VirtualKeyboardVisualizer
import org.eclipse.xtend.lib.annotations.Accessors

import static extension net.bbmsoft.fxtended.extensions.BindingOperatorExtensions.*

@PseudoClasses('shift', 'ctrl', 'alt', 'alt-graph', 'os', 'caps-lock', 'num-lock', 'scroll-lock')
class OskFx extends GridPane implements VirtualKeyboard, NodeAttachableVirtualKeyboard, VirtualKeyboardVisualizer, Initializable {

	final List<Listener> listeners

	@FXML
	@Accessors(PUBLIC_GETTER) TextInputControl inputIndicator

	@FXML
	@Accessors(PUBLIC_GETTER) Labeled inputIndicatorPrefix
	@FXML
	@Accessors(PUBLIC_GETTER) Labeled inputIndicatorPostfix

	@BindableProperty KeyMap keyMap

	ChangeListener<String> localTextListener
	ChangeListener<Number> localCaretListener
	ChangeListener<IndexRange> localSelectionListener

	@Accessors final ObservableList<OskFxNodeConnector> nodeConnectors

	boolean initialized

	new() {

		this.listeners = newArrayList
		this.nodeConnectors = FXCollections.observableArrayList

		this.pickOnBounds = false

		this.focusTraversable = false

	}

	@CheckFXThread
	def load(URL boardLayout) {

		if (this.initialized) {
			throw new IllegalStateException('This OSK already has a layout!')
		}

		this.initialized = true

		val boardLoader = new FXMLLoader(boardLayout);

		boardLoader.root = this
		boardLoader.controller = this
		boardLoader.load

	}

	override initialize(URL location, ResourceBundle resources) {

		this.bindInputIndicator

		allKeys.forEach [
			osk = this
			keyMapProperty << this.keyMapProperty
		]
	}

	override showAltDown(boolean value) {
		this.pseudoClassStateChanged(PSEUDO_CLASS_ALT, value)
	}

	override showAltGraphDown(boolean value) {
		this.pseudoClassStateChanged(PSEUDO_CLASS_ALT_GRAPH, value)
	}

	override showCapsLockOn(boolean value) {
		this.pseudoClassStateChanged(PSEUDO_CLASS_CAPS_LOCK, value)
	}

	override showCtrlDown(boolean value) {
		this.pseudoClassStateChanged(PSEUDO_CLASS_CTRL, value)
	}

	override showNumLockOn(boolean value) {
		this.pseudoClassStateChanged(PSEUDO_CLASS_NUM_LOCK, value)
	}

	override showOsDown(boolean value) {
		this.pseudoClassStateChanged(PSEUDO_CLASS_OS, value)
	}

	override showScrollLockOn(boolean value) {
		this.pseudoClassStateChanged(PSEUDO_CLASS_SCROLL_LOCK, value)
	}

	override showShiftDown(boolean value) {
		this.pseudoClassStateChanged(PSEUDO_CLASS_SHIFT, value)
	}

	override addListener(Listener listener) {
		this.listeners.add = listener
	}

	override removeListener(Listener listener) {
		this.listeners.remove = listener
	}

	override setIndicatorText(String value) {
		Platform.runLater [
			if (this.inputIndicator != null) {

				this.inputIndicator.textProperty.removeListener(this.localTextListener)
				this.inputIndicator.selectionProperty.removeListener(this.localSelectionListener)
				this.inputIndicator.caretPositionProperty.removeListener(this.localCaretListener)

				this.inputIndicator.setText(value)
				this.inputIndicator.positionCaret(value.length)

				this.inputIndicator.textProperty.addListener(this.localTextListener)
				this.inputIndicator.selectionProperty.addListener(this.localSelectionListener)
				this.inputIndicator.caretPositionProperty.addListener(this.localCaretListener)
			}
		]
	}

	override setIndicatorSelection(int start, int end) {
		Platform.runLater [

			this.inputIndicator.selectionProperty.removeListener(this.localSelectionListener)
			this.inputIndicator.caretPositionProperty.removeListener(this.localCaretListener)

			this.inputIndicator?.selectRange(start, end)

			this.inputIndicator.selectionProperty.addListener(this.localSelectionListener)
			this.inputIndicator.caretPositionProperty.addListener(this.localCaretListener)
		]
	}

	override requestInputIndicatorFocus() {
		Platform.runLater[this.inputIndicator?.requestFocus]
	}

	def void press(KeyCode code) {
		this.listeners.forEach[pressed(code)]
	}

	def void release(KeyCode code) {
		this.listeners.forEach[released(code)]
	}

	// IMPLEMENTATION
	private def bindInputIndicator() {

		if (inputIndicator == null) {
			return
		}

		this.localTextListener = inputIndicator.textProperty >> [ t |
			this.nodeConnectors.forEach[text = t]
		]
		this.localCaretListener = inputIndicator.caretPositionProperty >> [ i |
			this.nodeConnectors.forEach[caretPosition = i.intValue]
		]
		this.localSelectionListener = inputIndicator.selectionProperty >> [ sel |
			this.nodeConnectors.forEach[selectRange(sel.start, sel.end)]
		]

		if (inputIndicator instanceof TextField) {
			inputIndicator.onAction = [
				this.nodeConnectors.forEach[enter]
			]
		}

	}

	private def List<KeyButton> getAllKeys() {

		val keys = new ArrayList<KeyButton>

		findKeys(children, keys)

		keys
	}

	private def void findKeys(ObservableList<Node> children, ArrayList<KeyButton> buttons) {

		children.forEach [
			if(it instanceof KeyButton) buttons.add(it)
			if(it instanceof Parent) findKeys(it.childrenUnmodifiable, buttons)
		]
	}

}
