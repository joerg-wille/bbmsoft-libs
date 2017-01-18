package net.bbmsoft.stream.log.slf4j

import java.util.Map
import java.util.Properties
import javax.inject.Inject
import javax.inject.Provider
import org.slf4j.ILoggerFactory

import static extension java.lang.String.*
import java.util.Locale
import javax.inject.Singleton
import net.bbmsoft.stream.log.slf4j.inject.StreamLog

@Singleton
class StreamLoggerFactory implements ILoggerFactory {

	final Provider<StreamLogger> loggerProvider
	final Map<String, StreamLogger> loggers
	final Properties config

	@Inject
	protected new(Provider<StreamLogger> loggerProvider, @StreamLog Properties config) {
		this.loggerProvider = loggerProvider
		this.loggers = newHashMap
		this.config = config
	}

	override getLogger(String name) {

		synchronized (loggers) {
			loggers.get(name) ?: (loggerProvider.get => [configure(name); loggers.put(name, it)])
		}
	}

	private def configure(StreamLogger logger, String name) {

		val level = try {
			StreamLogger.Level.valueOf(config.get(PropertiesLoader.PROPERTY_KEY_LOG_LEVEL).valueOf.toUpperCase(Locale.US))
		} catch (Throwable e) {
			StreamLogger.Level.INFO
		}

		logger.name = name
		logger.level = level
	}

}