package net.bbmsoft.fx.osk.impl.test

import javafx.application.Application
import javafx.scene.Scene
import javafx.scene.control.TextField
import javafx.scene.layout.VBox
import javafx.stage.Stage
import net.bbmsoft.fx.osk.OSK

class StandaloneOSK extends Application {

	def static void main(String[] args) {
		launch(args)
	}

	override start(Stage it) throws Exception {


		val osk = new OSK(StandaloneOSK.getResource('/layout/board/OSK_full.fxml'), StandaloneOSK.getResource('/layout/keys/en_US_win.fxml'))

		scene = new Scene(new VBox => [
			children.add = new TextField
			children.add = new TextField
			children.add = new TextField
			children.add = osk
			stylesheets.add = '/style/osk_default.css'
		])

		show

		osk.attach(scene)
	}

}
