# Palette showcase

A note that touches most highlight groups. Open it in nvim after `termbg`
and read the colors off it; the slot each element should hit is in brackets.

## Headings are Title [3, bold]

Plain prose is the terminal foreground. **Bold** and *italic* and ***both***
keep the foreground and change weight. `inline code` is raw text [11].
A [link to the theme file](../.config/ghostty/themes/from-image) is
underlined [12], and so is a bare URL: <https://ghostty.org/docs/config>.

> A blockquote: the whole line is markup.quote [11].

1. An ordered list; the marker is Special [11].
2. Second item with a ~~strikethrough~~.
   - A nested bullet
   - [x] a done task
   - [ ] an open task

| slot | role                 | example use             |
|-----:|----------------------|-------------------------|
|    1 | red                  | errors, git deletions   |
|    2 | green                | strings, git additions  |
|    3 | yellow               | keywords, warnings      |
|    4 | blue                 | directories             |
|    5 | magenta              | numbers, constants      |
|    6 | cyan                 | types                   |
|    8 | bright black         | comments, selection     |

```python
# fenced code is raw text [11]; with a python parser injected it
# gets the same slots as palette.py
def area(r: float) -> float:
    """Circle."""
    return 3.14159 * r ** 2  # TODO: use math.pi
```

```sh
# fenced shell
for f in ~/Pictures/terminal/*.jpg; do echo "$f"; done
```

```diff
- a removed line   [1]
+ an added line    [2]
```

---

Horizontal rule above. Footnote here[^1]. And an HTML comment follows,
which should read as a comment [8]: <!-- hidden -->

[^1]: Footnotes are links too.
