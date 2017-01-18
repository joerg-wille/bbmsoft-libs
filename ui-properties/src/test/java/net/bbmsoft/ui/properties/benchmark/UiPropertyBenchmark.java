package net.bbmsoft.ui.properties.benchmark;

import javafx.application.Application;
import javafx.application.Platform;
import javafx.beans.property.DoubleProperty;
import javafx.geometry.Insets;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.CheckBox;
import javafx.scene.control.Slider;
import javafx.scene.layout.GridPane;
import javafx.stage.Stage;
import net.bbmsoft.ui.properties.DoubleUiProperty;

public class UiPropertyBenchmark extends Application {

	// these are used to measure the time the visible animation takes
	private long animationStart;
	private long animationEnd;

	public static void main(String[] args) {
		// Launch FXApplication
		launch(args);
	}

	// moved the UI initialization to the bottom,
	// THIS IS THE INTERESTING PART

	private void animate(DoubleProperty sliderValue, boolean optimized) {

		DoubleProperty theProperty;

		// first make sure, the slider's value isn't bound to anything
		sliderValue.unbind();

		// since the optimization is encapsuled in a custom Property
		// implementation,
		// we cannot directly manipulate the slider's value but bind it to the
		// optimized property instead and manipulate that one
		if (optimized) {
			theProperty = new DoubleUiProperty();
			sliderValue.bind(theProperty);
		} else {
			theProperty = sliderValue;
		}

		// reset the slider to 0.0
		theProperty.set(0);

		// the trick is that the UiProperty internally delegates calls to the FX
		// Application Thread
		// in a quite efficient way, so using it also eliminates the need to set
		// the property
		// explicitly from the UI Thread
		boolean callOnFXThread = !optimized;

		// The animation loop will run on a background thread, of course
		new Thread(() -> doAnimate(theProperty, callOnFXThread)).start();
	}

	private void doAnimate(DoubleProperty theProperty, boolean callOnFXThread) {

		// give the user a moment to realize the slider has been reset and the
		// animation is about to start
		// technically, this sleep is not required; purely user experience
		// optimization
		try {
			Thread.sleep(200);
		} catch (InterruptedException e) {
			e.printStackTrace();
		}

		// one million loops show the effect very clearly even on fast PCs. On
		// slower machines
		// this might really take a while so you may want to reduce this a bit
		int loops = 1000000;

		System.out.println("Start");

		animationStart = System.currentTimeMillis();

		// this measures the time the animation loop takes to complete
		// note that this may greatly differ from the time the actually visible
		// animation in the UI takes, especially in the unoptimized version
		long loopStart = System.currentTimeMillis();

		// the actual loop
		for (double i = 0; i < loops; i++) {

			double value = i / loops;

			setValue(theProperty, callOnFXThread, value);
		}

		setValue(theProperty, callOnFXThread, 1.0);

		// measure and print time results
		long loopEnd = System.currentTimeMillis();

		System.out.println("Done.");

		System.out.println("Loop duration: " + ((loopEnd - loopStart) / 1000d)
				+ " s");
	}

	private void setValue(DoubleProperty theProperty, boolean callOnFXThread,
			double value) {

		// again, note that the UiProperty is NOT (and should not be) set using
		// Platform.runLater,
		// even though the call caomes from a background thread.
		if (callOnFXThread) {
			Platform.runLater(() -> theProperty.setValue(value));
		} else {
			theProperty.setValue(value);
		}
	}

	// just some UI building stuff here, not that interesting

	@Override
	public void start(Stage primaryStage) throws Exception {

		Scene scene = buildScene();

		primaryStage.setScene(scene);
		primaryStage.show();

	}

	private Scene buildScene() {
		Slider slider = new Slider();
		slider.setMin(0.0);
		slider.setMax(1.0);

		// this is used for benchmarking the time it takes to move the slider's
		// value
		// once through its entire range
		slider.valueProperty().addListener(
				(o, oldVal, newVal) -> {
					if (newVal.doubleValue() == 1.0) {
						animationEnd = System.currentTimeMillis();
						System.out.println("Slider update time: "
								+ ((animationEnd - animationStart) / 1000d)
								+ " s");
					}
				});

		CheckBox check = new CheckBox("Optimized property");

		Button button = new Button("Run");
		button.setOnAction(e -> animate(slider.valueProperty(),
				check.isSelected()));

		GridPane container = makeLayout(slider, check, button);

		Scene scene = new Scene(container);
		return scene;
	}

	private GridPane makeLayout(Slider slider, CheckBox check, Button button) {
		GridPane.setColumnIndex(slider, 0);
		GridPane.setRowIndex(slider, 0);
		GridPane.setColumnSpan(slider, 2);
		GridPane.setColumnIndex(check, 0);
		GridPane.setRowIndex(check, 1);
		GridPane.setColumnIndex(button, 1);
		GridPane.setRowIndex(button, 1);
		GridPane container = new GridPane();
		container.getChildren().addAll(slider, check, button);
		container.setHgap(5);
		container.setVgap(5);
		container.setPadding(new Insets(5));
		return container;
	}
}
