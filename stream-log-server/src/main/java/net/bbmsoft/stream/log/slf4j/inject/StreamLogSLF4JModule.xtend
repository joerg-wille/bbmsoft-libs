package net.bbmsoft.stream.log.slf4j.inject

import com.google.inject.Binder
import com.google.inject.Module
import com.google.inject.Provides
import java.time.Clock
import java.util.Properties
import net.bbmsoft.stream.log.slf4j.PropertiesLoader
import net.bbmsoft.stream.log.slf4j.impl.StreamLogPropertiesLoader
import com.google.inject.TypeLiteral
import java.util.function.Consumer
import net.bbmsoft.stream.log.slf4j.StreamLogSender

class StreamLogSLF4JModule implements Module {

	final PropertiesLoader loader

	Boolean loaded
	Properties streamLogProperties

	new() {
		this.loaded = false
		this.loader = new StreamLogPropertiesLoader
	}

	override configure(extension Binder binder) {

		PropertiesLoader.bind.annotatedWith(StreamLog).to(StreamLogPropertiesLoader)
		new TypeLiteral<Consumer<String>>{}.bind.to(StreamLogSender)
	}

	@Provides @StreamLog def Properties provideStreamLogProperties() {

		synchronized(loaded) {

			if(!loaded) {
				streamLogProperties = loadStreamLogProperties
				loaded = true
			}

			streamLogProperties
		}
	}

	@Provides def Clock provideClock() {
		Clock.systemUTC
	}

	private def Properties loadStreamLogProperties() {

		streamLogProperties = loader.load
	}

}