package net.bbmsoft.stream.log

import java.io.BufferedReader
import java.io.InputStreamReader
import java.net.ServerSocket
import java.net.Socket
import java.util.List
import java.util.Map
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors
import java.util.function.BiConsumer
import java.net.SocketException

class StreamLogServer {

	final ExecutorService exec
	final ServerSocket  server

	final Map<String, BufferedReader> readers
	final List<BiConsumer<String, BufferedReader>> subscribers

	final Object lock

	Boolean running = false


	new(int port) {
		this.exec = Executors.newCachedThreadPool[new Thread(it) => [daemon = true]]
		this.server = new ServerSocket(port)
		this.readers = newHashMap
		this.subscribers = newArrayList
		this.lock = new Object
	}

	def start() {
		synchronized(running) {
			if(running == false) {
				running = true
				doStart
			}
		}
	}

	def stop() {
		synchronized(running) {
			server.close
			running = false
		}
	}

	def void subScribe(BiConsumer<String, BufferedReader> consumer) {

		synchronized(lock) {
			readers.forEach[n, r| consumer.accept(n, r)]
			subscribers.add(consumer)
		}
	}

	private def doStart() {
		exec.execute [
			try {
				while (running) {
					val socket = server.accept
					exec.execute[socket.processNewConnection]
				}
			} catch (SocketException e) {
				System.err.println(e.message)
			} finally {
				server.close
			}
		]
	}

	private def processNewConnection(Socket socket) {

		synchronized(lock) {
			val reader = new BufferedReader(new InputStreamReader(socket.inputStream))
			val name = reader.readLine

			readers.put(name, reader)
			subscribers.forEach[accept(name, reader)]
		}
	}

}