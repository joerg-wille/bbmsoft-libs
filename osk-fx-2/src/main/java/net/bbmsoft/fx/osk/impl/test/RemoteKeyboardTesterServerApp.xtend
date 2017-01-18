package net.bbmsoft.fx.osk.impl.test

import javafx.application.Application
import javafx.scene.Scene
import javafx.stage.Stage

class RemoteKeyboardTesterServerApp extends Application {

	override start(Stage it) throws Exception {

		scene = new Scene(new RemoteKeyboardTesterServer)
		show
	}

	def static void main(String[] args) {
		launch(args)
	}
}
