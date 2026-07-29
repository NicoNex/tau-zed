; Comments

(comment) @comment

; Keywords

[
  "fn"
  "if"
  "else"
  "for"
  "return"
  "import"
  "tau"
] @keyword

; break and continue are whole expressions rather than words inside one, so
; they are captured by their node.
(break) @keyword
(continue) @keyword

; Literals

(integer) @number
(float) @number
(boolean) @constant.builtin
(null) @constant.builtin

(string) @string
(raw_string) @string
(escaped_string) @string
(escape_sequence) @string.escape

; The braces of an interpolation belong to the string, what is between them is
; ordinary code and is highlighted as such.
(interpolation
  "{" @punctuation.special
  "}" @punctuation.special)

; Functions
;
; A function has no name of its own: it is a value, and its name is whatever
; it was assigned to.
(assignment
  left: (identifier) @function
  right: (function))

(assignment
  left: (member property: (identifier) @function)
  right: (function))

(call
  function: (identifier) @function)

(call
  function: (member property: (identifier) @function.method))

; The builtins, which are functions nobody declared.
((identifier) @function.builtin
  (#match? @function.builtin "^(len|println|print|input|string|error|type|int|float|exit|append|new|failed|plugin|native|pipe|send|recv|close|hex|oct|bin|slice|keys|delete|bytes)$"))

(parameters (identifier) @variable.parameter)

; Objects and their fields

(member property: (identifier) @property)
(map_entry key: (identifier) @property)

; Everything else that is a name is a variable. It comes last because a
; capture only wins where nothing more precise matched.
(identifier) @variable

; Operators

[
  "="
  "+="
  "-="
  "*="
  "/="
  "%="
  "&="
  "|="
  "^="
  "<<="
  ">>="
  "+"
  "-"
  "*"
  "/"
  "%"
  "=="
  "!="
  "<"
  "<="
  ">"
  ">="
  "&&"
  "||"
  "!"
  "&"
  "|"
  "^"
  "~"
  "<<"
  ">>"
  "++"
  "--"
] @operator

; Punctuation

[
  "("
  ")"
  "["
  "]"
  "{"
  "}"
] @punctuation.bracket

[
  ","
  ":"
  ";"
  "."
] @punctuation.delimiter
