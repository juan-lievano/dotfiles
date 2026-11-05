# cordelia

Ear training in the terminal. Every key press is written down; nothing on
screen says whether you were right, the voice just gives the answer.
Repo: ~/Documents/Developing/cordelia (`cordelia` is a wrapper that runs it, no
reinstall after edits). Data: `data/` inside it (gitignored).

## Degrees (a note over a drone, name its scale degree)

| Command                                   | Does                                                       |
|-------------------------------------------|------------------------------------------------------------|
| `cordelia`                                | 2 min, 50 BPM, the degrees you asked last time, random key |
| `cordelia major`                          | 1 2 3 4 5 6 7                                              |
| `cordelia minor`                          | 1 2 b3 4 5 b6 b7                                           |
| `cordelia all`                            | the twelve: 1 b2 2 b3 3 4 b5 5 b6 6 b7 7                   |
| `cordelia 1 2 5 6`                        | any list of degrees; a new list is a new exercise          |
| `cordelia minor --minutes 5 --key A`      | anything that isn't a subcommand means `degrees`           |
| `cordelia degrees --bpm 40 --voice Samantha` | slower; any `say -v ?` voice                            |

Keys: `1`-`7`, or `h , . n e i l` under the fingers. The same key twice is
the flat: `33` = b3, `..` = b3, `77` = b7. Backspace undoes. The last key
before the voice counts. Esc stops, everything before it is kept.

Each question: note (2 beats), silence (2 beats, answer here), the voice
says it, the note again, a beat of rest. The session opens with tonic,
fifth, tonic an octave up.

## Melody (a short melody over a drone, type it back)

| Command                                   | Does                                                       |
|-------------------------------------------|------------------------------------------------------------|
| `cordelia melody`                         | 5 min, 55 BPM, the level you played last (1 at first)      |
| `cordelia melody 1`                       | four notes on 1 2 3                                        |
| `cordelia melody 2`                       | four notes on 1 to 5, half the moves stepwise              |
| `cordelia melody 2 --key G --singer chengu` | singer `jennifer` (default) or `chengu`                  |

Keys: `1`-`8`, or `h , . n e i l` for 1-7. Type the notes as you hear
them; the melody is sung twice with clicks between, then the answer is
sung. Backspace corrects; the last four typed before the singing count.

## Chords (a chord on a random root, name its quality)

| Command                                   | Does                                                       |
|-------------------------------------------|------------------------------------------------------------|
| `cordelia chords`                         | 4 min, 50 BPM, the level you played last (1 at first)      |
| `cordelia chords 1`                       | maj min sus4 aug 5, arpeggiated before you answer          |
| `cordelia chords 2`                       | dom7 maj7 min7 dim7 m7b5, arpeggiated before               |
| `cordelia chords 3`                       | all ten, root an octave down, arpeggiated before           |
| `cordelia chords 4` / `5` / `6`           | the same three sets, arpeggio only after the answer        |

The session opens with the cheat sheet for its level. Keys and spellings
(against the major scale):

| Key | Chord | Spelling      | Key | Chord | Spelling        |
|-----|-------|---------------|-----|-------|-----------------|
| `M` | maj   | 1 3 5         | `d` | dom7  | 1 3 5 b7        |
| `m` | min   | 1 b3 5        | `j` | maj7  | 1 3 5 7         |
| `s` | sus4  | 1 4 5         | `n` | min7  | 1 b3 5 b7       |
| `a` | aug   | 1 3 #5        | `o` | dim7  | 1 b3 b5 bb7     |
| `5` | 5     | 1 5           | `h` | m7b5  | 1 b3 b5 b7      |

Sevenths from most to least tense (Luegers): dim7, dom7, m7b5, maj7, min7.
min7 is a minor chord with a major triad on top; m7b5 is a minor 6 chord
with the bass moved; dim7 is stacked minor thirds with no root feeling.
No drone here: the root is always the lowest note.

## Flags for every drill

| Flag                  | Does                                                              |
|-----------------------|-------------------------------------------------------------------|
| `--minutes 5`         | length                                                            |
| `--bpm 40`            | slower beat (degrees 50, melody 55, chords 50 by default)         |
| `--tag headphones`    | sticky: this and every later session; `--tag none` clears         |
| `--seed 7`            | the same questions again                                          |
| `--keep-wav`          | keep the session audio in `data/sessions/`                        |
| `--midi t.mid`        | also write the score as MIDI                                      |

## Afterwards

| Command                                   | Does                                                       |
|-------------------------------------------|------------------------------------------------------------|
| `cordelia review`                         | replay the last session's misses, each with its answer     |
| `cordelia review 12 --render r.wav`       | a given session, to a file instead of playing              |
| `cordelia stats`                          | the exercise you played last: right% histogram, confusions |
| `cordelia stats --full`                   | minutes by week and every exercise                         |
| `cordelia stats --mode chords`            | one mode; `--degrees minor`, `--key G`, `--tag x` filter   |
| `cordelia rescore`                        | rebuild every answer from the raw key presses              |
| `cordelia tags` / `cordelia data`         | the sticky tags; where the database lives                  |

An exercise in stats is `degrees <list>`, `melody <level>` or `chords <level>`.
The confusion matrix is rows asked, % of each answer, over all history.

## Data

| Table        | One row per                                                       |
|--------------|-------------------------------------------------------------------|
| `sessions`   | session: mode, config (key, degrees or level, bpm, keymap), tags, outcome |
| `items`      | question: the right label, onset ms, answer-window end, meta      |
| `keystrokes` | key press: ms since playback started, key name                    |
| `answers`    | question: answer, correct, latency (derived, `rescore` rebuilds)  |

Open it with `sqlite3 "$(cordelia data)/cordelia.db"`.
