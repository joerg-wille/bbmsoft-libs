package net.bbmsoft.stream.log.util

import java.io.OutputStream
import java.io.PrintStream
import java.util.Objects
import net.bbmsoft.stream.log.StreamLogClient

import static java.lang.System.*

import static extension java.lang.Integer.*

class OutputRedirector {

	enum Strategy {
		STD_OUT,
		STD_ERR,
		BOTH
	}

	def static redirectOutput(String clientName, String hostAddress) {
		redirectOutput(clientName, hostAddress, 5000L)
	}

	def static redirectOutput(String clientName, String hostAddress, long timeout) {

		Objects.requireNonNull(hostAddress)

		try {
			val split = hostAddress.split(":")
			val hostName = split.head
			val port = split.last.parseInt

			redirectOutput(clientName, hostName, port, timeout)

		} catch (Throwable e) {
			System.err.println('''Could not parse host address: «e.message»''')
		}
	}

	def static redirectOutput(String clientName, String host, int port) {
		redirectOutput(clientName, host, port, Strategy.BOTH, true, 5000L)
	}

	def static redirectOutput(String clientName, String host, int port, long timeout) {
		redirectOutput(clientName, host, port, Strategy.BOTH, true, timeout)
	}

	def static redirectOutput(String clientName, String host, int port, Strategy strategy) {
		redirectOutput(clientName, host, port, strategy, true, 5000L)
	}

	def static redirectOutput(String clientName, String host, int port, Strategy strategy, boolean blocking, long timeout) {

		if (blocking) {
			System.err.println('''Connecting to log server at «host»:«port»...''')
			doRedirect(clientName, host, port, strategy, timeout)
		} else {
			new Thread [
				System.err.println('''Redirecting output to «host»:«port».''')
				doRedirect(clientName, host, port, strategy, timeout)
			] => [
				daemon = true
				start
			]
		}
	}

	private def static boolean doRedirect(String clientName, String host, int port, Strategy strategy, long timeout) {

		val stdErr = System.err

		val streamFuture = new StreamLogClient().getPrintStreamFuture(host, port, clientName, timeout)
		val stream = streamFuture.get

		if(stream == null) {
			stdErr.println('''Output could not be redirected to «host»:«port».''')
			return false
		}

		switch strategy {
			case STD_OUT: {
				System.setOut = new PrintStream(new OutputStreamSplitter(stream, System.out))
			}
			case STD_ERR: {
				System.setErr = new PrintStream(new OutputStreamSplitter(stream, System.err))
			}
			case BOTH: {
				System.setOut = new PrintStream(new OutputStreamSplitter(stream, System.out))
				System.setErr = new PrintStream(new OutputStreamSplitter(stream, System.err))
			}
		}

		stdErr.println('''Output successfully redirected to «host»:«port».''')
		true

	}

	static class OutputStreamSplitter extends OutputStream {

		final OutputStream streamA
		final OutputStream streamB

		new(OutputStream a, OutputStream b) {

			this.streamA = a
			this.streamB = b
		}

		override write(int b) {
			streamA.write(b)
			streamB.write(b)
		}

	}
}