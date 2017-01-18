package org.slf4j.impl

import com.google.inject.Guice
import com.google.inject.Injector
import net.bbmsoft.stream.log.slf4j.StreamLoggerFactory
import net.bbmsoft.stream.log.slf4j.inject.StreamLogSLF4JModule
import org.slf4j.ILoggerFactory

class StaticLoggerBinder {

	public static String REQUESTED_API_VERSION = "1.7.12"

	static final StaticLoggerBinder instance = new StaticLoggerBinder

	final extension Injector injector

	private new() {
		this.injector = Guice.createInjector(new StreamLogSLF4JModule)
	}

	def static final StaticLoggerBinder getSingleton() {
		instance
	}

	def ILoggerFactory getLoggerFactory() {
		StreamLoggerFactory.instance
	}

	def String getLoggerFactoryClassStr() {
		StreamLoggerFactory.name
	}
}