package net.bbmsoft.fx.osk.impl.test

import java.net.URL
import javafx.geometry.Insets
import javafx.scene.control.Alert
import javafx.scene.control.Alert.AlertType
import javafx.scene.control.Label
import javafx.scene.layout.BorderPane
import javafx.scene.layout.HBox
import javafx.scene.layout.StackPane
import net.bbmsoft.fx.osk.RemoteOskControllerBootstrapper

class RemoteKeyboardTesterServer extends BorderPane {

	final StackPane keyboardHolder

	URL boardLayout

	new() {

		this.keyboardHolder = new StackPane => [setPrefSize(1024, 500)]

		bottom = new HBox(
			new Label("Board Layout:") => [maxHeight = Double.MAX_VALUE],
			new LayoutSelector('last-board-layout-dir')[boardLayoutChanged],
			new Label("Key Layout:") => [maxHeight = Double.MAX_VALUE],
			new Label("Theme:") => [maxHeight = Double.MAX_VALUE],
			new ThemeSelector('last-theme-dir')
		) => [
			spacing = 8
			padding = new Insets(8)
		]

		center = keyboardHolder

	}

	private def boardLayoutChanged(URL url) {
		this.boardLayout = url
		initBoard
	}

	def initBoard() {

		if (boardLayout != null) {

			try {

				val bootstrapC = new RemoteOskControllerBootstrapper().createController(boardLayout)

				this.keyboardHolder.children.all = bootstrapC.key

			} catch (Throwable e) {
				System.err.println('''«e.class.simpleName»: «e.message»''')
				e.printStackTrace
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
