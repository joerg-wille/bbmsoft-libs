package net.bbmsoft.fxtended.fxml.inject

import com.google.inject.Binder
import com.google.inject.Module
import javafx.fxml.FXMLLoader
import javafx.util.BuilderFactory
import net.bbmsoft.fxtended.fxml.GuiceBuilderFactory
import net.bbmsoft.fxtended.fxml.GuiceFXMLLoader

class GuiceFXMLLoaderModule implements Module {

	override public configure(extension Binder binder) {

		FXMLLoader.bind.to(GuiceFXMLLoader)
		BuilderFactory.bind.to(GuiceBuilderFactory)
	}

	override toString() {
		class.simpleName
	}

}