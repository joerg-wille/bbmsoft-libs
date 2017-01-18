package net.bbmsoft.fxtended.annotations.binding;

public class RuntimeChecks {
	public static final boolean DO_CHECK_FX_THREAD = !"false".equalsIgnoreCase(System.getProperty("doCheckFxThread"));
}