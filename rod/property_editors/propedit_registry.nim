import nimx.view
import nimx.text_field

import rod.node
import rod.property_visitor
import variant
import tables

var propEditors = initTable[TypeId, proc(n: Node, v: Variant): View]()

proc registerPropertyEditor*[T](createView: proc(n: Node, setter: proc(s: T), getter: proc(): T): View) =
    propEditors[getTypeId(SetterAndGetter[T])] = proc(n: Node, v: Variant): View =
        let sng = v.get(SetterAndGetter[T])
        result = createView(n, sng.setter, sng.getter)

proc registerPropertyEditor*[T](createView: proc(setter: proc(s: T), getter: proc(): T): View) =
    propEditors[getTypeId(SetterAndGetter[T])] = proc(n: Node, v: Variant): View =
        let sng = v.get(SetterAndGetter[T])
        result = createView(sng.setter, sng.getter)

proc propertyEditorForProperty*(n: Node, title: string, v: Variant): View =
    let creator = propEditors.getOrDefault(v.typeId)
    result = View.new(newRect(6, 6, 328, 36))
    let label = newLabel(newRect(6, 6, 100, 36))
    label.textColor = newGrayColor(0.9)
    label.text = title & ":"
    result.addSubview(label)
    if creator.isNil:
        label.text = title & " - Unknown property"
    else:
        let editor = creator(n, v)
        var sz = result.frame.size
        sz.height = editor.frame.height
        editor.setFrameOrigin(newPoint(label.frame.width, 12))
        editor.setFrameSize(sz)
        sz = newSize(result.bounds.width - label.frame.width - 12, editor.frame.height)
        editor.setFrameSize(sz)
        editor.autoresizingMask = {afFlexibleWidth, afFlexibleMaxY}
        result.addSubview(editor)
