package net.bbmsoft.stream.log.app.ui.components

import java.net.URL
import java.util.ResourceBundle
import java.util.function.Consumer
import javafx.application.Platform
import javafx.beans.property.BooleanProperty
import javafx.beans.property.SimpleBooleanProperty
import javafx.fxml.FXML
import javafx.fxml.FXMLLoader
import javafx.fxml.Initializable
import javafx.scene.control.Button
import javafx.scene.control.Tab
import javafx.scene.control.TextArea
import org.eclipse.xtend.lib.annotations.Accessors

class ServerTab extends Tab implements Initializable {

	@FXML TextArea textArea
	@FXML Button disconnectButton
	@FXML Button saveButton
	@FXML Button clearButton

	@Accessors Runnable saveAsHook
	@Accessors Runnable disconnectHook
	@Accessors Consumer<Boolean> onLogEmpty

	@Accessors String clientName

	final BooleanProperty connectedProperty

	new() {

		this.connectedProperty = new SimpleBooleanProperty(true)

		new FXMLLoader => [
			location = ServerTab.getResource('/layout/ServerTab.fxml')
			root = this
			controller = this
			load
		]
	}

	override initialize(URL location, ResourceBundle resources) {

		disconnectButton.onAction = [disconnectHook?.run]
		saveButton.onAction = [saveAsHook?.run]
		clearButton.onAction = [clear]

		saveButton.disableProperty.bind(textArea.textProperty.empty)
		clearButton.disableProperty.bind(textArea.textProperty.empty)

		textArea.textProperty.addListener[o, oldVal, newVal | onLogEmpty?.accept(newVal.empty)]

		disconnectButton.disableProperty.bind(connectedProperty.not)
	}

	def appendLine(String line) {
		Platform.runLater[textArea.appendText(line + '\n')]
	}

	def clear() {
		Platform.runLater[textArea.text = '']
	}

	def String getLog() {
		textArea.text
	}

	def isConnected() {
		connectedProperty.get
	}

	def setConnected(boolean value) {
		connectedProperty.set = value
	}
}