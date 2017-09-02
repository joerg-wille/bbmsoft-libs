package net.bbmsoft.fxtended.annotations.app.launcher

import javafx.stage.Stage
import javafx.stage.Window
import javafx.scene.control.Dialog

abstract class Subapplication {

	def abstract void start(Stage primaryStage) throws Exception

	def void stop() {
	}

	def final registerWindow(Window window) {
		GlobalApplicationHost.registerWindow(this, window)
	}

	def final registerDialog(Dialog<?> dialog) {
		GlobalApplicationHost.registerDialog(this, dialog)
	}

	def final quit() {
		GlobalApplicationHost.quitSubapplication(this)
	}

	def static void launch(Subapplication subApplication) {
		GlobalApplicationHost.launchSubapplication(subApplication)
	}

	def static Subapplication launch(Class<? extends Subapplication> clazz) {
		GlobalApplicationHost.launchSubapplication(clazz)
	}

	def static Subapplication launch() {

		val trace = Thread.currentThread.stackTrace
		val callingClassName = trace.get(2).className
		val clazz = Thread.currentThread.contextClassLoader.loadClass(callingClassName)

		if(Subapplication.isAssignableFrom(clazz)) {
			GlobalApplicationHost.launchSubapplication(clazz as Class<? extends Subapplication>)
		} else {
			throw new IllegalStateException('''«clazz» does not extends «Subapplication»!''')
		}
	}
}
