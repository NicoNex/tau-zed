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
(escaped_brace) @string.escape

; The braces of an interpolation belong to the string, what is between them is
; ordinary code and is highlighted as such.
(interpolation
  "{" @punctuation.special
  "}" @punctuation.special)

; Names
;
; Where two patterns capture the same node the LAST one wins, so these go from
; the most general to the most precise: the catch-all first, whatever knows
; better after it.

; Everything that is a name is a variable until something says otherwise.
(identifier) @variable

; The builtins, which are functions nobody declared. Here they are still bare
; names used as values; called ones are captured again at the end.
((identifier) @function.builtin
  (#match? @function.builtin "^(len|println|print|input|string|error|type|int|float|exit|append|new|failed|plugin|native|pipe|send|recv|close|hex|oct|bin|slice|keys|delete|bytes)$"))

(parameters (identifier) @variable.parameter)

; Objects and their fields

(member property: (identifier) @property)
(map_entry key: (identifier) @property)

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

; A called builtin, after the plain call so that it keeps its own colour.
((call
  function: (identifier) @function.builtin)
  (#match? @function.builtin "^(len|println|print|input|string|error|type|int|float|exit|append|new|failed|plugin|native|pipe|send|recv|close|hex|oct|bin|slice|keys|delete|bytes)$"))

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
