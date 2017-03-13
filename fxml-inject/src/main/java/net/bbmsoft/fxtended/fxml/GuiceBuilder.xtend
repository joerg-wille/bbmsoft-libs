package net.bbmsoft.fxtended.fxml

import com.google.inject.Injector
import com.sun.javafx.fxml.BeanAdapter
import java.lang.reflect.Array
import java.lang.reflect.Method
import java.util.AbstractMap
import java.util.ArrayList
import java.util.Arrays
import java.util.HashMap
import java.util.HashSet
import java.util.List
import java.util.Map
import java.util.Set
import javafx.collections.FXCollections
import javafx.collections.ObservableList
import javafx.collections.ObservableMap
import javafx.fxml.FXMLLoader
import javafx.scene.Node
import javafx.util.Builder

class GuiceBuilder<T> extends AbstractMap<String, Object> implements Builder<T> {

//	static val stringConverters = <Class<?>, Class<? extends StringConverter<?>>>newHashMap(
//		String -> DefaultStringConverter,
//		boolean -> BooleanStringConverter,
//		byte -> ByteStringConverter,
//		double -> DoubleStringConverter,
//		float -> FloatStringConverter,
//		int -> IntegerStringConverter,
//		long -> LongStringConverter,
//		short -> ShortStringConverter,
//		Boolean -> BooleanStringConverter,
//		Byte -> ByteStringConverter,
//		Double -> DoubleStringConverter,
//		Float -> FloatStringConverter,
//		Integer -> IntegerStringConverter,
//		Long -> LongStringConverter,
//		Short -> ShortStringConverter,
//		BigDecimal -> BigDecimalStringConverter,
//		BigInteger -> BigIntegerStringConverter
//	)

	final extension Injector injector
	final Class<T> type
	final Map<String, Object> containers
	final Map<String, Method> setters
	final Map<String, Method> getters
	final Map<String, Method> methods

	Map<Object, Object> properties

	new(Injector injector, Class<T> type) {

		this.injector = injector
		this.type = type

		this.properties = newHashMap
		this.containers = newHashMap
		this.setters = newHashMap
		this.getters = newHashMap
		this.methods = newHashMap
	}

	override build() {

		containers.forEach [ k, v |
			put(k, v)
		]

		val instance = type.instance

		if (instance instanceof Node) {
			instance.properties.putAll(properties)
		}

		properties.forEach [ key, value |

			if (value instanceof List<?>) {
				val list = getters.get(key).invoke(instance) as List
				list.addAll = value
			} else if (value instanceof Map<?, ?>) {
				val map = getters.get(key).invoke(instance) as Map
				map.putAll = value
			} else {
				setters.get(key).invoke(instance, value)
			}
		]

		properties.clear
		containers.clear
		setters.clear
		getters.clear

		return instance
	}

	override put(String key, Object value) {

		if (Node.isAssignableFrom(type) && "properties".equals(key)) {
			properties = value as Map<Object, Object>
			return null;
		}

		try {

			getReadOnlyProperty(key)

			val setter = setters.get(key)
			val getter = getters.get(key)

			val type = if(setter !== null) setter.parameterTypes.head else if(getter !== null) getter.returnType

			if (type !== null) {
				try {
					val theValue = if (type.array) {
							val List<?> list = if (value instanceof List<?>) {
									value as List<?>
								} else {
									Arrays.asList(value.toString().split(FXMLLoader.ARRAY_COMPONENT_DELIMITER));
								}

							val Class<?> componentType = type.getComponentType();
							val Object array = Array.newInstance(componentType, list.size());
							for (i : 0 ..< list.size) {
								Array.set(array, i, BeanAdapter.coerce(list.get(i), componentType));
							}
							array;
						} else
							value

					val coercedValue = BeanAdapter.coerce(theValue, type)

					properties.put(key, coercedValue)
				} catch (Exception e) {
					e.printStackTrace
				}
			}
			return null;
		} catch (Exception e) {
			e.printStackTrace
			return null;
		}
	}

	override entrySet() {
		throw new UnsupportedOperationException
	}

	override containsKey(Object key) {
		getTemporaryContainer(key.toString) !== null
	}

	override get(Object key) {
		getTemporaryContainer(key.toString)
	}

	/**
	 * This is used to support read-only collection property.
	 * This method must return a Collection of the appropriate type
	 * if 1. the property is read-only, and 2. the property is a collection.
	 * It must return null otherwise.
	 **/
	def Object getTemporaryContainer(String propName) {

		val o = containers.get(propName) ?: getReadOnlyProperty(propName) => [
			if(it instanceof Iterable<?>) containers.put(propName, it)
		]

		return o;
	}

	private def Object getReadOnlyProperty(String propName) {

		if(setters.get(propName) !== null) return null;

		var getter = getters.get(propName);

		if (getter === null) {

			var Method setter = null;
			val suffix = Character.toUpperCase(propName.charAt(0)) + propName.substring(1);

			try {
				getter = type.method('''get«suffix»''', #[])
				setter = type.method('''set«suffix»''', #[getter.returnType])
			} catch (Exception x) {
			}
			if (getter !== null) {
				getters.put(propName, getter);
				setters.put(propName, setter);
			}
			if(setter !== null) return null;
		}

		var Class<?> type
		if (getter === null) {
			val Method m = findMethod(propName)
			if (m === null) {
				return null
			}
			type = m.parameterTypes.head
			if(type.array) type = List
		} else {
			type = getter.returnType
		}

		if (ObservableMap.isAssignableFrom(type)) {
			return FXCollections.observableMap(new HashMap<Object, Object>());
		} else if (Map.isAssignableFrom(type)) {
			return new HashMap<Object, Object>();
		} else if (ObservableList.isAssignableFrom(type)) {
			return FXCollections.observableArrayList();
		} else if (List.isAssignableFrom(type)) {
			return new ArrayList<Object>();
		} else if (Set.isAssignableFrom(type)) {
			return new HashSet<Object>();
		}
		return null;
	}

	private def Method findMethod(String name) {

		val theName = if (name.length() > 1 && Character.isUpperCase(name.charAt(1))) {
				Character.toUpperCase(name.charAt(0)) + name.substring(1);
			} else {
				name
			}

		for (Method m : type.methods) {
			if (m.getName().equals(theName)) {
				return m;
			}
		}
		throw new IllegalArgumentException('''Method «theName» could not be found at class «type.simpleName»''');
	}

	private def Method method(Class<T> clazz, String string, List<Class<?>> types) {

		val allMethods = clazz.methods
		val filteredByName = allMethods.filter[name == string]
		val filteredByArgs = filteredByName.filter[argsMatch(types)]

		filteredByArgs.head
	}

	private def argsMatch(Method it, List<Class<?>> types) {
		parameterTypes.empty && types.empty ||
		types.containsAll(parameterTypes) && parameterTypes.containsAll(types)
	}

}
