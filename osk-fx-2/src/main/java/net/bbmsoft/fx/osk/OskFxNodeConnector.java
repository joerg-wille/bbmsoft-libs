package net.bbmsoft.fx.osk;

import javafx.scene.Node;
import javafx.scene.Scene;
import javafx.stage.Window;

public interface OskFxNodeConnector {

	public abstract void setText(String value);

	public abstract void setCaretPosition(int value);

	public abstract void selectRange(int start, int end);

	public abstract void enter();

	public abstract void attach(Window window);

	public abstract void attach(Scene scene);

	public abstract void attach(Node target);

	public abstract void detach();
}
