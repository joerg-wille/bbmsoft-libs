package net.bbmsoft.fx.osk.impl.layout

import javafx.beans.DefaultProperty
import javafx.collections.FXCollections
import javafx.collections.ObservableList
import org.eclipse.xtend.lib.annotations.Accessors

import static extension net.bbmsoft.fxtended.extensions.BindingOperatorExtensions.*

@DefaultProperty("bindings")
class OSKLayout {

	@Accessors(PUBLIC_GETTER)
	final ObservableList<KeyBinding> bindings

	@Accessors(PUBLIC_GETTER)
	final SimpleKeyMap keyMap

	new() {

		bindings = FXCollections.observableArrayList
		keyMap = new SimpleKeyMap

		bindings >> [added, removed |

			removed.forEach[keyMap.remove(it)]
			added.forEach[keyMap.add(it)]
		]
	}

}