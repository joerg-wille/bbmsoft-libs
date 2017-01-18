package net.bbmsoft.fx.osk.impl.components.skin

import javafx.scene.Node
import javafx.scene.control.Label
import javafx.scene.control.SkinBase
import javafx.scene.input.InputEvent
import javafx.scene.input.MouseEvent
import javafx.scene.input.TouchEvent
import javafx.scene.layout.GridPane
import javafx.scene.layout.Pane
import net.bbmsoft.fx.osk.impl.components.KeyButton

import static javafx.scene.layout.Priority.*

import static extension javafx.scene.layout.GridPane.*
import static extension net.bbmsoft.fxtended.extensions.BindingOperatorExtensions.*
import net.bbmsoft.keyboard.KeyMap

class KeyButtonSkin extends SkinBase<KeyButton> {

	new(KeyButton control) {

		super(control)

		val extension behavior = new Behavior(control)

		control.addEventHandler(TouchEvent.TOUCH_PRESSED)[onTouchPress; consume]
		control.addEventHandler(TouchEvent.TOUCH_RELEASED)[onTouchRelease; consume]

		control.addEventHandler(MouseEvent.MOUSE_PRESSED)[onMousePress; consume]
		control.addEventHandler(MouseEvent.MOUSE_RELEASED)[onMouseRelease; consume]

		control.addEventHandler(MouseEvent.MOUSE_ENTERED)[onEntered; consume]
		control.addEventHandler(MouseEvent.MOUSE_EXITED)[onExited; consume]

		control.addEventHandler(InputEvent.ANY)[consume]

		control.keyMapProperty >> [keyMapChanged]
	}

	private def keyMapChanged(KeyMap map) {

		this.children.clear

		if(map == null) {
			return
		}

		val icon = createIcon
		val defaultCharLabel = createDefaultCharLabel(skinnable, icon)
		val shiftCharLabel = createShiftCharLabel(skinnable, icon)
		val altCharLabel = createAltCharLabel(skinnable, icon)

		children.all = createRootPane(skinnable, defaultCharLabel, shiftCharLabel, altCharLabel, icon)
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

		val shiftChar = key.osk.keyMap.getSecondaryChar(key.code)

		new Label => [
			columnIndex = 0
			rowIndex = 1
			if(shiftChar == null) {
				columnSpan = 2
				rowSpan = 2
			}
			text = key.osk.keyMap.getDisplayText(key.code) ?: key.osk.keyMap.getPrimaryChar(key.code) ?: ""
			managedProperty << visibleProperty
			visibleProperty << icon.visibleProperty.not
			hgrow = ALWAYS
			vgrow = ALWAYS
			styleClass.add = "default-label"
		]
	}

	private def createShiftCharLabel(KeyButton key, Node icon) {

		val shiftChar = key.osk.keyMap.getSecondaryChar(key.code)

		if(shiftChar != null) {
			new Label => [
				columnIndex = 0
				rowIndex = 0
				text = shiftChar
				managedProperty << visibleProperty
				visibleProperty << icon.visibleProperty.not
				hgrow = ALWAYS
				vgrow = ALWAYS
				styleClass.add = "shift-label"
			]
		}
	}

	private def createAltCharLabel(KeyButton key, Node icon) {

		val altChar = key.osk.keyMap.getTertiaryChar(key.code)

		if(altChar != null && !altChar.empty) {
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

		new GridPane() => [

				prefWidthProperty << key.baseSizeProperty.multiply(key.sizeFactorProperty)
				prefHeightProperty << key.baseSizeProperty.multiply(key.heightFactorProperty)

				if(icon != null) children.add = icon
				if(defaultCharLabel != null) children.add = defaultCharLabel
				if(shiftCharLabel != null) children.add = shiftCharLabel
				if(altCharLabel != null) children.add = altCharLabel

				styleClass.add = 'key-grid'
			]
	}


}
