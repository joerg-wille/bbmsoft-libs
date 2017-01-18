package net.bbmsoft.stream.log.app.ui.components

import java.net.URL
import java.util.ResourceBundle
import javafx.fxml.FXML
import javafx.fxml.FXMLLoader
import javafx.fxml.Initializable
import javafx.scene.control.MenuBar
import javafx.scene.control.MenuItem
import org.eclipse.xtend.lib.annotations.Accessors

class LogServerMenuBar extends MenuBar implements Initializable {

	@FXML MenuItem newServer
	@FXML MenuItem save
	@FXML MenuItem saveAs
	@FXML MenuItem disconnect
	@FXML MenuItem close
	@FXML MenuItem exit

	@FXML MenuItem clear

	@FXML MenuItem about

	@Accessors Runnable newServerHook
	@Accessors Runnable saveHook
	@Accessors Runnable saveAsHook
	@Accessors Runnable disconnectHook
	@Accessors Runnable closeHook
	@Accessors Runnable exitHook
	@Accessors Runnable clearHook
	@Accessors Runnable aboutHook

	boolean tabOpen
	boolean clientConnected
	boolean logEmpty

	new() {

		tabOpen = false
		clientConnected = false
		logEmpty = true

		new FXMLLoader => [
			location = ServerAppWindow.getResource('/layout/LogServerMenuBar.fxml')
			root = this
			controller = this
			load
		]
	}

	override initialize(URL location, ResourceBundle resources) {

		newServer.onAction = [newServerHook?.run]
		save.onAction = [saveHook?.run]
		saveAs.onAction = [saveAsHook?.run]
		disconnect.onAction = [disconnectHook?.run]
		close.onAction = [closeHook?.run]
		exit.onAction = [exitHook?.run]
		clear.onAction = [clearHook?.run]
		about.onAction = [aboutHook?.run]

		updateMenu
	}

	def setTabOpen(boolean open) {
		this.tabOpen = open
		updateMenu
	}

	def setActiveClientConnected(boolean connected) {
		this.clientConnected = connected
		updateMenu
	}

	def setLogEmpty(boolean empty) {
		this.logEmpty = empty
		updateMenu
	}

	private def updateMenu() {
		save.disable = !tabOpen || logEmpty
		saveAs.disable = !tabOpen || logEmpty
		disconnect.disable = !tabOpen || !clientConnected
		close.disable = !tabOpen
		clear.disable = !tabOpen || logEmpty
	}

}