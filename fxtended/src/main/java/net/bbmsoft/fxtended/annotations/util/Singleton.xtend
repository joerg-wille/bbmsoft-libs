package net.bbmsoft.fxtended.annotations.util

import java.util.List
import org.eclipse.xtend.lib.macro.Active
import org.eclipse.xtend.lib.macro.TransformationContext
import org.eclipse.xtend.lib.macro.TransformationParticipant
import org.eclipse.xtend.lib.macro.declaration.MutableClassDeclaration
import org.eclipse.xtend.lib.macro.declaration.Visibility
import org.eclipse.xtend.lib.macro.declaration.MutableConstructorDeclaration

@Active(SingletonCompilationParticipant)
annotation Singleton {
	
}

class SingletonCompilationParticipant implements TransformationParticipant<MutableClassDeclaration> {
	

	private extension TransformationContext contetxt
	
	override void doTransform(List<? extends MutableClassDeclaration> classes, TransformationContext context) {
		
		this.contetxt = context
		
		classes.forEach [clazz |
			
			val classType = clazz.newTypeReference
			
			val instanceField = clazz.findInstanceFiled
			
			if(instanceField === null) {
				clazz.addField("instance")[
					visibility = Visibility.PRIVATE
					static = true
					final = true
					type = classType
					initializer = ['''new «clazz.simpleName»()''']
				]
			}
			
			clazz.addMethod("getInstance")[
				static = true
				final = true
				returnType = classType
				body = ['''return instance;''']
			]
			
			clazz.declaredConstructors.forEach[check(clazz)]
			
			if(clazz.declaredConstructors.size == 0) {
				clazz.addConstructor[
					visibility = Visibility.PRIVATE
					body = ['''''']
				]
			}
		]
	}
	
	def findInstanceFiled(MutableClassDeclaration clazz) {
		clazz.declaredFields.findFirst[it.simpleName == 'instance'] => [
			if(it !== null) {
				if(!Visibility.PRIVATE.equals(visibility)) {
					addError("Instance of Singleton must be private")
				}
				if(!static) {
					addError("Instance of Singleton must be static")
				}
				if(!final) {
					addWarning("Instance of Singleton should be final")
				}
			}
		]
		
	}
	
	private def check(MutableConstructorDeclaration constructor, MutableClassDeclaration clazz) {
		
		println('''«constructor.declaringType.simpleName» constructor: Visibility: «constructor.visibility», number of arguments: «constructor.parameters.size»''')
		
		if(!Visibility.PRIVATE.equals(constructor.visibility) && constructor.parameters.size == 0) {
			// default constructor
//			addWarning(constructor, "Singletons can't have public constructors, constructor will be removed!")
			constructor.remove
		}
		
		if(!Visibility.PRIVATE.equals(constructor.visibility)) {
			constructor.visibility = Visibility.PRIVATE
		}

		if(constructor.parameters.size > 0) {
			addError(constructor, "Singleton constructors cannot have parameters")
		}
	}
	
}