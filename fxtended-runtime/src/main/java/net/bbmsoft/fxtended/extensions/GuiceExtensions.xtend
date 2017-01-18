package net.bbmsoft.fxtended.extensions

import com.google.inject.Guice
import com.google.inject.Injector
import com.google.inject.Module
import java.lang.annotation.Annotation

class GuiceExtensions {

	def static <I, C extends I> Module => (Class<I> interfaceType, Class<C> implementingType) {

		[bind(interfaceType).to(implementingType)]
	}

	def static <I, C extends I> Module => (Pair<Class<I>, Class<? extends Annotation>> annotatedInterfaceType, Class<C> implementingType) {

		[bind(annotatedInterfaceType.key).annotatedWith(annotatedInterfaceType.value).to(implementingType)]
	}

	def static <I, C extends I> Module => (Class<I> interfaceType, C instance) {

		[bind(interfaceType).toInstance(instance)]
	}

	def static <I, C extends I> Module => (Pair<Class<I>, Class<? extends Annotation>> annotatedInterfaceType, C instance) {

		[bind(annotatedInterfaceType.key).annotatedWith(annotatedInterfaceType.value).toInstance(instance)]
	}

	def static <I> Pair<Class<I>, Class<? extends Annotation>> annotatedWith(Class<I> interfaceType, Class<? extends Annotation> annotationType) {
		interfaceType -> annotationType
	}

	def static Module module(Module ... modules) {

		[binder | modules.forEach[configure(binder)]]
	}

	def static <T, V extends T> Injector injector(Pair<Class<T>, Class<V>> ... pairs) {

		Guice.createInjector(pairs.map[key => value])
	}
}