package net.bbmsoft.fx.osk

import java.net.URL
import java.net.URLClassLoader
import java.util.ArrayList
import java.util.List
import java.util.Locale
import java.util.ResourceBundle
import javafx.application.Platform
import javafx.beans.InvalidationListener
import javafx.beans.value.ChangeListener
import javafx.collections.ObservableList
import javafx.event.ActionEvent
import javafx.fxml.FXML
import javafx.fxml.FXMLLoader
import javafx.fxml.Initializable
import javafx.geometry.Point2D
import javafx.scene.CacheHint
import javafx.scene.Node
import javafx.scene.Parent
import javafx.scene.Scene
import javafx.scene.control.IndexRange
import javafx.scene.control.Labeled
import javafx.scene.control.TextField
import javafx.scene.control.TextInputControl
import javafx.scene.input.MouseEvent
import javafx.scene.layout.GridPane
import javafx.stage.Window
import net.bbmsoft.fx.osk.impl.components.KeyButton
import net.bbmsoft.fx.osk.impl.layout.OSKLayout
import net.bbmsoft.fxtended.annotations.binding.BindableProperty
import net.bbmsoft.fxtended.annotations.binding.CheckFXThread
import net.bbmsoft.fxtended.annotations.binding.Styleable
import net.bbmsoft.fxtended.annotations.css.PseudoClasses
import org.eclipse.xtend.lib.annotations.Accessors

import static extension java.util.Objects.*
import static extension net.bbmsoft.fxtended.extensions.BindingOperatorExtensions.*

@PseudoClasses("shift", "caps", "control", "alt", "altGraph", "meta")
class OSK extends GridPane implements Initializable {

	@Styleable('-lock-shift')
	@BindableProperty boolean lockShift = false

	@Accessors(PUBLIC_GETTER, PUBLIC_SETTER)
	static long repeatDelay = 750

	@Accessors(PUBLIC_GETTER, PUBLIC_SETTER)
	static long repeatFrequency = 20

	@FXML
	@Accessors(PUBLIC_GETTER) TextInputControl inputIndicator

	@FXML
	@Accessors(PUBLIC_GETTER) Labeled inputIndicatorPrefix
	@FXML
	@Accessors(PUBLIC_GETTER) Labeled inputIndicatorPostfix

	@BindableProperty boolean metaDown

	@BindableProperty boolean altDown

	@BindableProperty boolean altGraphDown

	@BindableProperty boolean ctrlDown

	@BindableProperty boolean shiftDown

	@BindableProperty boolean capsLock

	@BindableProperty OSKLayout layout

	@BindableProperty boolean playSound

	@Accessors(PUBLIC_GETTER) Node targetNode

	@Accessors(PUBLIC_GETTER) Scene targetScene

	ChangeListener<Node> focusListener
	ChangeListener<Boolean> focusedListener

	Point2D lastOffset

	ChangeListener<String> targetTextListener
	ChangeListener<String> localTextListener
	ChangeListener<Number> targetCaretListener
	ChangeListener<Number> localCaretListener
	ChangeListener<IndexRange> targetSelectionListener
	ChangeListener<IndexRange> localSelectionListener

	InvalidationListener initialPositioListener

	new(URL boardLayout, URL keyLayout) {
		load(boardLayout, keyLayout, null, null, null)
	}

	new(URL boardLayout, URL keyLayout, boolean resourceFromLayout) {
		this(boardLayout, keyLayout, if(resourceFromLayout) keyLayout.resourceBundleName else null, if(resourceFromLayout) keyLayout.resourceBundleClassLoadder else null)
	}

	new(URL boardLayout, URL keyLayout, String resourceBundleBaseName) {
		load(boardLayout, keyLayout, resourceBundleBaseName, Locale.^default, null)
	}

	new(URL boardLayout, URL keyLayout, String resourceBundleBaseName, Locale locale) {
		load(boardLayout, keyLayout, resourceBundleBaseName, locale, null)
	}

