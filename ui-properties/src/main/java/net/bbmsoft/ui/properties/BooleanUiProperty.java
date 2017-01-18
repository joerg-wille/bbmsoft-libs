package net.bbmsoft.ui.properties;

import net.bbmsoft.ui.properties.impl.UiPropertyHelper;
import javafx.beans.InvalidationListener;
import javafx.beans.property.BooleanProperty;
import javafx.beans.property.SimpleBooleanProperty;
import javafx.beans.value.ChangeListener;
import javafx.beans.value.ObservableValue;

public class BooleanUiProperty extends BooleanProperty {

	private final BooleanProperty delegateProperty;
	private final UiPropertyHelper<Boolean> helper;

	public BooleanUiProperty() {
		delegateProperty = new SimpleBooleanProperty();
		helper = new UiPropertyHelper<>(delegateProperty);
	}

	public BooleanUiProperty(boolean initialValue) {
		delegateProperty = new SimpleBooleanProperty(initialValue);
		helper = new UiPropertyHelper<>(delegateProperty);
	}

	public BooleanUiProperty(Object bean, String name) {
		delegateProperty = new SimpleBooleanProperty(bean, name);
		helper = new UiPropertyHelper<>(delegateProperty);
	}

	public BooleanUiProperty(Object bean, String name, boolean initialValue) {
		delegateProperty = new SimpleBooleanProperty(bean, name, initialValue);
		helper = new UiPropertyHelper<>(delegateProperty);
	}

	public BooleanUiProperty(BooleanProperty property) {
		delegateProperty = property;
		helper = new UiPropertyHelper<>(delegateProperty);
	}

	@Override
	public void bind(ObservableValue<? extends Boolean> observable) {
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
	public void addListener(ChangeListener<? super Boolean> listener) {
		delegateProperty.addListener(listener);
	}

	@Override
	public void removeListener(ChangeListener<? super Boolean> listener) {
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
	public boolean get() {
		return delegateProperty.get();
	}

	@Override
	public void set(boolean value) {
		helper.update(value);
	}

}
