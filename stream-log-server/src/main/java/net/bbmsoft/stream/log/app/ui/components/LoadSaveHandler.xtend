package net.bbmsoft.stream.log.app.ui.components

import java.io.File
import java.io.FileWriter
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter
import java.util.Objects
import javafx.stage.FileChooser
import javafx.stage.FileChooser.ExtensionFilter
import javafx.stage.Window

class LoadSaveHandler {

	File logFile

	def void save(String name, String log, Window window) {
		logFile?.doSave(log, window) ?: saveAs(name, log, window)
	}

	def saveAs(String name, String log, Window window) {

		val fileChooser = new FileChooser =>
			[
				title = "Save log file as..."
				initialDirectory = logFile?.
					parentFile
				initialFileName = '''«name» («DateTimeFormatter.ofPattern("yyyy-MM-dd HH.mm.ss").format(LocalDateTime.now)»)'''
				extensionFilters.add = new ExtensionFilter('Text file', '*.txt')
			]

		val file = fileChooser.showSaveDialog(window)

		if(file != null) {
			logFile = file => [doSave(log, window)]
		}
	}


	private def doSave(File file, String log, Window window) {

		Objects.requireNonNull(file)

		val fileWriter = new FileWriter(file)

		try {
			fileWriter.append(log ?: '')
		} finally {
			fileWriter?.close
		}
	}
}