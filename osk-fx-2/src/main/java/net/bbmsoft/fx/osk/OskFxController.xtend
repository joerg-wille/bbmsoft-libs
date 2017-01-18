package net.bbmsoft.fx.osk

import net.bbmsoft.fxtended.annotations.binding.BindableProperty
import net.bbmsoft.fxtended.annotations.binding.Lazy
import net.bbmsoft.keyboard.ScanCodeSet
import net.bbmsoft.keyboard.impl.VirtualKeyboardControllerBase
import org.eclipse.xtend.lib.annotations.Accessors

import static extension javafx.application.Platform.runLater

class OskFxController extends VirtualKeyboardControllerBase implements OskController {

	@Accessors final OskFx virtualKeyboard

	@Lazy @BindableProperty ScanCodeSet scanCodeSet
	@Lazy @BindableProperty long typeMaticDelay
	@Lazy @BindableProperty double typeMaticRate
	@Lazy @BindableProperty boolean typeMaticEnabled

	new(OskFx keyBoard) {

		super[runLater]

		this.virtualKeyboard = keyBoard

		this.scanCodeSet = ScanCodeSet.SET_USB
		this.typeMaticDelay = 750
		this.typeMaticRate = 20
		this.typeMaticEnabled = true
	}

	override getVirtualKeyboardVisualizer() {
		this.virtualKeyboard
	}

	override addNodeConnector(OskFxNodeConnector connector) {
		this.virtualKeyboard.nodeConnectors.add(connector)
	}

}
