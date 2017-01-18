package net.bbmsoft.fxtended.fxml

import com.google.inject.Injector
import javafx.util.BuilderFactory
import com.google.inject.Inject

class GuiceFXMLLoader extends CustomFXMLLoader {

	@Inject
	protected new(BuilderFactory builderFactory, extension Injector injector) {
		super(builderFactory)
		this.controllerFactory = [clazz | clazz.instance]
	}
}