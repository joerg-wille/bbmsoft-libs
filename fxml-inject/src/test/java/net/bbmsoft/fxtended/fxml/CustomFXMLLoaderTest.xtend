package net.bbmsoft.fxtended.fxml

import com.google.inject.Injector
import com.google.inject.Module
import java.util.List
import javafx.collections.FXCollections
import javafx.collections.ObservableList
import javafx.fxml.FXMLLoader
import net.bbmsoft.fxtended.fxml.inject.GuiceFXMLLoaderModule
import net.bbmsoft.fxtended.fxml.inject.InjectFXML
import org.eclipse.xtend.lib.annotations.Accessors
import org.junit.Before
import org.junit.Ignore
import org.junit.Test

import static extension com.google.inject.Guice.*
import static extension org.junit.Assert.*

class CustomFXMLLoaderTest {

	extension Injector injector

	@Before
	def void setUp() {
		val Module printerModule = [extension binder |
			Printer.bind.to(PrinterImpl)
			Addition.bind.to(AdditionImpl)
		]
		injector = #[new GuiceFXMLLoaderModule, printerModule].createInjector
	}

	@Test
	def void testLoadClass() {

		val resource = CustomFXMLLoaderTest.getResource("/layout/LoadTestClass.fxml")

		val loader = FXMLLoader.instance => [
			location = resource
		]

		val Printer printer = loader.load

		assertTrue(printer instanceof PrinterImpl)
	}

	@Test
	def void testSetClass() {

		val resource = CustomFXMLLoaderTest.getResource("/layout/SetTestClass.fxml")

		val loader = FXMLLoader.instance => [
			location = resource
		]

		val Printer printer = loader.load

		printer.text.assertEquals("Hello World")
	}

	@Test
	def void testGetClass() {

		val resource = CustomFXMLLoaderTest.getResource("/layout/GetTestClass.fxml")

		val loader = FXMLLoader.instance => [
			location = resource
		]

		val Printer printer = loader.load

		3.assertEquals(printer.texts.size)

		printer.texts.contains("Hello").assertTrue
		printer.texts.contains("World").assertTrue
		printer.texts.contains("!").assertTrue
	}

	@Test
	def void testLoadInterface() {

		val resource = CustomFXMLLoaderTest.getResource("/layout/LoadTest.fxml")

		val loader = FXMLLoader.instance => [
			location = resource
		]

		val Printer printer = loader.load

		assertTrue(printer instanceof PrinterImpl)
	}

	@Test
	def void testSetInterface() {

		val resource = CustomFXMLLoaderTest.getResource("/layout/SetTest.fxml")

		val loader = FXMLLoader.instance => [
			location = resource
		]

		val Printer printer = loader.load

		printer.text.assertEquals("Hello World")
	}

	@Test
	def void testGetInterface() {

		val resource = CustomFXMLLoaderTest.getResource("/layout/GetTest.fxml")

		val loader = FXMLLoader.instance => [
			location = resource
		]

		val Printer printer = loader.load

		3.assertEquals(printer.texts.size)

		printer.texts.contains("Hello").assertTrue
		printer.texts.contains("World").assertTrue
		printer.texts.contains("!").assertTrue
	}

	@Ignore
	@Test
	def void testLoadDouble() {

		val resource = CustomFXMLLoaderTest.getResource("/layout/LoadDoubleTest.fxml")

		val loader = FXMLLoader.instance => [
			location = resource
		]

		val Addition add = loader.load

		val result = add.result
		assertTrue(result == 1.1)
	}

	@Ignore
	@Test
	def void testGetDouble() {

		val resource = CustomFXMLLoaderTest.getResource("/layout/GetDoubleTest.fxml")

		val loader = FXMLLoader.instance => [
			location = resource
		]

		val Addition add = loader.load

		val result = add.result
		assertTrue(result == 6.6)
	}
}

@InjectFXML
interface Addition {

	def void setA(double a)

	def void setB(double b)

	def double getA()

	def double getB()

	def List<Double> getArgs()

	def double getResult()
}

@InjectFXML
class AdditionImpl implements Addition {

	@Accessors double a
	@Accessors double b

	List<Double> args = newArrayList

	override getArgs() {
		args
	}

	override getResult() {
		var double sum = 0.0

		for(Double d : args) {
			sum += d
		}

		sum
	}

}

@InjectFXML
interface Printer {

	def void setText(String text)

	def ObservableList<String> getTexts()

	def String getText()

	def void print()
}

@InjectFXML
class PrinterImpl implements Printer {

	val ObservableList<String> texts = FXCollections.observableArrayList

	@Accessors(PUBLIC_GETTER, PUBLIC_SETTER)
	String text

	override print() {
		println(text)
	}

	override getTexts() {
		texts
	}

}
