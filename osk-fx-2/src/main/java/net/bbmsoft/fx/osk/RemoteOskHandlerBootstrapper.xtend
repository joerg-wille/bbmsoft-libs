package net.bbmsoft.fx.osk

import java.net.URL
import java.net.URLClassLoader
import java.rmi.registry.LocateRegistry
import java.util.Locale
import java.util.ResourceBundle
import javafx.fxml.FXMLLoader
import net.bbmsoft.fx.osk.impl.LocalOskNodeConnectorWrapper
import net.bbmsoft.fx.osk.impl.RemoteNodeAttachableKeyboardWrapper
import net.bbmsoft.fx.osk.impl.layout.OSKLayout
import net.bbmsoft.keyboard.remote.RemoteKeyboardControllerWrapper
import net.bbmsoft.keyboard.remote.SimpleRemoteThreadsafeKeyboardIoHandler

class RemoteOskHandlerBootstrapper {

	def createOskHandler(URL keyLayout) {
		createOskHandler(keyLayout, null, null, null as ClassLoader)
	}

	def createOskHandler(URL keyLayout, boolean resourceFromLayout) {
		createOskHandler(keyLayout, if(resourceFromLayout) keyLayout.resourceBundleName else null,
			if(resourceFromLayout) keyLayout.resourceBundleClassLoadder else null)
	}

	def createOskHandler(URL keyLayout, String resourceBundleBaseName, Locale locale, boolean resourceFromLayout) {
		createOskHandler(keyLayout, if(resourceFromLayout) keyLayout.resourceBundleName else null, locale,
			if(resourceFromLayout) keyLayout.resourceBundleClassLoadder else null)
	}

	def createOskHandler(URL keyLayout, String resourceBundleBaseName, ClassLoader bundleClassLoader) {
		createOskHandler(keyLayout, resourceBundleBaseName, Locale.^default, bundleClassLoader)
	}

	def createOskHandler(URL boardLayout, URL keyLayout, String resourceBundleBaseName, Locale locale,
		Class<?> bundleClass) {
		createOskHandler(keyLayout, resourceBundleBaseName, locale, bundleClass.classLoader)
	}

	def createOskHandler(URL keyLayout, String resourceBundleBaseName, Locale locale, ClassLoader bundleClassLoader) {

		val keyLoader = new FXMLLoader(keyLayout);

		if (resourceBundleBaseName != null) {

			if (bundleClassLoader != null) {
				keyLoader.resources = ResourceBundle.getBundle(resourceBundleBaseName, locale, bundleClassLoader)
			} else {
				keyLoader.resources = ResourceBundle.getBundle(resourceBundleBaseName, locale)
			}
		}

		val registry = LocateRegistry.getRegistry('localhost')
		val remoteController = (registry).lookup('controller') as RemoteOskController

		val controllerWrapper = new RemoteKeyboardControllerWrapper(remoteController)

		val keyMap = (keyLoader.load as OSKLayout).keyMap
		val ioHandler = new SimpleRemoteThreadsafeKeyboardIoHandler(controllerWrapper, keyMap)

		val Object nodeAttachable = remoteController.nodeAttachable

		if(!(nodeAttachable instanceof RemoteNodeAttachableKeyboard)) {
			throw new ClassCastException('''«nodeAttachable» cannot be cast to «RemoteNodeAttachableKeyboard»''')
		}

		val remoteNodeAttachableKeyboardWrapper = new RemoteNodeAttachableKeyboardWrapper(nodeAttachable as RemoteNodeAttachableKeyboard)
		val connector = new OskFxNodeConnectorImpl(remoteNodeAttachableKeyboardWrapper)

		val localOskNodeConnectorWrapper = new LocalOskNodeConnectorWrapper(connector)
		remoteController.addNodeConnector(localOskNodeConnectorWrapper)
		controllerWrapper.addListener(ioHandler)
		ioHandler.addListener = connector
		controllerWrapper.armListener(ioHandler)

		ioHandler -> connector
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
