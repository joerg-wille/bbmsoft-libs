package net.bbmsoft.fxtended.annotations.app.launcher

import javafx.stage.Window
import javafx.stage.Stage

abstract class Subapplication {

	def abstract void start(Stage primaryStage);

	def void stop() {
	}

	def final registerWindow(Window window) {
		GlobalApplicationHost.registerWindow(this, window)
	}

	def final quit() {
		GlobalApplicationHost.quitSubapplication(this)
	}
}
