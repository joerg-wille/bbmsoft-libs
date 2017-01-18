package net.bbmsoft.keyboard;

import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public enum KeyCode {

	ERROR(null, new int[] { 0x00 }, null, new int[] { 50 }, false),

	ESC(null, new int[] { 0x01 }, null, new int[] { 41 }, false),

	DIGIT_1(null, new int[] { 0x02 }, null, new int[] { 30 }, true),
	DIGIT_2(null, new int[] { 0x03 }, null, new int[] { 31 }, true),
	DIGIT_3(null, new int[] { 0x04 }, null, new int[] { 32 }, true),
	DIGIT_4(null, new int[] { 0x05 }, null, new int[] { 33 }, true),
	DIGIT_5(null, new int[] { 0x06 }, null, new int[] { 34 }, true),
	DIGIT_6(null, new int[] { 0x07 }, null, new int[] { 35 }, true),
	DIGIT_7(null, new int[] { 0x08 }, null, new int[] { 36 }, true),
	DIGIT_8(null, new int[] { 0x09 }, null, new int[] { 37 }, true),
	DIGIT_9(null, new int[] { 0x0a }, null, new int[] { 38 }, true),
	DIGIT_0(null, new int[] { 0x0b }, null, new int[] { 39 }, true),
	SPECIAL_1(null, new int[] { 0x0c }, null, new int[] { 45 }, true), // - _
	SPECIAL_2(null, new int[] { 0x0d }, null, new int[] { 46 }, true), // = +
	BACKSPACE(null, new int[] { 0x0e }, null, new int[] { 42 }, false),
	TAB(null, new int[] { 0x0f }, null, new int[] { 43 }, false),
	Q(null, new int[] { 0x10 }, null, new int[] { 20 }, true),
	W(null, new int[] { 0x11 }, null, new int[] { 26 }, true),
	E(null, new int[] { 0x12 }, null, new int[] { 8 }, true),
	R(null, new int[] { 0x13 }, null, new int[] { 21 }, true),
	T(null, new int[] { 0x14 }, null, new int[] { 23 }, true),
	Y(null, new int[] { 0x15 }, null, new int[] { 28 }, true),
	U(null, new int[] { 0x16 }, null, new int[] { 24 }, true),
	I(null, new int[] { 0x17 }, null, new int[] { 12 }, true),
	O(null, new int[] { 0x18 }, null, new int[] { 18 }, true),
	P(null, new int[] { 0x19 }, null, new int[] { 19 }, true),
	SPECIAL_3(null, new int[] { 0x1a }, null, new int[] { 47 }, true), // [ {
	SPECIAL_4(null, new int[] { 0x1b }, null, new int[] { 48 }, true), // ] }
	RETURN(null, new int[] { 0x1c }, null, new int[] { 40 }, false),
	CTRL_L(null, new int[] { 0x1d }, null, new int[] { 224 }, false),
	A(null, new int[] { 0x1e }, null, new int[] { 4 }, true),
	S(null, new int[] { 0x1f }, null, new int[] { 22 }, true),
	D(null, new int[] { 0x20 }, null, new int[] { 7 }, true),
	F(null, new int[] { 0x21 }, null, new int[] { 9 }, true),
	G(null, new int[] { 0x22 }, null, new int[] { 10 }, true),
	H(null, new int[] { 0x23 }, null, new int[] { 11 }, true),
	J(null, new int[] { 0x24 }, null, new int[] { 13 }, true),
	K(null, new int[] { 0x25 }, null, new int[] { 14 }, true),
	L(null, new int[] { 0x26 }, null, new int[] { 15 }, true),
	SPECIAL_5(null, new int[] { 0x27 }, null, new int[] { 51 }, true), // ; :
	SPECIAL_6(null, new int[] { 0x28 }, null, new int[] { 52 }, true), // ' "
	SPECIAL_7(null, new int[] { 0x29 }, null, new int[] { 53 }, true), // ` ~
	SHIFT_L(null, new int[] { 0x2a }, null, new int[] { 225 }, false),
	SPECIAL_8(null, new int[] { 0x2b }, null, new int[] { 49 }, true), // \ |
	Z(null, new int[] { 0x2c }, null, new int[] { 29 }, true),
	X(null, new int[] { 0x2d }, null, new int[] { 27 }, true),
	C(null, new int[] { 0x2e }, null, new int[] { 6 }, true),
	V(null, new int[] { 0x2f }, null, new int[] { 25 }, true),
	B(null, new int[] { 0x30 }, null, new int[] { 5 }, true),
	N(null, new int[] { 0x31 }, null, new int[] { 17 }, true),
	M(null, new int[] { 0x32 }, null, new int[] { 16 }, true),
	SPECIAL_9(null, new int[] { 0x33 }, null, new int[] { 54 }, true), // , <
	SPECIAL_10(null, new int[] { 0x34 }, null, new int[] { 55 }, true), // . >
	SPECIAL_11(null, new int[] { 0x35 }, null, new int[] { 56 }, true), // / ?
	SHIFT_R(null, new int[] { 0x36 }, null, new int[] { 229 }, false),
	NUMPAD_MULTIPLY(null, new int[] { 0x37 }, null, new int[] { 85 }, true),
	ALT_L(null, new int[] { 0x38 }, null, new int[] { 226 }, false),
	SPACE(null, new int[] { 0x39 }, null, new int[] { 44 }, true),
	CAPS_LOCK(null, new int[] { 0x3a }, null, new int[] { 57 }, false),
	F1(null, new int[] { 0x3b }, null, new int[] { 58 }, false),
	F2(null, new int[] { 0x3c }, null, new int[] { 59 }, false),
	F3(null, new int[] { 0x3d }, null, new int[] { 60 }, false),
	F4(null, new int[] { 0x3e }, null, new int[] { 61 }, false),
	F5(null, new int[] { 0x3f }, null, new int[] { 62 }, false),
	F6(null, new int[] { 0x40 }, null, new int[] { 63 }, false),
	F7(null, new int[] { 0x41 }, null, new int[] { 64 }, false),
	F8(null, new int[] { 0x42 }, null, new int[] { 65 }, false),
	F9(null, new int[] { 0x43 }, null, new int[] { 66 }, false),
	F10(null, new int[] { 0x44 }, null, new int[] { 67 }, false),
	NUM_LOCK(null, new int[] { 0x45 }, null, new int[] { 83 }, false),
	SCROLL_LOCK(null, new int[] { 0x46 }, null, new int[] { 71 }, false),
	NUMPAD_7(null, new int[] { 0x47 }, null, new int[] { 95 }, true),
	NUMPAD_8(null, new int[] { 0x48 }, null, new int[] { 96 }, true),
	NUMPAD_9(null, new int[] { 0x40 }, null, new int[] { 97 }, true),
	NUMPAD_MINUS(null, new int[] { 0x4a }, null, new int[] { 86 }, true),
	NUMPAD_4(null, new int[] { 0x4b }, null, new int[] { 92 }, true),
	NUMPAD_5(null, new int[] { 0x4c }, null, new int[] { 93 }, true),
	NUMPAD_6(null, new int[] { 0x4d }, null, new int[] { 94 }, true),
	NUMPAD_PLUS(null, new int[] { 0x4e }, null, new int[] { 87 }, true),
	NUMPAD_1(null, new int[] { 0x4f }, null, new int[] { 89 }, true),
	NUMPAD_2(null, new int[] { 0x50 }, null, new int[] { 90 }, true),
	NUMPAD_3(null, new int[] { 0x51 }, null, new int[] { 91 }, true),
	NUMPAD_0(null, new int[] { 0x52 }, null, new int[] { 98 }, true),
	NUMPAD_DECIMAL(null, new int[] { 0x53 }, null, new int[] { 99 }, true),
	ALT_SYS_RQ(null, new int[] { 0x54 }, null, new int[] { 154 }, false),
	F11(null, new int[] { 0x57 }, null, new int[] { 68 }, false),
	F12(null, new int[] { 0x58 }, null, new int[] { 69 }, false),
	NON_US_1(null, new int[] { 0xe0, 0xff }, null, new int[] { 50 }, false),
	NUMPAD_ENTER(null, new int[] { 0xe0, 0x1c }, null, new int[] { 88 }, false),
	CTRL_R(null, new int[] { 0xe0, 0x1d }, null, new int[] { 228 }, false),
	NUMPAD_DIVIDE(null, new int[] { 0xe0, 0x35 }, null, new int[] { 84 }, true),
	PRINT_SCREEN(null, new int[] { 0xe0, 0x37 }, null, new int[] { 70 }, false),
	ALT_R(null, new int[] { 0xe0, 0x38 }, null, new int[] { 230 }, false), // Alt Gr
	CTRL_BREAK(null, new int[] { 0xe0, 0x46 }, null, new int[] { 0 }, false),
	HOME(null, new int[] { 0xe0, 0x47 }, null, new int[] { 74 }, false),
	ARROW_UP(null, new int[] { 0xe0, 0x48 }, null, new int[] { 82 }, false),
	PAGE_UP(null, new int[] { 0xe0, 0x49 }, null, new int[] { 75 }, false),
	ARROW_LEFT(null, new int[] { 0xe0, 0x4b }, null, new int[] { 80 }, false),
	ARROW_RIGHT(null, new int[] { 0xe0, 0x4d }, null, new int[] { 79 }, false),
	END(null, new int[] { 0xe0, 0x4f }, null, new int[] { 77 }, false),
	ARROW_DOWN(null, new int[] { 0xe0, 0x50 }, null, new int[] { 81 }, false),
	PAGE_DOWN(null, new int[] { 0xe0, 0x51 }, null, new int[] { 78 }, false),
	INSERT(null, new int[] { 0xe0, 0x52 }, null, new int[] { 73 }, false),
	DEL(null, new int[] { 0xe0, 0x53 }, null, new int[] { 76 }, false),
	OS_L(null, new int[] { 0xe0, 0x5b }, null, new int[] { 227 }, false),
	OS_R(null, new int[] { 0xe0, 0x5c }, null, new int[] { 231 }, false),
	MENU(null, new int[] { 0xe0, 0x5d }, null, new int[] { 0 }, false),
	POWER(null, new int[] { 0xe0, 0x5e }, null, new int[] { 0 }, false),
	SLEEP(null, new int[] { 0xe0, 0x5f }, null, new int[] { 0 }, false),
	WAKE(null, new int[] { 0xe0, 0x63 }, null, new int[] { 0 }, false),
	PAUSE(null, new int[] {0xe1, 0x14, 0x77, 0xe1, 0xf0, 0x14, 0x77}, null, new int[] { 126 }, false);

	private static final Logger log = LoggerFactory.getLogger(KeyCode.class);

	private static Map<int[], KeyCode> set1Map;
	private static Map<int[], KeyCode> set2Map;
	private static Map<int[], KeyCode> set3Map;
	private static Map<int[], KeyCode> setUsbMap;

	private final int[] set1Code;
	private final int[] set2Code;
	private final int[] set3Code;
	private final int[] setUsbCode;

	private final boolean inputKey;

	private KeyCode(int[] set1Code, int[] set2Code, int[] set3Code, int[] setUsbCode, boolean isInputKey) {

		this.set1Code = set1Code;
		this.set2Code = set2Code;
		this.set3Code = set3Code;
		this.setUsbCode = setUsbCode;

		this.inputKey = isInputKey;

		cache(this);
	}

	public static KeyCode forScanCode(int[] scanCode, ScanCodeSet scanCodeSet) {

		switch (scanCodeSet) {
		case SET_1:
			return forSet1ScanCode(scanCode);
		case SET_2:
			return forSet2ScanCode(scanCode);
		case SET_3:
			return forSet3ScanCode(scanCode);
		case SET_USB:
			return forSetUsbScanCode(scanCode);
		default:
			throw new UnsupportedOperationException("Unknown scan code set " + scanCodeSet);
		}
	}

	public static KeyCode forSet1ScanCode(int[] scanCode) {
		return set1Map.get(scanCode);
	}

	public static KeyCode forSet2ScanCode(int[] scanCode) {
		return set2Map.get(scanCode);
	}

	public static KeyCode forSet3ScanCode(int[] scanCode) {
		return set3Map.get(scanCode);
	}

	public static KeyCode forSetUsbScanCode(int[] scanCode) {
		return setUsbMap.get(scanCode);
	}

	public int[] getSet1ScanCode() {
		return set1Code;
	}

	public int[] getSet2ScanCode() {
		return set2Code;
	}

	public int[] getSet3ScanCode() {
		return set3Code;
	}

	public int[] getSetUsbScanCode() {
		return setUsbCode;
	}

	public boolean isInputKey() {
		return this.inputKey;
	}


	private void cache(KeyCode keyCode) {

		KeyCode overrides;

		if (this.set1Code != null) {

			if(set1Map == null) {
				set1Map = new HashMap<>();
			}

			overrides = set1Map.putIfAbsent(this.set1Code, this);
			if (overrides != null) {
				log.warn("KeyCode {} overrides KeyCode {} in {} because it has the same scna code.", overrides, keyCode,
						ScanCodeSet.SET_1);
			}
		}

		if (this.set2Code != null) {

			if(set2Map == null) {
				set2Map = new HashMap<>();
			}

			overrides = set2Map.putIfAbsent(this.set2Code, this);
			if (overrides != null) {
				log.warn("KeyCode {} overrides KeyCode {} in {} because it has the same scna code.", overrides, keyCode,
						ScanCodeSet.SET_2);
			}
		}

		if (this.set3Code != null) {

			if(set3Map == null) {
				set3Map = new HashMap<>();
			}

			overrides = set3Map.putIfAbsent(this.set3Code, this);
			if (overrides != null) {
				log.warn("KeyCode {} overrides KeyCode {} in {} because it has the same scna code.", overrides, keyCode,
						ScanCodeSet.SET_3);
			}
		}

		if (this.setUsbCode != null) {

			if(setUsbMap == null) {
				setUsbMap = new HashMap<>();
			}

			overrides = setUsbMap.putIfAbsent(this.setUsbCode, this);
			if (overrides != null) {
				log.warn("KeyCode {} overrides KeyCode {} in {} because it has the same scna code.", overrides, keyCode,
						ScanCodeSet.SET_USB);
			}
		}

	}
}
