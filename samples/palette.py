"""Palette showcase: open in nvim to see the syntax slots, run it to see all 16.

Which ANSI slot lights up where (colors/terminal.lua, Catppuccin's semantics):
    7  comments, italic (this docstring is a String though: slot 2)
    2  strings        9  numbers, constants, True/None    4  function names
    5  keywords, import, def, return, class     3  types, decorators
   13  escapes like \\n, f-string braces        6  operators
    1  diagnostics/undercurl on the deliberate undefined name near the bottom
"""

# TODO: a Todo cell -- slot 0 text on slot 3 background
# FIXME: same, and this whole line is slot 7 in italics

from __future__ import annotations

import sys
from dataclasses import dataclass, field
from typing import Iterator

ANSI_NAMES = ["black", "red", "green", "yellow", "blue", "magenta", "cyan", "white"]
GOLDEN_RATIO: float = 1.618_033_988
DEBUG = False
LIMIT = 0x1F  # hex literal, still slot 5


@dataclass(frozen=True)
class Swatch:
    """One palette entry, as the terminal reports it."""

    slot: int
    name: str
    bright: bool = False
    tags: list[str] = field(default_factory=list)

    @property
    def code(self) -> int:
        base = 90 if self.bright else 30
        return base + self.slot % 8

    def __str__(self) -> str:
        prefix = "bright " if self.bright else ""
        return f"\033[{self.code}m{prefix}{self.name:<8}\033[0m"


def swatches() -> Iterator[Swatch]:
    for bright in (False, True):
        for i, name in enumerate(ANSI_NAMES):
            yield Swatch(slot=i, name=name, bright=bright)


def render(items: list[Swatch], *, width: int = 4) -> str:
    """Rows of `width` swatches, each on its own background."""
    rows = []
    for start in range(0, len(items), width):
        chunk = items[start : start + width]
        rows.append("  ".join(f"\033[{s.code + 10}m  {s!s} \033[0m" for s in chunk))
    return "\n".join(rows)


def main(argv: list[str] | None = None) -> int:
    argv = argv if argv is not None else sys.argv[1:]
    try:
        width = int(argv[0]) if argv else 4
    except ValueError as exc:
        print(f"bad width: {exc}", file=sys.stderr)
        return 1
    if width <= 0 or width > 16:
        raise ValueError("width must be in 1..16")
    print(render(list(swatches()), width=width))
    print("fg on bg:", "the quick brown fox", "\tescaped tab\n")
    print(undefined_name)  # deliberate: DiagnosticError undercurl, slot 9
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
