package net.bbmsoft.fx.osk.impl

import java.rmi.RemoteException
import net.bbmsoft.fx.osk.NodeAttachableVirtualKeyboard
import net.bbmsoft.fx.osk.RemoteNodeAttachableKeyboard

class RemoteNodeAttachableKeyboardWrapper implements NodeAttachableVirtualKeyboard {

	final RemoteNodeAttachableKeyboard remoteNodeAttachable

	boolean offline

	new(RemoteNodeAttachableKeyboard remoteNodeAttachable) {
		this.remoteNodeAttachable = remoteNodeAttachable
	}

	override requestInputIndicatorFocus() {
		if (!offline) {
			try {
				this.remoteNodeAttachable.requestInputIndicatorFocus
			} catch (RemoteException e) {
				this.offline = true
			}
		}
	}

	override setIndicatorSelection(int start, int end) {
		if (!offline) {
			try {
				this.remoteNodeAttachable.setIndicatorSelection(start, end)
			} catch (RemoteException e) {
				this.offline = true
			}
		}
	}

	override setIndicatorText(String text) {
		if (!offline) {
			try {

				this.remoteNodeAttachable.indicatorText = text
			} catch (RemoteException e) {
				this.offline = true
			}
		}
	}

}
