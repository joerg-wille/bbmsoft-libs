package net.bbmsoft.fx.osk;

public interface NodeAttachableVirtualKeyboard {

	public abstract void requestInputIndicatorFocus();

	public abstract void setIndicatorText(String text);

	public abstract void setIndicatorSelection(int start, int end);

}
