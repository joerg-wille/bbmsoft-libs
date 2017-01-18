package net.bbmsoft.ui.properties;

import javafx.beans.InvalidationListener;
import javafx.beans.property.FloatProperty;
import javafx.beans.property.SimpleFloatProperty;
import javafx.beans.value.ChangeListener;
import javafx.beans.value.ObservableValue;
import net.bbmsoft.ui.properties.impl.UiPropertyHelper;

public class FloatUiProperty extends FloatProperty {

	private final FloatProperty delegateProperty;
	private final UiPropertyHelper<Number> helper;

	public FloatUiProperty() {
		delegateProperty = new SimpleFloatProperty();
		helper = new UiPropertyHelper<>(delegateProperty);
	}

	public FloatUiProperty(float initialValue) {
		delegateProperty = new SimpleFloatProperty(initialValue);
		helper = new UiPropertyHelper<>(delegateProperty);
	}

	public FloatUiProperty(Object bean, String name) {
		delegateProperty = new SimpleFloatProperty(bean, name);
		helper = new UiPropertyHelper<>(delegateProperty);
	}

	public FloatUiProperty(Object bean, String name, float initialValue) {
		delegateProperty = new SimpleFloatProperty(bean, name, initialValue);
		helper = new UiPropertyHelper<>(delegateProperty);
	}

	public FloatUiProperty(FloatProperty property) {
		delegateProperty = property;
		helper = new UiPropertyHelper<>(delegateProperty);
	}

	@Override
	public void bind(ObservableValue<? extends Number> observable) {
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
	public void addListener(ChangeListener<? super Number> listener) {
		delegateProperty.addListener(listener);
	}

	@Override
	public void removeListener(ChangeListener<? super Number> listener) {
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
	public float get() {
		return delegateProperty.get();
	}

	@Override
	public void set(float value) {
		helper.update(value);
	}
}
