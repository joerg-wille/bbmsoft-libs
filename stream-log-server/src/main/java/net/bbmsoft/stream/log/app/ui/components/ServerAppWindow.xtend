package net.bbmsoft.stream.log.app.ui.components

import java.net.URL
import java.util.Map
import java.util.ResourceBundle
import javafx.fxml.FXML
import javafx.fxml.FXMLLoader
import javafx.fxml.Initializable
import javafx.scene.control.TabPane
import javafx.scene.layout.VBox
import org.eclipse.xtend.lib.annotations.Accessors

class ServerAppWindow extends VBox implements Initializable {

	@Accessors Runnable onTabChange

	@FXML TabPane tabPane

	final Map<Server, ServerTab> tabs

	new() {

		this.tabs = newHashMap

		new FXMLLoader => [
			location = ServerAppWindow.getResource('/layout/ServerAppWindow.fxml')
			root = this
			controller = this
			load
		]
	}

	override initialize(URL location, ResourceBundle resources) {
		tabPane.selectionModel.selectedItemProperty.addListener[onTabChange?.run]
	}

	def ServerTab newTab() {
		new ServerTab() => [
			tabPane.tabs.add = it
			tabPane.selectionModel.select(it)
		]
	}

	def closeActiveTab() {
		val activeTab = tabPane.selectionModel.selectedItem
		if (activeTab != null) {
			tabPane.tabs.remove(activeTab)
		}
		activeTab
	}

	def getActiveTab() {
		tabPane.selectionModel.selectedItem as ServerTab
	}

}