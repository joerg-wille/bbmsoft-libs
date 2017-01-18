package net.bbmsoft.stream.log.app.ui.components

import java.io.BufferedReader
import java.io.PrintWriter
import java.io.StringWriter
import java.util.Map
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors
import java.util.concurrent.Future
import javafx.application.Platform
import javafx.scene.control.Alert
import javafx.scene.control.Alert.AlertType
import javafx.scene.control.Tab
import javafx.scene.control.TextArea
import javafx.scene.control.TextInputDialog
import javafx.stage.Stage
import net.bbmsoft.stream.log.StreamLogServer

import static extension java.lang.Integer.*

class CommandCenter {

	final ExecutorService exec

	final LoadSaveHandler loadSaveHandler

	final ServerAppWindow appWindow
	final LogServerMenuBar menuBar

	final Map<Tab, BufferedReader> readers

	StreamLogServer pss
	final Object lock

	new(ServerAppWindow appWindow, LogServerMenuBar menuBar, LoadSaveHandler loadSaveHandler) {

		this.appWindow = appWindow
		this.menuBar = menuBar
		this.exec = Executors.newCachedThreadPool[new Thread(it) => [daemon = true]]
		this.loadSaveHandler = loadSaveHandler
		this.readers = newHashMap
		this.lock = new Object

		addMenuHooks
	}

	def void startServer(StreamLogServer pss) {

		synchronized(lock) {
			this.pss?.stop
			this.pss = pss
			pss.subScribe[addClient($0, $1)]
			pss.start
		}
	}

	private def addClient(String name, BufferedReader reader) {

		Platform.runLater[doAddClient(reader, name)]
	}

	private def doAddClient(BufferedReader reader, String name) {


		val tab = appWindow.newTab => [
			clientName = name
			text = name
			disconnectHook = [reader.close]
			saveAsHook = [loadSaveHandler.saveAs(clientName, log, appWindow.scene.window)]
			readers.put(it, reader)
			onLogEmpty = [value |
				if(it == appWindow.activeTab) {
					menuBar.logEmpty = value
				}
			]
		]

		val Future<?> future = exec.submit [
			try {
				while (true) {
					tab.appendLine(reader.readLine)
				}
			} finally {
				disconnect(tab, name, reader)
			}
		]

		tab.onCloseRequest = [
			exec.execute[
				future.cancel(true)
				reader.close
				disconnect(tab, name, reader)
			]
		]

		menuBar.tabOpen = true
		menuBar.activeClientConnected = true
	}

	private def disconnect(ServerTab tab, String name, BufferedReader reader) {
		tab.appendLine('Connection closed.')
		tab.connected = false
		Platform.runLater[tab.text = '''«name» (Disconnected)''']
		reader.close
		updateMenu
	}

	private def addMenuHooks() {

		menuBar.newServerHook = [newServer]

		menuBar.saveHook = [
			val activeTab = appWindow.activeTab
			if(activeTab != null) {
				loadSaveHandler.save(activeTab.clientName, activeTab.log, menuBar.scene.window)
			}
		]

		menuBar.saveAsHook = [val activeTab = appWindow.activeTab
			if(activeTab != null) {
				loadSaveHandler.saveAs(activeTab.clientName, activeTab.log, menuBar.scene.window)
			}
		]

		menuBar.disconnectHook = [
			activeReader.close
			menuBar.activeClientConnected = false
		]

		menuBar.clearHook = [appWindow.activeTab.clear]

		menuBar.closeHook = [
			val tab = appWindow.closeActiveTab
			readers.remove(tab).close
			menuBar.tabOpen = !readers.keySet.empty
			Platform.runLater[
				val activeTab = appWindow.activeTab
				menuBar.activeClientConnected = if(activeTab != null) activeTab.connected else false
			]
		]

		menuBar.exitHook = [
			synchronized(lock) {
				readers.forEach[$1.close]
				pss.stop
				appWindow.scene.window.hide
				Platform.exit
			}
		]

		menuBar.aboutHook = [showAboutDialog]

		appWindow.onTabChange = [updateMenu]
	}

	private def void newServer() {

		new TextInputDialog("1337") => [
			title = "New Server"
			headerText = null
			contentText = "Start new server at port:"
			showAndWait.ifPresent[doStartServer]
		]
	}

	private def doStartServer(String input) {

		try {
			val port = input.parseInt
			startServer(new StreamLogServer(port))
			val window = appWindow?.scene?.window
			if(window instanceof Stage) {
				window.title = '''Log Server (Port «port»)'''
			}
		} catch (NumberFormatException e) {
			new Alert(AlertType.ERROR) => [
				title = "Error"
				headerText = null
				contentText = '''Invalid port number: '«input»' '''
			]
		} catch (Throwable e) {

			val pw = new PrintWriter(new StringWriter()) => [e.printStackTrace(it)]
			val stacktrace = pw.toString
			pw.close

			new Alert(AlertType.ERROR) => [
				title = "Error"
				headerText = null
				contentText = '''Could not start server: «e.message»'''
				dialogPane.expandableContent = new TextArea => [
					editable = false
					text = stacktrace
				]
			]
		}

	}

	private def updateMenu() {
		val tab = appWindow.activeTab
		menuBar.tabOpen = tab != null
		menuBar.activeClientConnected = if(tab != null) tab.connected else false
		menuBar.logEmpty = tab == null || tab.log == null || tab.log.empty
	}

	private def BufferedReader getActiveReader() {
		readers.get(appWindow.activeTab)
	}

	private def showAboutDialog() {

		new Alert(AlertType.INFORMATION) => [
			title = "About"
			headerText = null
			contentText = "PrintStream Server UI v. 1.0.1, © 2015 Michael Bachmann"
			showAndWait
		]
	}
}