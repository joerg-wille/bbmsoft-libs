package net.bbmsoft.fx.osk;

import java.rmi.Remote;
import java.rmi.RemoteException;

public interface RemoteNodeAttachableKeyboard extends Remote {

	public abstract void requestInputIndicatorFocus() throws RemoteException;

	public abstract void setIndicatorText(String text) throws RemoteException;

	public abstract void setIndicatorSelection(int start, int end) throws RemoteException;
}
