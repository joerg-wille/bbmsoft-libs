package net.bbmsoft.ui.properties;

import javafx.beans.InvalidationListener;
import javafx.beans.property.DoubleProperty;
import javafx.beans.property.SimpleDoubleProperty;
import javafx.beans.value.ChangeListener;
import javafx.beans.value.ObservableValue;
import net.bbmsoft.ui.properties.impl.UiPropertyHelper;

public class DoubleUiProperty extends DoubleProperty {

	private final DoubleProperty delegateProperty;
	private final UiPropertyHelper<Number> helper;

	public DoubleUiProperty() {
		delegateProperty = new SimpleDoubleProperty();
		helper = new UiPropertyHelper<>(delegateProperty);
	}

	public DoubleUiProperty(double initialValue) {
		delegateProperty = new SimpleDoubleProperty(initialValue);
		helper = new UiPropertyHelper<>(delegateProperty);
	}

	public DoubleUiProperty(Object bean, String name) {
		delegateProperty = new SimpleDoubleProperty(bean, name);
		helper = new UiPropertyHelper<>(delegateProperty);
	}

	public DoubleUiProperty(Object bean, String name, double initialValue) {
		delegateProperty = new SimpleDoubleProperty(bean, name, initialValue);
		helper = new UiPropertyHelper<>(delegateProperty);
	}

	public DoubleUiProperty(DoubleProperty property) {
		this.delegateProperty = property;
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
	public double get() {
		return delegateProperty.get();
	}

	@Override
	public void set(double value) {
		helper.update(value);
	}

}
