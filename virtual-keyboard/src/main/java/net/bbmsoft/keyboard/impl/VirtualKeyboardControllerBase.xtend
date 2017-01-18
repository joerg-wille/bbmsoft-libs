package net.bbmsoft.keyboard.impl

import java.util.List
import java.util.concurrent.Executor
import java.util.concurrent.Executors
import java.util.concurrent.ScheduledFuture
import java.util.concurrent.TimeUnit
import net.bbmsoft.keyboard.KeyCode
import net.bbmsoft.keyboard.VirtualKeyboard
import net.bbmsoft.keyboard.VirtualKeyboardController

import static java.lang.Math.round
import static net.bbmsoft.keyboard.KeyCode.PAUSE
import static net.bbmsoft.keyboard.ScanCodeSet.*
import org.eclipse.xtend.lib.annotations.Accessors

/**
 * Base implementation of {@link VirtualKeyboardController}. This implementation
 * is NOT thread safe. It should only be used in a single threaded environment.
 */
abstract class VirtualKeyboardControllerBase implements VirtualKeyboardController, VirtualKeyboard.Listener {

	private static val typeMaticTimer = Executors.newSingleThreadScheduledExecutor [
		new Thread(it) => [daemon = true name = 'TypeMatic Timer']
	]

	@Accessors final Executor virtualKeyboardPlatformExecutor

	final List<VirtualKeyboardController.Listener> listeners

	ScheduledFuture<?> typematicFuture

	new(Executor virtualKeyboardPlatformExecutor) {
		this.virtualKeyboardPlatformExecutor = virtualKeyboardPlatformExecutor
		this.listeners = newArrayList
	}

	override pressed(KeyCode code) {

		this.typematicFuture?.cancel(false)

		val makeCode = code.toMakeCode

		if (typeMaticEnabled) {
			this.typematicFuture = typeMaticTimer.scheduleAtFixedRate([
				virtualKeyboardPlatformExecutor.execute[fireMake(code, makeCode, true)]
			], typeMaticDelay, round(1000 / typeMaticRate), TimeUnit.MILLISECONDS)
		}

		fireMake(code, makeCode, false)
	}

	override released(KeyCode code) {

		this.typematicFuture?.cancel(false)

		val breakCode = code.toBreakCode

		fireBreak(code, breakCode)
	}

	override addListener(Listener listener) {
		this.listeners.add(listener)
	}

	override removeListener(Listener listener) {
		this.listeners.remove(listener)
	}

	// IMPLEMENTATION
	private def int[] toMakeCode(KeyCode code) {

		val set = scanCodeSet

		val result = switch set {
			case SET_1:
				code.set1ScanCode
			case SET_2:
				code.set2ScanCode
			case SET_3:
				code.set3ScanCode
			case SET_USB:
				code.setUsbScanCode
			default:
				throw new UnsupportedOperationException('''Unknown scan code set: «set»''')
		}

		if (result == null) {
			throw new UnsupportedOperationException('''«set» support is not yet implemented!''')
		}

		result
	}

	private def int[] toBreakCode(KeyCode code) {

		val set = scanCodeSet

		val makeCode = code.toMakeCode

		if (set == SET_1 || set == SET_2 && code == PAUSE) {
			return null
		}

		val result = switch set {
			case SET_1:
				makeCode.toSet1BreakCode
			case SET_2:
				makeCode.toSet2BreakCode
			case SET_3:
				makeCode.toSet3BreakCode
			case SET_USB:
				makeCode
			default:
				throw new UnsupportedOperationException('''Unknown scan code set: «set»''')
		}

		if (result == null) {
			throw new UnsupportedOperationException('''«set» support is not yet implemented!''')
		}

		result
	}

	private def int[] toSet1BreakCode(int[] makeCode) {

		// TODO check if pre-calculating these values gives a performance improvement
		if (makeCode.head == 0xe0) {
			#[0xe0] + makeCode.tail.map[0x80 + it]
		} else {
			makeCode.map[0x80 + it]
		}
	}

	private def int[] toSet2BreakCode(int[] makeCode) {

		// TODO check if pre-calculating these values gives a performance improvement
		if (makeCode.head == 0xe0) {
			#[0xe0, 0xf0] + makeCode.tail.map[0x80 + it]
		} else {
			#[0xf0] + makeCode.map[0x80 + it]
		}
	}

	private def int[] toSet3BreakCode(int[] makeCode) {
		null
	}

	private def void fireMake(KeyCode keyCode, int[] makeCode, boolean typematic) {
		this.listeners.forEach[it.fireMake(keyCode, makeCode, typematic)]
	}

	private def void fireBreak(KeyCode keyCode, int[] breakCode) {
		this.listeners.forEach[it.fireBreak(keyCode, breakCode)]
	}

}
