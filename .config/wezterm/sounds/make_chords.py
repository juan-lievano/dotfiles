#!/usr/bin/env python3
"""Generate short bell-like WAVs of the seventh-chord qualities, root C4.

The .wav files are regenerable output, not source: run this script to
(re)create them in this directory. Stdlib only.
"""

import math
import struct
import wave
from pathlib import Path

RATE = 44100
DURATION = 2.2       # seconds
STRUM = 0.14         # per-note stagger, low note first
DECAY = 0.55         # exponential decay time constant
C4 = 261.6256

# name -> semitone offsets from the root
CHORDS = {
    "maj7":    (0, 4, 7, 11),
    "dom7":    (0, 4, 7, 10),
    "min7":    (0, 3, 7, 10),
    "m7b5":    (0, 3, 6, 10),
    "dim7":    (0, 3, 6, 9),
    "minmaj7": (0, 3, 7, 11),
    "augmaj7": (0, 4, 8, 11),
}

# partial multiples and weights: fundamental plus a little 2nd/3rd for warmth
PARTIALS = ((1, 1.0), (2, 0.25), (3, 0.08))


def render(semitones):
    n = int(RATE * DURATION)
    samples = [0.0] * n
    for voice, st in enumerate(semitones):
        freq = C4 * 2 ** (st / 12)
        start = int(RATE * STRUM * voice)
        for i in range(start, n):
            t = (i - start) / RATE
            env = math.exp(-t / DECAY)
            s = sum(w * math.sin(2 * math.pi * freq * m * t) for m, w in PARTIALS)
            samples[i] += env * s
    peak = max(abs(s) for s in samples)
    return [s / peak * 0.8 for s in samples]


def main():
    outdir = Path(__file__).parent
    for name, semitones in CHORDS.items():
        path = outdir / f"{name}.wav"
        with wave.open(str(path), "wb") as w:
            w.setnchannels(1)
            w.setsampwidth(2)
            w.setframerate(RATE)
            w.writeframes(
                b"".join(struct.pack("<h", int(s * 32767)) for s in render(semitones))
            )
        print(path.name)


if __name__ == "__main__":
    main()
