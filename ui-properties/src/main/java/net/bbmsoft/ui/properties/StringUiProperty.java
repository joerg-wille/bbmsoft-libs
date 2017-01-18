package net.bbmsoft.ui.properties;

import net.bbmsoft.ui.properties.impl.UiPropertyHelper;
import javafx.beans.InvalidationListener;
import javafx.beans.property.StringProperty;
import javafx.beans.property.SimpleStringProperty;
import javafx.beans.value.ChangeListener;
import javafx.beans.value.ObservableValue;

public class StringUiProperty extends StringProperty {

	private final StringProperty delegateProperty;
	private final UiPropertyHelper<String> helper;

	public StringUiProperty() {
		delegateProperty = new SimpleStringProperty();
		helper = new UiPropertyHelper<>(delegateProperty);
	}

	public StringUiProperty(String initialValue) {
		delegateProperty = new SimpleStringProperty(initialValue);
		helper = new UiPropertyHelper<>(delegateProperty);
	}

	public StringUiProperty(Object bean, String name) {
		delegateProperty = new SimpleStringProperty(bean, name);
		helper = new UiPropertyHelper<>(delegateProperty);
	}

	public StringUiProperty(Object bean, String name, String initialValue) {
		delegateProperty = new SimpleStringProperty(bean, name, initialValue);
		helper = new UiPropertyHelper<>(delegateProperty);
	}

	public StringUiProperty(StringProperty property) {
		delegateProperty = property;
		helper = new UiPropertyHelper<>(delegateProperty);
	}

	@Override
	public void bind(ObservableValue<? extends String> observable) {
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
	public void addListener(ChangeListener<? super String> listener) {
		delegateProperty.addListener(listener);
	}

	@Override
	public void removeListener(ChangeListener<? super String> listener) {
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
	public String get() {
		return delegateProperty.get();
	}

	@Override
	public void set(String value) {
		helper.update(value);
	}

}
