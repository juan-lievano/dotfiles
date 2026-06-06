# conda-specs-bkp (legacy)

Snapshot of the conda environments from the **old** macOS account
(`/Users/juanp.lievanok./miniconda3`, conda 25.5.1), exported 2026-06-06 before
starting fresh on the new account (`/Users/jplk`).

These are kept only as a reference. There is no conda installed on the new
account, and the conda-init block has been removed from `.zshrc`.

Each env has two files:
- `<env>.yml` — portable spec (no build pins, includes pip deps). Cross-machine.
- `<env>.explicit.txt` — exact package URLs. Fastest exact recreate, same-platform (arm64) only.

## Recreate one if you ever need it

First install miniconda on the new account, e.g.:

```sh
curl -fsSL https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-arm64.sh -o /tmp/mc.sh
bash /tmp/mc.sh -b -p ~/miniconda3
~/miniconda3/bin/conda init zsh   # rewrites the conda block in .zshrc with correct paths
```

Then either:

```sh
conda env create -f playground.yml                  # portable
# or, for an exact rebuild:
conda create --name playground --file playground.explicit.txt
```

## Envs captured

| env | python |
|---|---|
| base | 3.12.2 |
| constructive-ranking | 3.11.11 |
| marker | 3.10.19 |
| newpobax | 3.10.18 |
| OAI | 3.13.5 |
| playground | 3.13.2 |
| pobax310 | 3.10.18 |
| pobaxRLC | 3.10.19 |
