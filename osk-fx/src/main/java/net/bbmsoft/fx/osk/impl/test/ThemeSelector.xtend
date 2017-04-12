package net.bbmsoft.fx.osk.impl.test

import java.io.File
import java.util.Locale
import java.util.prefs.Preferences
import javafx.scene.control.ChoiceBox
import javafx.stage.DirectoryChooser
import javafx.stage.Window
import org.eclipse.xtend.lib.annotations.Accessors
import net.bbmsoft.fx.osk.impl.test.ThemeSelector.Theme

import static extension net.bbmsoft.fxtended.extensions.BindingOperatorExtensions.*

class ThemeSelector extends ChoiceBox<Theme> {

	final static Preferences PREFS = Preferences.userNodeForPackage(ThemeSelector)
	final static Theme CHOOSE = new Theme

	static class Theme {

		public static final String SUFFIX = '.css'

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
	final String dirSettingsKey

	new(String dirSettingsKey) {

		this.dirSettingsKey = dirSettingsKey

		this.dirChooser = new DirectoryChooser => [
			title = 'Select Themes directory...'

		]

		selectionModel.selectedItemProperty >> [ o, oldVal, newVal |
			if(oldVal !== null && oldVal.file !== null) scene?.stylesheets?.remove(oldVal.file.toURI.toURL.toExternalForm)
			if (newVal !== null) {
				if (newVal.file === null) {
					selectThemeDir(scene.window)
				} else {
					scene?.stylesheets?.add(newVal.file.toURI.toURL.toExternalForm)
				}
			}
		]

		val dir = PREFS.get(dirSettingsKey, '')
		if (!dir.isEmpty) {
			setThemeRootDir(new File(dir))
		} else {
			items.all = #[CHOOSE]
		}
	}

	def setThemeRootDir(File file) {

		PREFS.put(dirSettingsKey, file.absolutePath)

		file.listFiles[name.toLowerCase(Locale.US).endsWith(Theme.SUFFIX)].map[new Theme(it)] => [
			items.all = it + #[CHOOSE]
			if (!empty) {
				val head = head
				selectionModel.select(head)
			}
		]
	}

	def selectThemeDir(Window window) {

		this.dirChooser => [
			initialDirectory = new File(PREFS.get(dirSettingsKey, '.'))
			showDialog(window)?.setThemeRootDir
		]
	}
}
