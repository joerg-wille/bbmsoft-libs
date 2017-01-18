package net.bbmsoft.fx.osk.impl.test

import javafx.application.Application
import javafx.scene.Scene
import javafx.scene.control.Button
import javafx.stage.Stage
import javafx.scene.input.KeyEvent

class KeyTester extends Application {

	def static void main(String[] args) {
		launch(args)
	}

	override start(Stage it) throws Exception {
		scene = new Scene(new Button => [
			onKeyPressed = [action]
			requestFocus
		])
		show
	}

	def action(KeyEvent e) {
		println(e.code)
	}

}