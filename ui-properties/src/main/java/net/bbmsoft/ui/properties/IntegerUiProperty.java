package net.bbmsoft.ui.properties;

import javafx.beans.InvalidationListener;
import javafx.beans.property.IntegerProperty;
import javafx.beans.property.SimpleIntegerProperty;
import javafx.beans.value.ChangeListener;
import javafx.beans.value.ObservableValue;
import net.bbmsoft.ui.properties.impl.UiPropertyHelper;

public class IntegerUiProperty extends IntegerProperty {

	private final IntegerProperty delegateProperty;
	private final UiPropertyHelper<Number> helper;

	public IntegerUiProperty() {
		delegateProperty = new SimpleIntegerProperty();
		helper = new UiPropertyHelper<>(delegateProperty);
	}

	public IntegerUiProperty(int initialValue) {
		delegateProperty = new SimpleIntegerProperty(initialValue);
		helper = new UiPropertyHelper<>(delegateProperty);
	}

	public IntegerUiProperty(Object bean, String name) {
		delegateProperty = new SimpleIntegerProperty(bean, name);
		helper = new UiPropertyHelper<>(delegateProperty);
	}

	public IntegerUiProperty(Object bean, String name, int initialValue) {
		delegateProperty = new SimpleIntegerProperty(bean, name, initialValue);
		helper = new UiPropertyHelper<>(delegateProperty);
	}

	public IntegerUiProperty(IntegerProperty property) {
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
	public int get() {
		return delegateProperty.get();
	}

	@Override
	public void set(int value) {
		helper.update(value);
	}

}
