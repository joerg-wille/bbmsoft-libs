package net.bbmsoft.fxtended.annotations.app

import java.lang.annotation.Target
import javafx.application.Application
import org.eclipse.xtend.lib.macro.AbstractClassProcessor
import org.eclipse.xtend.lib.macro.Active
import org.eclipse.xtend.lib.macro.TransformationContext
import org.eclipse.xtend.lib.macro.declaration.MutableClassDeclaration
import org.eclipse.xtend.lib.macro.declaration.Visibility

@Target(TYPE)
@Active(AppCompilationParticipant)
annotation App {
}

class AppCompilationParticipant extends AbstractClassProcessor {

	override doTransform(MutableClassDeclaration it, extension TransformationContext context) {

		val annotation = findAnnotation(findTypeGlobally(App))

		val parentTRef = extendedClass

		val appRef = Application.newTypeReference

		if(appRef == null) {
			annotation.addError('''Required class javafx.application.Application is not on the classpath.''')
			return
		}

		if (parentTRef != Object.newTypeReference && parentTRef != appRef) {
			annotation.addError('''Application classes can only be derived from «Application» or directly from «Object.name». This class extends «parentTRef.name».''')
			return
		}

		if (declaredMethods.exists[simpleName == 'main']) {
			annotation.addError('''This class already contains a method called 'main'.''')
			return
		}

		extendedClass = appRef

		addMethod('main') [
			visibility = Visibility.PUBLIC
			static = true
			addParameter('args', newArrayTypeReference(String.newTypeReference))
			body = [

				val application = toJavaCode(Application.newTypeReference)

				'''«application».launch(args);'''
			]
		]
	}
}
