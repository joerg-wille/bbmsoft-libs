package net.bbmsoft.fxtended.annotations.app.launcher

import java.util.HashMap
import java.util.List
import java.util.Map
import java.util.concurrent.CountDownLatch
import java.util.concurrent.atomic.AtomicBoolean
import javafx.application.Application
import javafx.application.Platform
import javafx.stage.Stage
import javafx.stage.Window

class GlobalApplicationHost extends Application {

	private static final AtomicBoolean created = new AtomicBoolean

	private static final CountDownLatch launchLatch = new CountDownLatch(1)

	private static GlobalApplicationHost instance

	final Map<Subapplication, List<Window>> subapplications = new HashMap

	override start(Stage primaryStage) throws Exception {

		synchronized (GlobalApplicationHost) {
			GlobalApplicationHost.instance = this
		}

		System.err.println('Global Application Host started.')

		GlobalApplicationHost.launchLatch.countDown
	}

	def static void create(String ... args) {

		val created = GlobalApplicationHost.created.getAndSet(true)

		if (!created) {

			new Thread[Application.launch(args)] => [
				name = 'Global Application Host Thread'
				start
			]
		}

		GlobalApplicationHost.launchLatch.await
	}

	def static void launchSubapplication(Subapplication subapplication) {

		GlobalApplicationHost.create

		synchronized (GlobalApplicationHost) {

			if (GlobalApplicationHost.instance == null) {
				throw new IllegalStateException(
					'Global Application Host not running! Call GlobalApplicationHost.create(...) before starting subapplications.')
			}

		}

		Platform.runLater[instance._implLaunchSubapplication(subapplication)]

	}

	protected def static void quitSubapplication(Subapplication subapplication) {

		synchronized (GlobalApplicationHost) {

			if (GlobalApplicationHost.instance == null) {
				throw new IllegalStateException(
					'Global Application Host not running! Call GlobalApplicationHost.create(...) before starting subapplications.')
			}
		}

		Platform.runLater[instance._implQuitSubapplication(subapplication)]

	}

	protected def static void registerWindow(Subapplication subapplication, Window window) {

		synchronized (GlobalApplicationHost) {

			if (GlobalApplicationHost.instance == null) {
				throw new IllegalStateException(
					'Global Application Host not running! Call GlobalApplicationHost.create(...) before starting subapplications.')
			}
		}

		Platform.runLater[instance._implRegisterWindow(subapplication, window)]

	}

	private def _implLaunchSubapplication(Subapplication subapplication) {

		if (this.subapplications.containsKey(subapplication)) {
			throw new IllegalStateException('''Subapplication «subapplication» has already been launched!''')
		}

		val window = new Stage
		val windows = <Window>newArrayList(window)

		this.subapplications.put(subapplication, windows)

		subapplication.start(window)
	}

	private def _implQuitSubapplication(Subapplication subapplication) {

		if (!this.subapplications.containsKey(subapplication)) {
			throw new IllegalStateException('''Subapplication «subapplication» has not been launched!''')
		}

		this.subapplications.remove(subapplication).forEach[hide]

		subapplication.stop
	}

	private def _implRegisterWindow(Subapplication subapplication, Window window) {

		if (!this.subapplications.containsKey(subapplication)) {
			throw new IllegalStateException('''Subapplication «subapplication» has not been launched!''')
		}

		this.subapplications.get(subapplication).add = window
	}

}
