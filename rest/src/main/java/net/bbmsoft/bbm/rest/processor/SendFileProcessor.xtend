package net.bbmsoft.bbm.rest.processor

import org.eclipse.xtend.lib.macro.AbstractMethodProcessor
import org.eclipse.xtend.lib.macro.declaration.MutableMethodDeclaration
import org.eclipse.xtend.lib.macro.TransformationContext
import net.bbmsoft.bbm.rest.SendFile
import org.eclipse.xtend.lib.macro.declaration.Visibility

class SendFileProcessor extends AbstractMethodProcessor {

	override doTransform(MutableMethodDeclaration annotatedMethod, extension TransformationContext context) {


			val sendFile = SendFile.findTypeGlobally
			val fileName = annotatedMethod.findAnnotation(sendFile)?.getValue('value')

			val declaringType = annotatedMethod.declaringType
			val declaredMethodNames = declaringType.declaredMethods.map[simpleName].toList

			var delegateMethodNameCandidate = annotatedMethod.simpleName
			while(declaredMethodNames.contains(delegateMethodNameCandidate)) {
				delegateMethodNameCandidate = '_' + delegateMethodNameCandidate
			}

			val delegateMethodName = delegateMethodNameCandidate

			declaringType.addMethod(delegateMethodName) [
				visibility = Visibility.PRIVATE
				final = true
				returnType = annotatedMethod.returnType
				static = annotatedMethod.static
				body = annotatedMethod.body

				annotatedMethod.parameters.forEach[p|
					addParameter(p.simpleName, p.type)
				]
			]

			annotatedMethod.body = '''
				this.«delegateMethodName»(«annotatedMethod.parameters.map[simpleName].reduce['''«$0», «$1»''']»);
				return this.readFile("«fileName»");
			'''

			annotatedMethod.returnType = String.newTypeReference
	}

}