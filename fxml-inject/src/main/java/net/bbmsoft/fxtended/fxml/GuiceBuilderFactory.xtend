package net.bbmsoft.fxtended.fxml

import com.google.inject.Injector
import java.util.Map
import javafx.util.Builder
import javafx.util.BuilderFactory
import javafx.fxml.JavaFXBuilderFactory
import com.google.inject.Inject
import net.bbmsoft.fxtended.fxml.inject.InjectFXML

class GuiceBuilderFactory implements BuilderFactory {

	static final Map<Class<?>, Builder<?>> builders = newHashMap

	final Injector injector
	final JavaFXBuilderFactory fallbackFactory

	@Inject
	private new(Injector injector) {

		this.injector = injector
		this.fallbackFactory = new JavaFXBuilderFactory
	}

	override getBuilder(Class<?> type) {

		if(type.isAnnotationPresent(InjectFXML)) {
			builders.get(type) ?: new GuiceBuilder(injector, type) => [builders.put(type, it)]
		} else {
			fallbackFactory.getBuilder(type)
		}
	}

}
