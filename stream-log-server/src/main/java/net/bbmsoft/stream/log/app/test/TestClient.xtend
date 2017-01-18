package net.bbmsoft.stream.log.app.test

import net.bbmsoft.stream.log.StreamLogClient

import static extension java.lang.Integer.*

class TestClientSP {

	int counter

	def run(int port) {

		val streamFuture = new StreamLogClient().getPrintStreamFuture('localhost', port, 'TestClient', 0)

		println("Waiting for server ...")

		val writer = streamFuture.get

		while (true) {
			writer.println(counter++)
			Thread.sleep(400)
		}
	}

	def static void main(String[] args) {
		try {
			new TestClientSP().run(args.get(0).parseInt)
		} catch (Throwable e) {
			System.err.println("Must specify valid port number in arguments!")
		}
	}

}