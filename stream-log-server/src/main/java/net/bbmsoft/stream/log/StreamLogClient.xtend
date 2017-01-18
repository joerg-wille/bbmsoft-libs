package net.bbmsoft.stream.log

import java.io.PrintStream
import java.net.Socket
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors
import java.util.concurrent.Future

class StreamLogClient {

	final ExecutorService exec

	new() {
		exec = Executors.newCachedThreadPool[new Thread(it) => [daemon = true]]
	}

	def Future<PrintStream> getPrintStreamFuture(String host, int port, String name, long timeout) {
		exec.submit[createStream(host, port, name, timeout)]
	}

	def PrintStream getPrintStream(String host, int port, String name, long timeout) {
		createStream(host, port, name, timeout)
	}

	private def createStream(String host, int port, String name, long timeout) {

		val now = System.currentTimeMillis

		while (timeout <= 0 || System.currentTimeMillis - now < timeout) {

			try {
				val socket = new Socket(host, port)

				return new PrintStream(socket.outputStream) => [
					println(name)
				]
			} catch (Throwable e) {
				System.err.println("Connection failed: " + e.message + ". Trying again...")
				Thread.sleep(1000)
			}
		}

		System.err.println("Could not connect to log host.")
		null
	}
}