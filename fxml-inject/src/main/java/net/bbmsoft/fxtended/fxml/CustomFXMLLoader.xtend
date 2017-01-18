package net.bbmsoft.fxtended.fxml

import javafx.fxml.FXMLLoader
import javafx.util.BuilderFactory
import com.google.inject.Inject

class CustomFXMLLoader extends FXMLLoader {

	@Inject
	protected new(BuilderFactory builderFactory) {
		this.builderFactory = builderFactory
	}
}