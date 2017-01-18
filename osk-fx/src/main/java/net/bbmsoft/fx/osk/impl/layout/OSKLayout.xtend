package net.bbmsoft.fx.osk.impl.layout

import javafx.beans.DefaultProperty
import javafx.collections.FXCollections
import javafx.collections.ObservableList
import javafx.collections.ObservableMap
import net.bbmsoft.fxtended.annotations.binding.BindableProperty
import org.eclipse.xtend.lib.annotations.Accessors

import static extension net.bbmsoft.fxtended.extensions.BindingOperatorExtensions.*

@DefaultProperty("bindings")
class OSKLayout {

	@Accessors(PUBLIC_GETTER)
	final ObservableList<KeyBinding> bindings

	@Accessors(PUBLIC_GETTER)
	final ObservableMap<KeyCode, KeyBinding> keyMap

	@BindableProperty String name

	new() {

		bindings = FXCollections.observableArrayList
		keyMap = FXCollections.observableHashMap

		bindings >> [added, removed |

			removed.forEach[keyMap.remove(code)]
			added.forEach[keyMap.put(code, it)]
		]
	}
}