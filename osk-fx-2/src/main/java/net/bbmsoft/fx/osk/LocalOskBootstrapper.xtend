package net.bbmsoft.fx.osk

import java.net.URL
import java.net.URLClassLoader
import java.util.Locale
import java.util.ResourceBundle
import javafx.fxml.FXMLLoader
import net.bbmsoft.fx.osk.impl.layout.OSKLayout

class LocalOskBootstrapper {

	def createOsk(URL boardLayout, URL keyLayout) {
		createOsk(boardLayout, keyLayout, null, null, null as ClassLoader)
	}

	def createOsk(URL boardLayout, URL keyLayout, boolean resourceFromLayout) {
		createOsk(boardLayout, keyLayout, if(resourceFromLayout) keyLayout.resourceBundleName else null,
			if(resourceFromLayout) keyLayout.resourceBundleClassLoadder else null)
	}

	def createOsk(URL boardLayout, URL keyLayout, String resourceBundleBaseName, Locale locale, boolean resourceFromLayout) {
		createOsk(boardLayout, keyLayout, if(resourceFromLayout) keyLayout.resourceBundleName else null, locale,
			if(resourceFromLayout) keyLayout.resourceBundleClassLoadder else null)
	}

	def createOsk(URL boardLayout, URL keyLayout, String resourceBundleBaseName, ClassLoader bundleClassLoader) {
		createOsk(boardLayout, keyLayout, resourceBundleBaseName, Locale.^default, bundleClassLoader)
	}

	def createOsk(URL boardLayout, URL keyLayout, String resourceBundleBaseName, Locale locale, Class<?> bundleClass) {
		createOsk(boardLayout, keyLayout, resourceBundleBaseName, locale, bundleClass.classLoader)
	}

	def createOsk(URL boardLayout, URL keyLayout, String resourceBundleBaseName, Locale locale, ClassLoader bundleClassLoader) {

		val keyLoader = new FXMLLoader(keyLayout);

		if (resourceBundleBaseName != null) {

			if (bundleClassLoader != null) {
				keyLoader.resources = ResourceBundle.getBundle(resourceBundleBaseName, locale, bundleClassLoader)
			} else {
				keyLoader.resources = ResourceBundle.getBundle(resourceBundleBaseName, locale)
			}
		}

		val keyMap = (keyLoader.load as OSKLayout).keyMap
		val osk = new OskFx => [load = boardLayout]
		val controller = new OskFxController(osk)
		val ioHandler = new OskFxIOHandler(controller, osk, keyMap)
		val connector = new OskFxNodeConnectorImpl(osk)

		osk.addListener = controller
		controller.addListener = ioHandler
		ioHandler.addListener = connector
		osk.nodeConnectors.add = connector

		osk -> connector
	}

	private def String getResourceBundleName(URL url) {
		url.toExternalForm.split('/').last.split('\\.').head
	}

	private def ClassLoader getResourceBundleClassLoadder(URL url) {
		val uri = url.toURI
		val parent = if(uri.path.endsWith('/')) uri.resolve('..') else uri.resolve('.')
		new URLClassLoader(#[parent.toURL])
	}
}
