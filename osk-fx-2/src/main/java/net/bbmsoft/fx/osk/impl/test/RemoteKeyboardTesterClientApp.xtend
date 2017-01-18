package net.bbmsoft.fx.osk.impl.test

import javafx.application.Application
import javafx.scene.Scene
import javafx.stage.Stage

class RemoteKeyboardTesterClientApp extends Application {

	override start(Stage it) throws Exception {

		scene = new Scene(new RemoteKeyboardTesterClient)
		show
	}

	def static void main(String[] args) {
		launch(args)
	}
}