	new(URL boardLayout, URL keyLayout, String resourceBundleBaseName, Class<?> bundleClass) {
		load(boardLayout, keyLayout, resourceBundleBaseName, Locale.^default, bundleClass.classLoader)
	}

	new(URL boardLayout, URL keyLayout, String resourceBundleBaseName, ClassLoader bundleClassLoader) {
		load(boardLayout, keyLayout, resourceBundleBaseName, Locale.^default, bundleClassLoader)
	}

	new(URL boardLayout, URL keyLayout, String resourceBundleBaseName, Locale locale, ClassLoader bundleClassLoader) {
		load(boardLayout, keyLayout, resourceBundleBaseName, locale, bundleClassLoader)
	}

	new(URL boardLayout, URL keyLayout, String resourceBundleBaseName, Locale locale, Class<?> bundleClass) {
		load(boardLayout, keyLayout, resourceBundleBaseName, locale, bundleClass.classLoader)
	}

	private def load(URL boardLayout, URL keyLayout, String resourceBundleBaseName, Locale locale, ClassLoader bundleClassLoader) {

		val boardLoader = new FXMLLoader(boardLayout);

		if(resourceBundleBaseName != null) {

			if(bundleClassLoader != null) {
				boardLoader.resources = ResourceBundle.getBundle(resourceBundleBaseName, locale, bundleClassLoader)
			} else {
				boardLoader.resources = ResourceBundle.getBundle(resourceBundleBaseName, locale)
			}
		}

		boardLoader.root = this
		boardLoader.controller = this
		boardLoader.load

		val keyLoader = new FXMLLoader(keyLayout);

		if(resourceBundleBaseName != null) {

			if(bundleClassLoader != null) {
				keyLoader.resources = ResourceBundle.getBundle(resourceBundleBaseName, locale, bundleClassLoader)
			} else {
				keyLoader.resources = ResourceBundle.getBundle(resourceBundleBaseName, locale)
			}
		}

		layout = keyLoader.load

		metaDownProperty >> (this -> PSEUDO_CLASS_META)
		altDownProperty >> (this -> PSEUDO_CLASS_ALT)
		altGraphDownProperty >> (this -> PSEUDO_CLASS_ALTGRAPH)
		ctrlDownProperty >> (this -> PSEUDO_CLASS_CONTROL)
		capsLockProperty >> (this -> PSEUDO_CLASS_CAPS)

		shiftDownProperty >> [this.pseudoClassStateChanged(PSEUDO_CLASS_SHIFT, it && !capsLock)]

		this.focusListener = [
			attach($2)
		]
		this.focusedListener = [
			if($2) {
				this.inputIndicator?.requestFocus
				Platform.runLater[this.inputIndicator?.selectAll]
			}
		]

		this.pickOnBounds = false

		addMouseListener

		this.cacheHint = CacheHint.SPEED
		this.cache = true

		this.initialPositioListener = [
			if (width > 0 && height > 0 && scene != null) {

				if (this.initialPositioListener != null) {
					resetPosition
					this.widthProperty - this.initialPositioListener
					this.heightProperty - this.initialPositioListener
					this.sceneProperty - this.initialPositioListener
					this.initialPositioListener = null
				}
			}
		]
		this.widthProperty > this.initialPositioListener
		this.heightProperty > this.initialPositioListener
		this.sceneProperty > this.initialPositioListener

		this.focusTraversable = false
	}

	private def resetPosition() {
		layoutX = snapPosition(scene.width / 2 - width / 2)
		layoutY = snapPosition(scene.height - height)
	}

	private def addMouseListener() {

		this.addEventHandler(MouseEvent.MOUSE_PRESSED)[lastOffset = new Point2D(sceneX, sceneY); consume]
		this.addEventHandler(MouseEvent.MOUSE_DRAGGED)[drag; consume]
	}

	private def drag(MouseEvent it) {

		val x = sceneX
		val y = sceneY

		if (lastOffset == null) {
			lastOffset = new Point2D(x, y)
		} else {
			val deltaX = x - lastOffset.x
			val deltaY = y - lastOffset.y

			lastOffset = new Point2D(x, y)

			layoutX = layoutX + deltaX
			layoutY = layoutY + deltaY
		}
	}

