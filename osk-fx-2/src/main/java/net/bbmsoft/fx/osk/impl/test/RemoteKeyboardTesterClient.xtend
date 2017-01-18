package net.bbmsoft.fx.osk.impl.test

import java.net.URL
import javafx.scene.control.Alert
import javafx.scene.control.Alert.AlertType
import javafx.scene.control.TextField
import javafx.scene.layout.BorderPane
import javafx.scene.layout.VBox
import net.bbmsoft.fx.osk.RemoteOskHandlerBootstrapper

class RemoteKeyboardTesterClient extends BorderPane {

	final TextField textField

	new() {

		this.textField = new TextField => [prefColumnCount = 32]
		top = textField
		bottom = new VBox(new LayoutSelector('last-key-layout-dir')[keyLayoutChanged])

	}

	private def keyLayoutChanged(URL url) {
		initBoard(url)
	}

	private def initBoard(URL keyLayout) {

		if (keyLayout != null) {

			try {

				val bootstrapH = new RemoteOskHandlerBootstrapper().createOskHandler(keyLayout, true)

				bootstrapH.value.attach(this.textField)

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
