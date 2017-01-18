package net.bbmsoft.stream.log.slf4j

import com.google.common.collect.Queues
import java.io.PrintStream
import java.util.Properties
import java.util.Queue
import java.util.concurrent.Executor
import java.util.concurrent.Executors
import java.util.function.Consumer
import javafx.beans.property.ObjectProperty
import javafx.beans.property.ObjectPropertyBase
import javax.inject.Inject
import javax.inject.Singleton
import net.bbmsoft.stream.log.StreamLogClient
import net.bbmsoft.stream.log.slf4j.inject.StreamLog
import org.apache.commons.lang3.StringUtils

import static extension java.lang.Integer.*
import static extension java.lang.String.*

@Singleton
class StreamLogSender implements Consumer<String> {

	final Executor sendExecutor
	final Executor connectionExecutor
	final ObjectProperty<PrintStream> printStream
	final Queue<String> logQueue

	final StreamLogClient streamLogClient

	final Properties config

	@Inject
	protected new(StreamLogClient client, @StreamLog Properties config) {

		this.config = config

		this.streamLogClient = client

		this.logQueue = Queues.newArrayDeque

		this.sendExecutor = Executors.newSingleThreadExecutor [
			new Thread(it) => [daemon = true; name = 'PrintStream Logging Thread']
		]

		this.connectionExecutor = Executors.newCachedThreadPool [
			new Thread(it) => [daemon = true; name = 'PrintStream Connection Thread']
		]

		this.printStream = new ObjectPropertyBase<PrintStream>() {

			override getBean() {
				this
			}

			override getName() {
				'printStream'
			}

			override protected invalidated() {
				printStreamChanged
			}

		}

		connect
	}

	override accept(String msg) {
		sendExecutor.execute[send(msg)]
	}

	private def setPrintStream(PrintStream stream) {
		sendExecutor.execute[printStream.set = stream]
	}

	private def send(String msg) {

		val stream = printStream.get

		if (stream != null) {
			try {
				stream.println(msg)
			} catch (Throwable t) {
				printStream.set = null
				logQueue.add(msg)
				connect
			}
		} else {
			logQueue.add(msg)
		}

	}

	private def printStreamChanged() {

		val stream = printStream.get

		if (stream != null) {
			while (!logQueue.empty) {
				stream.println(logQueue.remove)
			}
		}
	}

	private def connect() {

		connectionExecutor.execute [

			val host = config.get(PropertiesLoader.PROPERTY_KEY_HOST).valueOf
			val port = config.get(PropertiesLoader.PROPERTY_KEY_PORT).valueOf
			val name = config.get(PropertiesLoader.PROPERTY_KEY_CLIENT_NAME).valueOf

			if(host == null || port == null || !StringUtils.isNumeric(port) || name == null) {

				val errors = '''The following problems have occured:
				«IF host == null» - host is not set
				«ENDIF»«IF port == null»- port is not set
				«ENDIF»«IF port != null && !StringUtils.isNumeric(port)»- invalid port number '«port»'
				«ENDIF»«IF port == null»- client name is not set
				«ENDIF»'''

				throw new IllegalStateException(errors)
			}

			val stream = streamLogClient.getPrintStream(host, port.parseInt, name, -1)

			printStream = stream
		]
	}

}