package net.bbmsoft.jna.annotations.impl

import com.sun.jna.Library
import net.bbmsoft.jna.annotations.JNA
import org.eclipse.xtend.lib.macro.AbstractInterfaceProcessor
import org.eclipse.xtend.lib.macro.TransformationContext
import org.eclipse.xtend.lib.macro.declaration.MutableInterfaceDeclaration
import org.eclipse.xtend.lib.macro.declaration.Visibility
import com.sun.jna.Native

class JnaProcessor extends AbstractInterfaceProcessor {

	override doTransform(MutableInterfaceDeclaration annotatedInterface, extension TransformationContext context) {

		val annotation = annotatedInterface.findAnnotation(findTypeGlobally(JNA))

		val libraryRef = Library.newTypeReference

		if (libraryRef == null) {
			annotation.addError(
				'Could not find required interface com.sun.jna.Library. Please make sure it is on the class path.')
				return
		}

		if (!annotatedInterface.extendedInterfaces.toList.contains(libraryRef)) {
			annotatedInterface.extendedInterfaces = annotatedInterface.extendedInterfaces + #[libraryRef]
		}

		val libname = annotation.getValue('value').toString

		annotatedInterface.addField('INSTANCE') [
				visibility = Visibility.PUBLIC
				static = true
				final = true
				type = annotatedInterface.newSelfTypeReference
				initializer = [

					val nativeType = toJavaCode(Native.newTypeReference)

					'''(«annotatedInterface.simpleName») «nativeType».loadLibrary("«libname»", «annotatedInterface.simpleName».class)'''
				]
		]

	}

}