	override initialize(URL location, ResourceBundle resources) {

		allKeys.forEach [
			osk = this
		]

		if (inputIndicator != null) {
			inputIndicator.show(false)
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

	@CheckFXThread
	def void attach(Window window) {

		window.requireNonNull("Window must not be null!")

		attach(window.scene)
	}

	@CheckFXThread
	def void attach(Scene scene) {

		scene.requireNonNull("Scene must not be null!")

		targetScene?.focusOwnerProperty?.removeListener(focusListener)

		targetScene = scene => [focusOwnerProperty.addListener(focusListener)]
	}

	@CheckFXThread
	def void attach(Node target) {

		targetScene?.focusOwnerProperty?.removeListener(focusListener)
		targetScene = null

		target.requireNonNull("Target node must not be null!")

		targetNode = target
		targetNode.focusedProperty.addListener(this.focusedListener)

		bindInputIndicator

		inputIndicator ?: target => [
			requestFocus
			if(it instanceof TextInputControl) {
				Platform.runLater[
					selectAll
				]
			}
		]
	}

	@CheckFXThread
	def void detach() {

		if (inputIndicator != null) {
			unbindInputIndicator
		}


		targetNode?.focusedProperty?.removeListener(this.focusedListener)
		targetScene?.focusOwnerProperty?.removeListener(focusListener)
		targetScene = null
		targetNode = null
	}

	def isAttached() {
		targetScene != null || targetNode != null
	}

	private def bindInputIndicator() {

		if (inputIndicator != null && inputIndicator != targetNode) {

			unbindInputIndicator

			val targetControl = targetNode

			if (targetControl instanceof TextInputControl) {

				this.targetTextListener = targetControl.textProperty >> [inputIndicator.text = it]
				this.localTextListener = inputIndicator.textProperty >> [targetControl.text = it]
				this.targetCaretListener = targetControl.caretPositionProperty >> [
					inputIndicator.positionCaret = intValue
				]
				this.targetSelectionListener = targetControl.selectionProperty >> [
					inputIndicator.selectRange(start, end)
				]
				this.localCaretListener = inputIndicator.caretPositionProperty >> [
					targetControl.positionCaret = intValue
				]
				this.localSelectionListener = inputIndicator.selectionProperty >>
					[targetControl.selectRange(start, end)]

				if (inputIndicator instanceof TextField) {
					inputIndicator.onAction = [
						if(targetControl instanceof TextField) targetControl.fireEvent(
							new ActionEvent(targetControl, targetControl))
					]
				}

				inputIndicator.show(true)

			} else {
				inputIndicator.textProperty.unbind
				inputIndicator.show(false)
			}
		}
	}

	private def unbindInputIndicator() {

		inputIndicator.textProperty.unbind

		val targetControl = targetNode

		if (targetControl instanceof TextInputControl) {

			if(targetTextListener != null) targetControl.textProperty - targetTextListener
			if(localTextListener != null) inputIndicator.textProperty - localTextListener
			if(targetCaretListener != null) targetControl.caretPositionProperty - targetCaretListener
			if(targetSelectionListener != null) targetControl.selectionProperty - targetSelectionListener
			if(localCaretListener != null) inputIndicator.caretPositionProperty - localCaretListener
			if(localSelectionListener != null) inputIndicator.selectionProperty - localSelectionListener

			if (inputIndicator instanceof TextField) {
				inputIndicator.onAction = null
			}
		}
		inputIndicator.text = null
		inputIndicator.show(false)
	}

	private def void show(TextInputControl control, boolean value) {
		control.visible = value
		control.mouseTransparent = !value
	}

	private static def String getResourceBundleName(URL url) {
		url.toExternalForm.split('/').last.split('\\.').head
	}

	private static def ClassLoader getResourceBundleClassLoadder(URL url) {
		val uri = url.toURI
		val parent = if(uri.path.endsWith('/')) uri.resolve('..') else uri.resolve('.')
		new URLClassLoader(#[parent.toURL])
	}
}
