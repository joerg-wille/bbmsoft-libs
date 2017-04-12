package net.bbmsoft.fx.osk.impl.components.skin

import javafx.scene.Node
import javafx.scene.control.Label
import javafx.scene.control.SkinBase
import javafx.scene.input.InputEvent
import javafx.scene.input.MouseEvent
import javafx.scene.input.TouchEvent
import javafx.scene.layout.GridPane
import javafx.scene.layout.Pane
import net.bbmsoft.fx.osk.OSK
import net.bbmsoft.fx.osk.impl.components.KeyButton
import net.bbmsoft.fxtended.annotations.css.PseudoClasses

import static javafx.scene.layout.Priority.*

import static extension javafx.scene.layout.GridPane.*
import static extension net.bbmsoft.fxtended.extensions.BindingOperatorExtensions.*

@PseudoClasses("active")
class KeyButtonSkin extends SkinBase<KeyButton> {

	new(KeyButton control) {

		super(control)

		val icon = createIcon
		val defaultCharLabel = createDefaultCharLabel(control, icon)
		val shiftCharLabel = createShiftCharLabel(control, icon)
		val altCharLabel = createAltCharLabel(control, icon)

		children.add = createRootPane(control, defaultCharLabel, shiftCharLabel, altCharLabel, icon)

		val extension behavior = new Behavior(control)

		control.addEventHandler(TouchEvent.TOUCH_PRESSED)[onTouchPress; consume]
		control.addEventHandler(TouchEvent.TOUCH_RELEASED)[onTouchRelease; consume]

		control.addEventHandler(MouseEvent.MOUSE_PRESSED)[onMousePress; consume]
		control.addEventHandler(MouseEvent.MOUSE_RELEASED)[onMouseRelease; consume]

		control.addEventHandler(InputEvent.ANY)[consume]
	}

	private def createIcon() {

		new Pane => [
			columnIndex = 0
			rowIndex = 0
			columnSpan = 2
			rowSpan = 2
			managedProperty << visibleProperty
			visible = false
			styleClass.add = "icon"
		]
	}

	private def createDefaultCharLabel(KeyButton key, Node icon) {

		val shiftChar = key.osk.getLayout.keyMap.get(key.code)?.shiftChar

		new Label => [
			columnIndex = 0
			rowIndex = 1
			if(shiftChar === null) {
				columnSpan = 2
				rowSpan = 2
			}
			text = key.osk.getLayout.keyMap.get(key.code)?.displayText ?: key.osk.getLayout.keyMap.get(key.code)?.defaultChar ?: ""
			managedProperty << visibleProperty
			visibleProperty << icon.visibleProperty.not
			pseudoClassStateChanged(PSEUDO_CLASS_ACTIVE, true)
			hgrow = ALWAYS
			vgrow = ALWAYS
			styleClass.add = "default-label"
		]
	}

	private def createShiftCharLabel(KeyButton key, Node icon) {

		val shiftChar = key.osk.getLayout.keyMap.get(key.code)?.shiftChar

		if(shiftChar !== null) {
			new Label => [
				columnIndex = 0
				rowIndex = 0
				text = key.osk.getLayout.keyMap.get(key.code)?.shiftChar ?: ""
				managedProperty << visibleProperty
				visibleProperty << icon.visibleProperty.not
				hgrow = ALWAYS
				vgrow = ALWAYS
				styleClass.add = "shift-label"
			]
		}
	}

	private def createAltCharLabel(KeyButton key, Node icon) {

		val altChar = key.osk.getLayout.keyMap.get(key.code)?.altChar

		if(altChar !== null && !altChar.empty) {
			new Label => [
				columnIndex = 1
				rowIndex = 1
				text = altChar
				managedProperty << visibleProperty
				visibleProperty << icon.visibleProperty.not
				hgrow = ALWAYS
				vgrow = ALWAYS
				styleClass.add = "alt-label"
			]
		}
	}

	private def createRootPane(KeyButton key, Label defaultCharLabel, Label shiftCharLabel, Label altCharLabel, Node icon) {

		key.osk.shiftDownProperty > [updateLabels(key.osk, defaultCharLabel, shiftCharLabel, altCharLabel)]
		key.osk.altGraphDownProperty > [updateLabels(key.osk, defaultCharLabel, shiftCharLabel, altCharLabel)]

		new GridPane() => [

				prefWidthProperty << key.baseSizeProperty.multiply(key.sizeFactorProperty)
				prefHeightProperty << key.baseSizeProperty.multiply(key.heightFactorProperty)

				if(icon !== null) children.add = icon
				if(defaultCharLabel !== null) children.add = defaultCharLabel
				if(shiftCharLabel !== null) children.add = shiftCharLabel
				if(altCharLabel !== null) children.add = altCharLabel

				styleClass.add = 'key-grid'
			]
	}

	private def updateLabels(OSK osk, Label defaultCharLabel, Label shiftCharLabel, Label altCharLabel) {

		defaultCharLabel?.pseudoClassStateChanged(PSEUDO_CLASS_ACTIVE, !osk.shiftDown && !osk.altGraphDown)
		shiftCharLabel?.pseudoClassStateChanged(PSEUDO_CLASS_ACTIVE, osk.shiftDown && !osk.altGraphDown)
		altCharLabel?.pseudoClassStateChanged(PSEUDO_CLASS_ACTIVE, !osk.shiftDown && osk.altGraphDown)
	}

}
