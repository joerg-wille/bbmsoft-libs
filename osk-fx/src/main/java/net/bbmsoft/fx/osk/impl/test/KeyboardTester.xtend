package net.bbmsoft.fx.osk.impl.test

import java.net.URL
import javafx.scene.control.Label
import javafx.scene.control.TextField
import javafx.scene.layout.BorderPane
import javafx.scene.layout.HBox
import javafx.scene.layout.StackPane
import javafx.geometry.Insets
import net.bbmsoft.fx.osk.OSK
import javafx.scene.control.Alert.AlertType
import javafx.scene.control.Alert

class KeyboardTester extends BorderPane {

	final StackPane keyboardHolder
	final TextField textField

	URL boardLayout
	URL keyLayout

	new() {

		this.keyboardHolder = new StackPane => [setPrefSize(1024, 500)]
		this.textField = new TextField

		bottom = new HBox(
			new Label("Board Layout:") => [maxHeight = Double.MAX_VALUE],
			new LayoutSelector('last-board-layout-dir')[boardLayoutChanged],
			new Label("Key Layout:") => [maxHeight = Double.MAX_VALUE],
			new LayoutSelector('last-key-layout-dir')[keyLayoutChanged],
			new Label("Theme:") => [maxHeight = Double.MAX_VALUE],
			new ThemeSelector('last-theme-dir')
		) => [
			spacing = 8
			padding = new Insets(8)
		]

		center = keyboardHolder

		top = textField
	}

	private def boardLayoutChanged(URL url) {
		this.boardLayout = url
		initBoard
	}

	private def keyLayoutChanged(URL url) {
		this.keyLayout = url
		initBoard
	}

	private def initBoard() {
		if (boardLayout !== null && keyLayout !== null) {
			try {
				this.keyboardHolder.children.all = new OSK(boardLayout, keyLayout, true) => [
					attach(textField)
				]
			} catch (Throwable e) {
				System.err.println('''«e.class.simpleName»: «e.message»''')
				new Alert(AlertType.ERROR) => [
					title = "Error"
					headerText = "Could not load OSK layout:"
					contentText = e.message
					showAndWait
				]
			}
		}
	}

}
