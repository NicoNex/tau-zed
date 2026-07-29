; The outline of a file is the functions in it: a function is a value, so the
; name shown is the name it was assigned to.
(assignment
  left: (identifier) @name
  right: (function)) @item

(assignment
  left: (member property: (identifier) @name)
  right: (function)) @item
