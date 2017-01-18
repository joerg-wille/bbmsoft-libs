package net.bbmsoft.fxtended.extensions

import java.util.function.Function

class LanguageExtensions {

	def static <T extends AutoCloseable, R> R tryWith(Iterable<()=>T> resourceProviders, (Iterable<T>)=>R procedure) {

		val resources = newArrayList

		for (resourceProvider : resourceProviders) {
			try {
				resources.add = resourceProvider.apply
			} catch (Throwable e) {
				for (it : resources) {
					try {
						close
					} catch (Throwable e2) {
						e2.printStackTrace
					}
				}
				throw e
			}
		}

		try {
			return procedure.apply(resources)
		} finally {
			for (it : resources) {
				try {
					close
				} catch (Throwable e2) {
					e2.printStackTrace
				}
			}
		}
	}

	def static <T extends AutoCloseable> void tryWith(Iterable<()=>T> resourceProviders,
		(Iterable<T>)=>void procedure) {

		val resources = newArrayList

		for (resourceProvider : resourceProviders) {
			try {
				resources.add = resourceProvider.apply
			} catch (Throwable e) {
				for (it : resources) {
					try {
						close
					} catch (Throwable e2) {
						e2.printStackTrace
					}
				}
				throw e
			}
		}

		try {
			procedure.apply(resources)
		} finally {
			for (it : resources) {
				try {
					close
				} catch (Throwable e2) {
					e2.printStackTrace
				}
			}
		}
	}

	def static <T extends AutoCloseable, R> R tryWith(T resource, (T)=>R procedure) {

		var Throwable mainThrowable = null

		try {
			procedure.apply(resource)
		} catch (Throwable e) {
			mainThrowable = e
			throw e
		} finally {
			if (mainThrowable != null) {
				resource.close
			} else {
				try {
					resource.close
				} catch (Throwable unused) {
					// ignore
				}
			}
		}
	}

	def static <T extends AutoCloseable> void tryWith(T resource, (T)=>void procedure) {

		var Throwable mainThrowable = null

		try {
			procedure.apply(resource)
		} catch (Throwable e) {
			mainThrowable = e
			throw e
		} finally {
			if (mainThrowable != null) {
				resource.close
			} else {
				try {
					resource.close
				} catch (Throwable unused) {
					// ignore
				}
			}
		}
	}

	def static <T extends AutoCloseable> void tryWith(()=>T resourceProvider, (T)=>void procedure) {

		var T resource = null

		try {
			resource = resourceProvider.apply
			procedure.apply(resource)
		} catch (Throwable e) {
			// ignore
		} finally {
			resource?.close
		}
	}

	def static <T extends AutoCloseable, R, E extends Throwable> R tryWith(()=>T resourceProvider, (T)=>R procedure,
		Pair<Class<E>, (E)=>R> handler) {

		var T resource = null

		try {
			resource = resourceProvider.apply
			procedure.apply(resource)
		} catch (Throwable e) {
			if (handler != null && handler.key.isAssignableFrom(e.class)) {
				handler.value.apply(handler.key.cast(e))
			}
		} finally {
			resource?.close
		}
	}

	/**
	 * Get the root of an object within a tree structure of type T
	 */
	def static <T> T getRoot(T object, Function<T, T> getParent) {

		var T it = null
		var T parent = object

		while (parent != null) {
			it = parent
			parent = getParent.apply(it)
		}

		it
	}
}
