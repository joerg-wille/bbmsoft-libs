package net.bbmsoft.stream.log.slf4j.impl

import java.io.File
import java.io.FileOutputStream
import java.util.Properties
import net.bbmsoft.stream.log.slf4j.PropertiesLoader

class StreamLogPropertiesLoader implements PropertiesLoader {

	public final static String DEFAULT_CONFIG_FILE_NAME = "streamlog.xml"

	override load() {

		val fileName = System.getProperty("streamlogConfig") ?: DEFAULT_CONFIG_FILE_NAME

		val resources = Thread.currentThread.contextClassLoader.getResources(fileName)
		val configFile = (if(resources.hasMoreElements) resources.nextElement) ?: new File(fileName).toURI.toURL

		try {
			new Properties => [
				loadFromXML(configFile.openStream)
			]
		} catch (Throwable e) {
			System.err.
				println('''Could not read StreamLog config file «fileName» in the classpath or working directory. Creating file with default settings in working directory...''')
			createDefault
		}
	}

	private def Properties createDefault() {

		new Properties => [
			put(PROPERTY_KEY_HOST, 'localhost')
			put(PROPERTY_KEY_PORT, '1337')
			put(PROPERTY_KEY_CLIENT_NAME, 'client')
			put(PROPERTY_KEY_LOG_LEVEL, 'INFO')

			persist
		]
	}

	private def persist(Properties prop) {

		val file = new File(DEFAULT_CONFIG_FILE_NAME)

		val fos = new FileOutputStream(file)

		try {
			prop.storeToXML(fos, null)
		} catch (Throwable e) {
			System.err.println('''Could not write to file «file»: «e.message»''')
		} finally {
			fos.close
		}
	}

}