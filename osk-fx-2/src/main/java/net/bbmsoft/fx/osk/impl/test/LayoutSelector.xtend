package net.bbmsoft.fx.osk.impl.test

import java.io.File
import java.net.URL
import java.util.Locale
import java.util.function.Consumer
import java.util.prefs.Preferences
import javafx.scene.control.ChoiceBox
import javafx.stage.DirectoryChooser
import javafx.stage.Window
import org.eclipse.xtend.lib.annotations.Accessors
import net.bbmsoft.fx.osk.impl.test.LayoutSelector.Layout

import static extension net.bbmsoft.fxtended.extensions.BindingOperatorExtensions.*

class LayoutSelector extends ChoiceBox<Layout> {

	final static Preferences PREFS = Preferences.userNodeForPackage(LayoutSelector)
	final static Layout CHOOSE = new Layout

	static class Layout {

		public static final String SUFFIX = '.fxml'

		@Accessors final String name
		@Accessors final File file

		new(File file) {

			this.name = file.name.substring(0, file.name.length - SUFFIX.length)
			this.file = file
		}

		private new() {
			this.name = "Choose..."
			this.file = null
		}

		override toString() {
			name
		}
	}

	final DirectoryChooser dirChooser

	final Consumer<URL> consumer
	final String dirSettingsKey

	new(String dirSettingsKey, Consumer<URL> consumer) {

		this.consumer = consumer
		this.dirSettingsKey = dirSettingsKey

		this.dirChooser = new DirectoryChooser => [
			title = 'Select Themes directory...'

		]

		selectionModel.selectedItemProperty >> [
			if(file == null) {
				selectLayoutDir(scene.window)
			} else {
				consumer.accept(file.toURI.toURL)
			}
		]

		val dir = PREFS.get(dirSettingsKey, '')
		if(!dir.isEmpty) {
			setLayoutRootDir(new File(dir))
		} else {
			items.all = #[CHOOSE]
		}
	}

	def setLayoutRootDir(File file) {

		PREFS.put(dirSettingsKey, file.absolutePath)

		file.listFiles[name.toLowerCase(Locale.US).endsWith(Layout.SUFFIX)].map[new Layout(it)] => [
			val all = (it + #[CHOOSE])
			items.all = all
			if (!empty) {
				val head = head
				selectionModel.select(head)
			}
		]
	}

	def selectLayoutDir(Window window) {

		this.dirChooser => [
			initialDirectory = new File(PREFS.get(dirSettingsKey, '.'))
			showDialog(window)?.setLayoutRootDir
		]
	}

}
