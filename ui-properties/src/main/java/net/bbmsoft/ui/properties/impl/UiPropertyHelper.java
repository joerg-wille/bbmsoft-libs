package net.bbmsoft.ui.properties.impl;

import java.util.concurrent.atomic.AtomicReference;

import javafx.application.Platform;
import javafx.beans.value.WritableValue;

public class UiPropertyHelper<T> {

	private final WritableValue<T> property;
	private final AtomicReference<T> atomicRef;

	public UiPropertyHelper(WritableValue<T> prop) {
		this.property = prop;
		atomicRef = new AtomicReference<>();
	}

	public void update(T value) {

		runFast(value);
	}

	private void runFast(T value) {

		if (isFxApplicationThread()) {
			doUpdate(value);
		} else if (atomicRef.getAndSet(value) == null) {
			runLater(() -> {
				T update = atomicRef.getAndSet(null);
				doUpdate(update);
			});
		}
	}

	private void doUpdate(T value) {
		property.setValue(value);
	}

	private boolean isFxApplicationThread() {
		return Platform.isFxApplicationThread();
	}

	private void runLater(Runnable run) {
		Platform.runLater(run);
	}
}
