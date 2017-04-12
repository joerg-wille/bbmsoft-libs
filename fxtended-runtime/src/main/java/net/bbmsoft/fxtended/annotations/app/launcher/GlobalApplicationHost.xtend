package net.bbmsoft.fxtended.annotations.app.launcher

import java.util.HashMap
import java.util.List
import java.util.Map
import java.util.concurrent.CountDownLatch
import java.util.concurrent.atomic.AtomicBoolean
import javafx.application.Application
import javafx.application.Platform
import javafx.scene.control.Dialog
import javafx.stage.Stage
import javafx.stage.Window
import javafx.stage.WindowEvent

class GlobalApplicationHost extends Application {

	private static final AtomicBoolean created = new AtomicBoolean

	private static final CountDownLatch launchLatch = new CountDownLatch(1)

	private static GlobalApplicationHost instance

	final Map<Subapplication, List<Window>> windows = new HashMap
	final Map<Subapplication, List<Dialog<?>>> dialogs = new HashMap

	private boolean quitOnLastWindowClosed = true

	override start(Stage primaryStage) throws Exception {

		synchronized (GlobalApplicationHost) {
			GlobalApplicationHost.instance = this
		}

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

	def static Subapplication launchSubapplication(Class<? extends Subapplication> subapplicationClass) {
		subapplicationClass.newInstance => [launchSubapplication]
	}

	def static void launchSubapplication(Subapplication subapplication) {

		GlobalApplicationHost.create

		synchronized (GlobalApplicationHost) {

			if (GlobalApplicationHost.instance === null) {
				throw new IllegalStateException(
					'Global Application Host not running! Call GlobalApplicationHost.create(...) before starting subapplications.')
			}

		}

		Platform.runLater[instance._implLaunchSubapplication(subapplication)]

	}

	protected def static void quitSubapplication(Subapplication subapplication) {

		synchronized (GlobalApplicationHost) {

			if (GlobalApplicationHost.instance === null) {
				throw new IllegalStateException(
					'Global Application Host not running! Call GlobalApplicationHost.create(...) before starting subapplications.')
			}
		}

		val latch = new CountDownLatch(1)

		Platform.runLater [
			try {
				instance._implQuitSubapplication(subapplication)
			} finally {
				latch.countDown
			}
		]

		latch.await
	}

	protected def static void registerWindow(Subapplication subapplication, Window window) {

		synchronized (GlobalApplicationHost) {

			if (GlobalApplicationHost.instance === null) {
				throw new IllegalStateException(
					'Global Application Host not running! Call GlobalApplicationHost.create(...) before starting subapplications.')
			}
		}

		Platform.runLater[instance._implRegisterWindow(subapplication, window)]

	}

	protected def static void registerDialog(Subapplication subapplication, Dialog<?> dialog) {

		synchronized (GlobalApplicationHost) {

			if (GlobalApplicationHost.instance === null) {
				throw new IllegalStateException(
					'Global Application Host not running! Call GlobalApplicationHost.create(...) before starting subapplications.')
			}
		}

		Platform.runLater[instance._implRegisterDialog(subapplication, dialog)]

	}

	private def _implLaunchSubapplication(Subapplication subapplication) {

		if (this.windows.containsKey(subapplication)) {
			throw new IllegalStateException('''Subapplication «subapplication» has already been launched!''')
		}

		val window = new Stage
		val windows = newArrayList
		val dialogs = newArrayList

		this.windows.put(subapplication, windows)
		this.dialogs.put(subapplication, dialogs)

		registerWindow(subapplication, window)

		try {
			subapplication.start(window)
		} catch (Exception e) {
			System.err.println("Error starting sub application!")
			e.printStackTrace
			this.windows.remove(subapplication)
			this.dialogs.remove(subapplication)
		}
	}

	private def void windowClosed(Subapplication subapplication, Window window) {

		_implUnregisterWindow(subapplication, window)

		val notQuit = this.windows.get(subapplication) !== null
		val allWindows = this.windows.get(subapplication)
		val allWindowsClosed = allWindows.empty

		if (notQuit && allWindowsClosed && this.quitOnLastWindowClosed) {
			_implQuitSubapplication(subapplication)
		}
	}

	private def void dialogClosed(Subapplication subapplication, Dialog<?> dialog) {

		_implUnregisterDialog(subapplication, dialog)

		val notQuit = this.windows.get(subapplication) !== null
		val allWindows = this.windows.get(subapplication)
		val allDialogs = this.dialogs.get(subapplication)
		val allWindowsClosed = allWindows.empty
		val allDialogsClosed = allDialogs.empty

		if (notQuit && allWindowsClosed && allDialogsClosed && this.quitOnLastWindowClosed) {
			_implQuitSubapplication(subapplication)
		}
	}

	private def _implQuitSubapplication(Subapplication subapplication) {

		if (!this.windows.containsKey(subapplication)) {
			throw new IllegalStateException('''Subapplication «subapplication» has not been launched!''')
		}

		this.dialogs.remove(subapplication).forEach[close]
		this.windows.remove(subapplication).forEach[hide]

		subapplication.stop
	}

	private def _implRegisterWindow(Subapplication subapplication, Window window) {

		if (!this.windows.containsKey(subapplication)) {
			throw new IllegalStateException('''Subapplication «subapplication» has not been launched!''')
		}

		window.addEventHandler(WindowEvent.WINDOW_CLOSE_REQUEST)[subapplication.windowClosed(window)]
		this.windows.get(subapplication).add = window
	}

	private def _implUnregisterWindow(Subapplication subapplication, Window window) {

		if (!this.windows.containsKey(subapplication)) {
			throw new IllegalStateException('''Subapplication «subapplication» has not been launched!''')
		}

		this.windows.get(subapplication).remove = window
	}

	private def _implRegisterDialog(Subapplication subapplication, Dialog<?> dialog) {

		if (!this.dialogs.containsKey(subapplication)) {
			return false
		}

		dialog.onCloseRequest = [subapplication.dialogClosed(dialog)]
		this.dialogs.get(subapplication).add = dialog
	}

	private def _implUnregisterDialog(Subapplication subapplication, Dialog<?> dialog) {

		if (!this.dialogs.containsKey(subapplication)) {
			return false
		}

		this.dialogs.get(subapplication).remove = dialog
	}

}
