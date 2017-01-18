package net.bbmsoft.ui.properties;

import javafx.beans.InvalidationListener;
import javafx.beans.property.LongProperty;
import javafx.beans.property.SimpleLongProperty;
import javafx.beans.value.ChangeListener;
import javafx.beans.value.ObservableValue;
import net.bbmsoft.ui.properties.impl.UiPropertyHelper;

public class LongUiProperty extends LongProperty {

	private final LongProperty delegateProperty;
	private final UiPropertyHelper<Number> helper;

	public LongUiProperty() {
		delegateProperty = new SimpleLongProperty();
		helper = new UiPropertyHelper<>(delegateProperty);
	}

	public LongUiProperty(long initialValue) {
		delegateProperty = new SimpleLongProperty(initialValue);
		helper = new UiPropertyHelper<>(delegateProperty);
	}

	public LongUiProperty(Object bean, String name) {
		delegateProperty = new SimpleLongProperty(bean, name);
		helper = new UiPropertyHelper<>(delegateProperty);
	}

	public LongUiProperty(Object bean, String name, long initialValue) {
		delegateProperty = new SimpleLongProperty(bean, name, initialValue);
		helper = new UiPropertyHelper<>(delegateProperty);
	}

	public LongUiProperty(LongProperty property) {
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
	public long get() {
		return delegateProperty.get();
	}

	@Override
	public void set(long value) {
		helper.update(value);
	}

}
