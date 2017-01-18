package net.bbmsoft.bbm.rest.processor

import java.io.IOException
import java.util.List
import java.util.regex.Matcher
import java.util.regex.Pattern
import javax.servlet.ServletException
import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse
import net.bbmsoft.bbm.rest.AbstractFileHandler
import net.bbmsoft.bbm.rest.Get
import org.eclipse.jetty.server.Request
import org.eclipse.xtend.lib.macro.TransformationContext
import org.eclipse.xtend.lib.macro.TransformationParticipant
import org.eclipse.xtend.lib.macro.declaration.MutableClassDeclaration
import org.eclipse.xtend.lib.macro.declaration.MutableMethodDeclaration
import org.eclipse.xtend.lib.macro.declaration.Type
import org.slf4j.LoggerFactory

class HttpHandlerProcessor implements TransformationParticipant<MutableClassDeclaration> {

	extension TransformationContext context

	override doTransform(List<? extends MutableClassDeclaration> annotatedTargetElements,
		TransformationContext context) {

		this.context = context

		val httpGet = Get.findTypeGlobally
		for (clazz : annotatedTargetElements) {

			clazz.extendedClass = AbstractFileHandler.newTypeReference
			val annotatedMethods = clazz.declaredMethods.filter[findAnnotation(httpGet)?.getValue('value') != null]

			// add and implement the Jetty's handle method
			clazz.addMethod('handle') [
				returnType = primitiveVoid
				addParameter('target', string)
				addParameter('baseRequest', Request.newTypeReference)
				addParameter('request', HttpServletRequest.newTypeReference)
				addParameter('response', HttpServletResponse.newTypeReference)

				setExceptions(IOException.newTypeReference, ServletException.newTypeReference)

				body = [
					'''
						«FOR m : annotatedMethods»
							{
								«toJavaCode(Matcher.newTypeReference)» matcher =
										«toJavaCode(Pattern.newTypeReference)»
										.compile("«m.getPattern(httpGet)»").matcher(target);
								if (matcher.matches()) {
									«var i = 0»
									«FOR v : m.getVariables(httpGet)»
										String «v» = matcher.group(«i=i+1»);
									«ENDFOR»
									response.setContentType("text/html;charset=utf-8");
									response.setStatus(HttpServletResponse.SC_OK);
									String result = String.valueOf(«m.simpleName»(«m.getVariables(httpGet).map[it+', '].join»target, baseRequest, request, response));
									if(result != null) {
										response.getWriter().println(result);
										baseRequest.setHandled(true);
										«toJavaCode(LoggerFactory.newTypeReference)».getLogger(this.getClass()).trace("Request handled by {}", this.getClass());
									}
								}
							}
						«ENDFOR»
					'''
				]
			]

			// enhance the handler methods
			for (m : annotatedMethods) {
				for (variable : m.getVariables(httpGet)) {
					m.addParameter(variable, string)
				}
				m.addParameter('target', string)
				m.addParameter('baseRequest', Request.newTypeReference)
				m.addParameter('request', HttpServletRequest.newTypeReference)
				m.addParameter('response', HttpServletResponse.newTypeReference)
			}
		}
	}

	private def getAnnotationValue(MutableMethodDeclaration m, Type annotationType) {
		m.findAnnotation(Get.newTypeReference.type).getValue('value').toString
	}

	private def extractMethodName(MutableMethodDeclaration m, Type annotationType) {
		m.getAnnotationValue(annotationType).split('/:').get(0).replace('/', '\\\\/')
	}

	private def Iterable<String> getVariables(MutableMethodDeclaration m, Type annotationType) {

		val strg = m.getAnnotationValue(annotationType)

		val split = strg.split('/:')

		if(split.length > 0) split.subList(1, split.length) else #[]
	}

	private def String getPattern(MutableMethodDeclaration m, Type annotationType) {

		val methodName = m.extractMethodName(annotationType)
		val variables = m.getVariables(annotationType)

		'''^«methodName»«FOR v : variables»\\/([^\\/]+?)«ENDFOR»\\/?$'''
	}
}
