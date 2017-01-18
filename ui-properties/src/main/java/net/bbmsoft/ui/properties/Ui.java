package net.bbmsoft.ui.properties;

import java.lang.annotation.ElementType;
import java.lang.annotation.Target;

import javafx.beans.property.Property;

/**
 * Indicate that a {@link Property} should be implemented as a UiProperty
 * <p>
 * Note that the annotation itself doesn't have any effect by itself, only if it
 * is used in conjunction with a code generation framework like FXtended
 *
 * @author Michael Bachmann
 */
@Target(ElementType.FIELD)
public @interface Ui {
}
