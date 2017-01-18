package net.bbmsoft.keyboard.remote;

import java.rmi.Remote;
import java.rmi.RemoteException;

import net.bbmsoft.keyboard.KeyCode;
import net.bbmsoft.keyboard.KeyMap;
import net.bbmsoft.keyboard.ScanCodeSet;

public interface RemoteVirtualKeyboardController extends Remote {

	public interface Listener extends Remote {

		public abstract void fireMake(KeyCode keyCode, int[] makeCode, boolean typematic) throws RemoteException;

		public abstract void fireBreak(KeyCode keyCode, int[] breakCode) throws RemoteException;

	}

	public abstract void addListener(Listener listener) throws RemoteException;

	public abstract void armListener(Listener listener) throws RemoteException;

	public abstract void removeListener(Listener listener) throws RemoteException;

	public abstract void setTypeMaticEnabled(boolean value) throws RemoteException;

	public abstract boolean isTypeMaticEnabled() throws RemoteException;

	public abstract void setTypeMaticDelay(long value) throws RemoteException;

	public abstract long getTypeMaticDelay() throws RemoteException;

	public abstract void setTypeMaticRate(double value) throws RemoteException;

	public abstract double getTypeMaticRate() throws RemoteException;

	public abstract void setScanCodeSet(ScanCodeSet value) throws RemoteException;

	public abstract ScanCodeSet getScanCodeSet() throws RemoteException;

	public abstract void showShiftDown(boolean value) throws RemoteException;

	public abstract void showCtrlDown(boolean value) throws RemoteException;

	public abstract void showAltDown(boolean value) throws RemoteException;

	public abstract void showAltGraphDown(boolean value) throws RemoteException;

	public abstract void showOsDown(boolean value) throws RemoteException;

	public abstract void showCapsLockOn(boolean value) throws RemoteException;

	public abstract void showNumLockOn(boolean value) throws RemoteException;

	public abstract void showScrollLockOn(boolean value) throws RemoteException;

	public abstract void setKeyMap(KeyMap value) throws RemoteException;
}
