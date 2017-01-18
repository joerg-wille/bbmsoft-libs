package net.bbmsoft.fxtended.fxml.inject

import com.google.inject.Binder
import com.google.inject.Module
import javafx.fxml.FXMLLoader
import net.bbmsoft.fxtended.fxml.CustomFXMLLoader

class CustomFXMLLoaderModule implements Module {

	override public configure(extension Binder binder) {

		FXMLLoader.bind.to(CustomFXMLLoader)
	}

	override toString() {
		class.simpleName
	}

}