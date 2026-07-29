# Changing the syntax

Three repositories are involved, and each one holds exactly one thing:

| what | where |
| --- | --- |
| the grammar, and the queries Zed reads | [tree-sitter-tau](https://github.com/NicoNex/tree-sitter-tau) |
| the extension: which grammar, which language server | this one, [tau-zed](https://github.com/NicoNex/tau-zed) |
| the language server itself, `tau-lsp` | [tau](https://github.com/NicoNex/tau) |

The queries live in both of the first two: `queries/` in tree-sitter-tau is
where they are written, `languages/tau/` here is the copy Zed reads. Copy them
over whenever you change them, the step is in the recipe below.

## Changing the grammar or the highlighting

In `tree-sitter-tau`:

```sh
# The grammar itself is grammar.js, the highlighting is queries/highlights.scm.
npx tree-sitter generate            # rebuilds src/parser.c from grammar.js
npx tree-sitter test                # the cases in test/corpus
npx tree-sitter parse FILE.tau      # what one file parses to

# Nothing should come back: no file of the standard library may fail to parse.
for f in ~/tau/stdlib/*.tau ~/tau/stdlib/*/*.tau; do
    npx tree-sitter parse "$f" | grep -l ERROR
done
```

Commit `grammar.js`, `src/` and `queries/` together, and push. The commit has
to be on GitHub before the next step: Zed fetches the grammar from there, not
from your disk.

In `tau-zed`:

```sh
cp ../tree-sitter-tau/queries/*.scm languages/tau/
```

then in `extension.toml` put the commit you just pushed in `rev` and raise
`version`:

```toml
version = "0.0.14"

[grammars.tau]
repository = "https://github.com/NicoNex/tree-sitter-tau"
rev = "the full sha of the commit"
```

## Trying it in Zed

`zed: install dev extension` from the command palette, and pick this
directory. Zed clones the grammar at that `rev`, builds it to wasm and loads
the queries from `languages/tau/`. It rebuilds on every change to this
directory, so leave it installed while working.

`debug: open syntax tree view` from the palette shows the parse tree of the
file next to it and follows the cursor. An `ERROR` node means the grammar is
missing something, and the word is not highlighted because nothing parsed it,
not because a query is wrong.

## What the pieces are

- `languages/tau/config.toml` — the name of the language, which files it
  claims, the comment marker, the brackets to close.
- `languages/tau/highlights.scm` — what gets which colour. A later pattern
  loses against an earlier one on the same range, so the general
  `(identifier) @variable` sits at the bottom of the file.
- `languages/tau/brackets.scm`, `indents.scm`, `outline.scm` — the pairs to
  jump between, where a new line lands, and what shows up in the outline.
- `extension.toml` — the grammar to build and the language server to run.
- `src/lib.rs` — finds `tau-lsp` on the PATH, or in `~/.local/bin`, and starts
  it.

## Publishing

Zed's extension registry is a repository of its own: fork
[zed-industries/extensions](https://github.com/zed-industries/extensions),
bump the submodule under `extensions/tau` to the commit you want published,
run `pnpm sort-extensions`, and open a pull request. The `version` in
`extension.toml` is what the registry shows, so raise it before you do.
