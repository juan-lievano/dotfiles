# Global instructions

- Never add a `Co-Authored-By: Claude ...` trailer (or any Claude/Anthropic co-author attribution) to git commit messages or PR bodies.

## Writing for me (chat, PR text, summaries)

Cut to about a fifth of your first draft. One sentence per moving part, no
numbered walkthroughs, no sections I didn't ask for, no explaining design
choices. Open in everyday words; jargon only after the plain picture is set.
A file gets one line: what it does, mechanism in a parenthetical at most.

## Reference documents (PDFs I read myself)

When I ask for a document, guide, report, or explainer as a PDF, build it with LaTeX using my house style:

```latex
\documentclass{article}
\usepackage{jplkdoc}          % ~/Library/texmf/tex/latex/local/jplkdoc.sty
```

`jplkdoc.sty` sets the page (32x18cm, 16:9, thin margins — I read one page at a
time, full-screen, ~150cm away) and the 15pt body size, the palette, the table/list/verbatim setup, and
these macros: `\code`, `\jg`/`\glitem` (glossary links), `\NEW`/`\MOD`/`\EXI`,
and the `diagram` environment. Read the .sty before writing; don't re-declare
what it already provides.

**Content style:**
- Tables, diagrams and command blocks carry the content. Prose only where it
  earns its place — no throat-clearing, no restating the heading, no summary
  paragraph that repeats the table above it. Detail is good; wordiness is not.
- Define every jargon term once in a Glossary section and `\jg`-link every use
  of it in the body. Assume I know Python/ML and don't know the infra vocabulary.
- Diagrams are TikZ inside the `diagram` environment. Prefer wide, shallow
  layouts — the page is 16:9, so a tall vertical flow wastes it.
- Cite real evidence inline: `file.py:123`, exact command lines, verified values.
  Say when something was verified and when it's an assumption.
- **Date every claim about mutable state** — commit counts, deployment status,
  index coverage, corpus sizes, who owns what. A reference document outlives the
  moment it was written, and an undated snapshot reads as a standing fact and
  goes quietly wrong. Durable claims (from committed code) need no date; say
  which is which up front, and note that line numbers drift as the repo moves.
- Lead with a short table that answers the question I actually asked, before the
  detailed sections.
- **Don't omit internals on the assumption I already know them.** Either I do and
  I'll skim, or I don't and I needed them. Cover the mechanism, not just the
  interface. Ground it in real code, not in a plan document: for work that
  doesn't exist yet that means the code being ported *from* and the code it must
  plug *into*. Check `git show origin/main:<path>` when my checkout is behind.
  Flag anything the plan got wrong or left out.

**Build:** `latexmk -pdf file.tex` from anywhere; `~/.latexmkrc` puts aux files
in `build/` beside the source and the PDF next to it. Check the log for overfull
boxes >12pt and render pages to PNG to eyeball diagrams before calling it done.
