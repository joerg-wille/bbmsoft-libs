package net.bbmsoft.stream.log.app

import javafx.application.Application
import javafx.application.Platform
import javafx.scene.Scene
import javafx.scene.image.Image
import javafx.scene.layout.Priority
import javafx.scene.layout.VBox
import javafx.stage.Stage
import net.bbmsoft.stream.log.StreamLogServer
import net.bbmsoft.stream.log.app.ui.components.CommandCenter
import net.bbmsoft.stream.log.app.ui.components.LoadSaveHandler
import net.bbmsoft.stream.log.app.ui.components.LogServerMenuBar
import net.bbmsoft.stream.log.app.ui.components.ServerAppWindow

import static extension java.lang.Integer.*

class StreamLogServerUI extends Application {

	final extension Class<StreamLogServerUI> = StreamLogServerUI

	def static void main(String[] args) {
		launch(args)
	}

	override start(Stage it) throws Exception {

		val portArg = parameters.named.get('port')

		if(portArg == null) {
			System.err.println("No port specified. User argument '--port=[port number]'")
			Platform.exit
			return
		}

		val printStreamServer = try {
			val portnumber = portArg.parseInt
			new StreamLogServer(portnumber)
		} catch (Throwable e) {
			System.err.println('''Could not open port '«portArg»': «e.message»''')
			Platform.exit
			null
		}

		if (printStreamServer != null) {

			val window = new ServerAppWindow => [VBox.setVgrow(it, Priority.ALWAYS)]
			val menuBar = new LogServerMenuBar

			new CommandCenter(window, menuBar, new LoadSaveHandler) => [startServer(printStreamServer)]

			scene = new Scene(
				new VBox(menuBar, window)
			)
			width = 800
			height = 600
			title = '''Log Server (Port «portArg»)'''
			icons.add(new Image("/img/terminal.png".resource.toExternalForm))
			show
		}
	}

}