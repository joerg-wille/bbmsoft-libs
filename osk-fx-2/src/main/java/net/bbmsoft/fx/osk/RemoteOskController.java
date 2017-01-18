package net.bbmsoft.fx.osk;

import java.rmi.RemoteException;

import net.bbmsoft.keyboard.remote.RemoteVirtualKeyboardController;

public interface RemoteOskController extends RemoteVirtualKeyboardController {

	public abstract RemoteNodeAttachableKeyboard getNodeAttachable() throws RemoteException;

	public abstract void addNodeConnector(RemoteOskFxNodeConnector connector) throws RemoteException;

}
