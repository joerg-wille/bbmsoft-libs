package net.bbmsoft.stream.log.slf4j

import java.io.PrintWriter
import java.io.StringWriter
import java.time.Clock
import java.util.function.Consumer
import javax.inject.Inject
import org.eclipse.xtend.lib.annotations.Accessors
import org.slf4j.Logger
import org.slf4j.Marker

import static extension java.lang.String.*
import static extension java.time.Instant.*

class StreamLogger implements Logger {

	// TODO add marker support

	enum Level {

		TRACE, DEBUG, INFO, WARN, ERROR, OFF;
	}

	final Clock clock

	final Consumer<String> sender

	@Accessors String name
	@Accessors Level level

	@Inject
	protected new(Clock clock, Consumer<String> sender) {
		this.clock = clock
		this.sender = sender
	}

	override debug(String arg0) {

		val formatted = Level.DEBUG.format(arg0)
		formatted.send
	}

	override debug(String arg0, Object arg1) {

		val formatted = Level.DEBUG.format(arg0, arg1)
		formatted.send
	}

	override debug(String arg0, Object... arg1) {

		val formatted = Level.DEBUG.format(arg0, arg1)
		formatted.send
	}

	override debug(String arg0, Throwable arg1) {

		val formatted = Level.DEBUG.format(arg0, arg1)
		formatted.send
	}

	override debug(Marker arg0, String arg1) {
		debug(arg1)
	}

	override debug(String arg0, Object arg1, Object arg2) {
		val formatted = Level.DEBUG.format(arg0, arg1, arg2)
		formatted.send
	}

	override debug(Marker arg0, String arg1, Object arg2) {
		debug(arg1, arg2)
	}

	override debug(Marker arg0, String arg1, Object... arg2) {
		debug(arg1, arg2)
	}

	override debug(Marker arg0, String arg1, Throwable arg2) {
		debug(arg1, arg2)
	}

	override debug(Marker arg0, String arg1, Object arg2, Object arg3) {
		debug(arg1, arg2, arg3)
	}

	override error(String arg0) {

		val formatted = Level.ERROR.format(arg0)
		formatted.send
	}

	override error(String arg0, Object arg1) {

		val formatted = Level.ERROR.format(arg0, arg1)
		formatted.send
	}

	override error(String arg0, Object... arg1) {

		val formatted = Level.ERROR.format(arg0, arg1)
		formatted.send
	}

	override error(String arg0, Throwable arg1) {

		val formatted = Level.ERROR.format(arg0, arg1)
		formatted.send
	}

	override error(Marker arg0, String arg1) {
		error(arg1)
	}

	override error(String arg0, Object arg1, Object arg2) {

		val formatted = Level.ERROR.format(arg0, arg1, arg2)
		formatted.send
	}

	override error(Marker arg0, String arg1, Object arg2) {
		error(arg1, arg2)
	}

	override error(Marker arg0, String arg1, Object... arg2) {
		error(arg1, arg2)
	}

	override error(Marker arg0, String arg1, Throwable arg2) {
		error(arg1, arg2)
	}

	override error(Marker arg0, String arg1, Object arg2, Object arg3) {
		error(arg1, arg2, arg3)
	}

	override info(String arg0) {

		val formatted = Level.INFO.format(arg0)
		formatted.send
	}

	override info(String arg0, Object arg1) {

		val formatted = Level.INFO.format(arg0, arg1)
		formatted.send
	}

	override info(String arg0, Object... arg1) {

		val formatted = Level.INFO.format(arg0, arg1)
		formatted.send
	}

	override info(String arg0, Throwable arg1) {

		val formatted = Level.INFO.format(arg0, arg1)
		formatted.send
	}

	override info(Marker arg0, String arg1) {
		info(arg1)
	}

	override info(String arg0, Object arg1, Object arg2) {

		val formatted = Level.INFO.format(arg0, arg1, arg2)
		formatted.send
	}

	override info(Marker arg0, String arg1, Object arg2) {
		info(arg1, arg2)
	}

	override info(Marker arg0, String arg1, Object... arg2) {
		info(arg1, arg2)
	}

	override info(Marker arg0, String arg1, Throwable arg2) {
		info(arg1, arg2)
	}

	override info(Marker arg0, String arg1, Object arg2, Object arg3) {
		info(arg1, arg2, arg3)
	}

	override isDebugEnabled() {
		level <= Level.DEBUG
	}

	override isDebugEnabled(Marker arg0) {
		level <= Level.DEBUG
	}

	override isErrorEnabled() {
		level <= Level.ERROR
	}

