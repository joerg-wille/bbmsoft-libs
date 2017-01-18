package net.bbmsoft.ui.properties;

import javafx.beans.InvalidationListener;
import javafx.beans.property.ObjectProperty;
import javafx.beans.property.SimpleObjectProperty;
import javafx.beans.value.ChangeListener;
import javafx.beans.value.ObservableValue;
import net.bbmsoft.ui.properties.impl.UiPropertyHelper;

public class ObjectUiProperty<T> extends ObjectProperty<T> {

	private final ObjectProperty<T> delegateProperty;
	private final UiPropertyHelper<T> helper;

	public ObjectUiProperty() {
		delegateProperty = new SimpleObjectProperty<T>();
		helper = new UiPropertyHelper<T>(delegateProperty);
	}

	public ObjectUiProperty(T initialValue) {
		delegateProperty = new SimpleObjectProperty<T>(initialValue);
		helper = new UiPropertyHelper<T>(delegateProperty);
	}

	public ObjectUiProperty(Object bean, String name) {
		delegateProperty = new SimpleObjectProperty<T>(bean, name);
		helper = new UiPropertyHelper<>(delegateProperty);
	}

	public ObjectUiProperty(Object bean, String name, T initialValue) {
		delegateProperty = new SimpleObjectProperty<T>(bean, name, initialValue);
		helper = new UiPropertyHelper<>(delegateProperty);
	}

	public ObjectUiProperty(ObjectProperty<T> property) {
		delegateProperty = property;
		helper = new UiPropertyHelper<>(delegateProperty);
	}

	@Override
	public void bind(ObservableValue<? extends T> observable) {
		delegateProperty.bind(observable);
	}

	@Override
	public void unbind() {
		delegateProperty.unbind();
	}

	@Override
	public boolean isBound() {
		return delegateProperty.isBound();
	}

	@Override
	public Object getBean() {
		return delegateProperty.getBean();
	}

	@Override
	public String getName() {
		return delegateProperty.getName();
	}

	@Override
	public void addListener(ChangeListener<? super T> listener) {
		delegateProperty.addListener(listener);
	}

	@Override
	public void removeListener(ChangeListener<? super T> listener) {
		delegateProperty.removeListener(listener);
	}

	@Override
	public void addListener(InvalidationListener listener) {
		delegateProperty.addListener(listener);
	}

	@Override
	public void removeListener(InvalidationListener listener) {
		delegateProperty.removeListener(listener);
	}

	@Override
	public T get() {
		return delegateProperty.get();
	}

	@Override
	public void set(T value) {
		helper.update(value);
	}
}
