package net.bbmsoft.fx.osk;

import java.rmi.Remote;
import java.rmi.RemoteException;

public interface RemoteOskFxNodeConnector extends Remote {

	public abstract void setText(String value) throws RemoteException;

	public abstract void setCaretPosition(int value) throws RemoteException;

	public abstract void selectRange(int start, int end) throws RemoteException;

	public abstract void enter() throws RemoteException;
}