	override isErrorEnabled(Marker arg0) {
		level <= Level.ERROR
	}

	override isInfoEnabled() {
		level <= Level.INFO
	}

	override isInfoEnabled(Marker arg0) {
		level <= Level.INFO
	}

	override isTraceEnabled() {
		level <= Level.TRACE
	}

	override isTraceEnabled(Marker arg0) {
		level <= Level.TRACE
	}

	override isWarnEnabled() {
		level <= Level.WARN
	}

	override isWarnEnabled(Marker arg0) {
		level <= Level.WARN
	}

	override trace(String arg0) {

		val formatted = Level.TRACE.format(arg0)
		formatted.send
	}

	override trace(String arg0, Object arg1) {

		val formatted = Level.TRACE.format(arg0, arg1)
		formatted.send
	}

	override trace(String arg0, Object... arg1) {

		val formatted = Level.TRACE.format(arg0, arg1)
		formatted.send
	}

	override trace(String arg0, Throwable arg1) {

		val formatted = Level.TRACE.format(arg0, arg1)
		formatted.send
	}

	override trace(Marker arg0, String arg1) {
		trace(arg1)
	}

	override trace(String arg0, Object arg1, Object arg2) {

		val formatted = Level.TRACE.format(arg0, arg1, arg2)
		formatted.send
	}

	override trace(Marker arg0, String arg1, Object arg2) {
		trace(arg1, arg2)
	}

	override trace(Marker arg0, String arg1, Object... arg2) {
		trace(arg1, arg2)
	}

	override trace(Marker arg0, String arg1, Throwable arg2) {
		trace(arg1, arg2)
	}

	override trace(Marker arg0, String arg1, Object arg2, Object arg3) {
		trace(arg1, arg2, arg3)
	}

	override warn(String arg0) {

		val formatted = Level.WARN.format(arg0)
		formatted.send
	}

	override warn(String arg0, Object arg1) {

		val formatted = Level.WARN.format(arg0, arg1)
		formatted.send
	}

	override warn(String arg0, Object... arg1) {

		val formatted = Level.WARN.format(arg0, arg1)
		formatted.send
	}

	override warn(String arg0, Throwable arg1) {

		val formatted = Level.WARN.format(arg0, arg1)
		formatted.send
	}

	override warn(Marker arg0, String arg1) {
		warn(arg1)
	}

	override warn(String arg0, Object arg1, Object arg2) {

		val formatted = Level.WARN.format(arg0, arg1, arg2)
		formatted.send
	}

	override warn(Marker arg0, String arg1, Object arg2) {
		warn(arg1, arg2)
	}

	override warn(Marker arg0, String arg1, Object... arg2) {
		warn(arg1, arg2)
	}

	override warn(Marker arg0, String arg1, Throwable arg2) {
		warn(arg1, arg2)
	}

	override warn(Marker arg0, String arg1, Object arg2, Object arg3) {
		warn(arg1, arg2, arg3)
	}

	private def String format(Level level, String msg) {

		'''«now» [«level»] [«thread»] «formattedName»: «msg»'''
	}

	private dispatch def String format(Level level, String msg, Object arg) {

		'''«now» [«level»] «thread»: «msg.replaceFirst('{}', arg.valueOf)»'''
	}

	private dispatch def String format(Level level, String msg, Throwable throwable) {

		'''
			«now» [«level»] «thread»: «msg»
			«throwable.toStacktrace»
		'''
	}

	private dispatch def String format(Level level, String msg, Object ... args) {

		'''«now» [«level»] «thread»: «msg.replace(args)»'''
	}

	private def String format(Level level, String msg, Object arg1, Object arg2) {

		'''«now» [«level»] «thread»: «msg.replaceFirst('{}', arg1.valueOf).replaceFirst('{}', arg2.valueOf)»'''
	}

	private def send(String msg) {

		if(sender != null) {
			sender.accept(msg)
		} else {
			println(msg)
		}
	}

	private def String now() {

		// TODO make formatting options configurable

		clock.now.toString
	}

	private def String thread() {

		Thread.currentThread.name
	}

	private def getFormattedName() {

		// TODO make name formatting configurable

		name
	}

	private def String toStacktrace(Throwable throwable) {

		(new StringWriter => [new PrintWriter(it) => [throwable.printStackTrace(it)]]).toString
	}

	private def String replace(String msg, Object ... args) {

		if (msg == null || args == null) {
			null.valueOf
		} else {
			var theMsg = msg
			for (arg : args) {
				theMsg = theMsg.replaceFirst('{}', arg.valueOf)
			}
			theMsg
		}
	}
}