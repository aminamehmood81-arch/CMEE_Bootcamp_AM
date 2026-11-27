# CMEE Computing Bootcamp portfolio – Amina Mehmood

My revised Assignments 1–3 and all in-class practice scripts, with the data they need.

**Run every command from the project root** (the folder that holds `code/` and `data/`).

---

## 1. Project structure

| Folder | What is in it | On GitHub? |
|---|---|---|
| `code/` | all scripts (`.sh`, `.py`, `.R`) and `unixPrac1.txt` | yes |
| `data/` | supplied input files from the MulQuaBio/MQB repository, unchanged | yes |
| `results/` | files the scripts make; scripts create it if missing | no |
| `sandbox/` | small test files | no |

Shell and R scripts start with a comment header. Python files start with a docstring.

## 2. Software

| Software | Version | Needed for |
|---|---|---|
| Bash | FILL | `.sh` scripts |
| Python 3 | FILL (standard library only) | `.py` scripts |
| R | FILL | `.R` scripts |
| R packages | `reshape2` 1.4.5, `dplyr` 1.2.1, `tidyr` 1.3.2, `ggplot2` 4.0.3 | Pound Hill and data wrangling scripts |
| ImageMagick (`convert`) | FILL | `tiff2_png.sh` only |

Tested on Ubuntu Linux. Missing R packages:
`Rscript -e 'install.packages(c("reshape2","dplyr","tidyr","ggplot2"))'`

## 3. Setup

```bash
git clone https://github.com/aminamehmood81-arch/CMEE_Bootcamp_AM.git
cd CMEE_Bootcamp_AM
mkdir -p results sandbox
```

---

## 4. Assignment 1: Unix and shell

**unixPrac1.txt**: answers to five FASTA questions. Copy each command into the terminal.
- Input: `data/fasta/`
- You should see: Q1 `27`, `127`, `78104` lines; Q2 the E. coli sequence without its header line; Q3 `4686137` characters; Q4 `21968` matches of `ATGC`; Q5 AT/GC ratio `0.969228`

**tabtocsv.sh**: changes tabs to commas.
```bash
bash code/tabtocsv.sh data/tab-example.tsv
```
- Output: `results/tab-example.tsv.csv` (2 lines, commas instead of tabs)
- No argument: usage message, exit 2. Missing file: exit 3.

**csvtospace.sh**: changes commas to spaces.
```bash
bash code/csvtospace.sh data/temperatures/1800.csv
```
- Output: `results/1800.csv.txt` (1825 lines, same as the input)
- No argument: exit 2. Missing file: exit 3. Empty fields are kept (`oak,,12` becomes `oak  12`).

## 5. Assignment 2: Silwood tree survey (Python)

**clean_silwood_trees.py**: checks every row of the tree survey against the rules in `data/silwood_trees_metadata.md`, keeps the valid rows, lists the invalid rows with reasons, and counts oaks by species.
```bash
python3 code/clean_silwood_trees.py
```
- Input (unedited): `data/silwood_trees_raw.csv`
- Outputs:
  - `results/silwood_trees_clean.csv`: valid rows, sorted by `record_id`
  - `results/silwood_tree_issues.csv`: invalid rows as `source_row,record_id,reasons` (`source_row` = line number in the file; the header is line 1)
  - `results/oak_species_counts.csv`: `species,count` for valid `Quercus` rows
- You should see: 36 rows in total, 24 valid and 12 invalid. Of the 24 valid records, 8 are oaks: `petraea` 4, `robur` 4.
- Running it again gives identical files.

**test_silwood_trees.py**
```bash
python3 code/test_silwood_trees.py
```
- You should see: `All tests passed`

### Pseudocode
```
load rows from data/silwood_trees_raw.csv (a list of dictionaries)

for each row, in file order, with source_row counting from 2 (line 1 is the header):
    call validate_record(row, source_row, accepted_ids)
    if the row was rejected:
        add to issues: source_row, cleaned record_id (if present), reasons joined with "; "
    else:
        add the cleaned six-column record to accepted
        add its record_id to accepted_ids (only after it passed every check)

sort accepted by record_id (issues are already in file order)

oaks:
    keep only accepted records where genus is "Quercus"
    count them by species, sorted by species
    if there are no oaks: the result is empty, so the file holds the header only

write the three files in results/, replacing any old ones
check: len(accepted) + len(issues) equals the number of data rows
```

`validate_record`
```
strip whitespace from every field (a missing cell counts as empty text)
errors = empty list

record_id:  empty -> "missing record_id"
            not uppercase "ST" + exactly 3 ASCII digits -> "invalid record_id"
            valid but already in accepted_ids -> "duplicate record_id"

location:   empty -> missing; not from the given metadata -> invalid
genus:      empty -> missing; not from the given metadata -> invalid
species:    empty -> missing; not from the given metadata -> invalid

pairing:    only if genus AND species were each recognised, and the pair is not
            permitted -> "invalid genus/species combination"

distance_m: empty -> missing; not a finite number -> invalid;
            otherwise not 0 < value <= 100 -> out of range

angle:      empty -> missing; not a finite number -> invalid;
            otherwise not 0 < value < 90 -> out of range

if errors is empty: return the cleaned record and []
otherwise: return None and the list of errors
```

## 6. Assignment 3: R

**TreeHeight.R**: calculates tree heights from distance and angle.
```bash
Rscript code/TreeHeight.R
```
- Input: `data/trees.csv` (120 trees). Output: `results/TreeHts.csv` (input columns plus `height_m`)
- You should see: two `Success` lines.
- Bad values (for example a distance of 150) stop the script with a clear error, and no file is written.

Pseudocode:
```
read data/trees.csv; inspect dimensions, header and first rows
stop with a clear error if any check fails:
    the three required columns exist
    Distance.m and Angle.degrees are numeric and finite
    0 < Distance.m <= 100
    0 < Angle.degrees < 90
height_m = Distance.m * tan(Angle.degrees * pi / 180), for every row
add height_m as the fourth column (other columns unchanged)
create results/ if missing; write results/TreeHts.csv without row numbers
check the output header and that it has 120 rows
```
Toy check: a tree 8 m away at 45° must be 8 m tall (tan 45° = 1). Step 5 of `run_get_TreeHeight.sh` checks this.

**get_TreeHeight.R**: the same, for any CSV file you name.
```bash
Rscript code/get_TreeHeight.R data/trees.csv
```
- Output: `results/trees_treeheights.csv` (named after the input file). It is identical to `results/TreeHts.csv`.
- Stops with a clear message for: no file, two files, a missing file, missing columns, non-numbers, and out-of-range values.

**run_get_TreeHeight.sh**: tests `get_TreeHeight.R`.
```bash
bash code/run_get_TreeHeight.sh
```
- You should see: `All checks passed!`
- It checks: 120 rows and the right header; a test tree at 8 m and 45° is 8 m tall; a second run replaces the file; no argument fails; an `Inf` angle fails and writes no file.

**pound_hill_analysis.R**: mean species richness per plot, by cultivation month.
```bash
Rscript code/pound_hill_analysis.R
```
- Inputs: `data/pound_hill_data.csv`, `data/pound_hill_meta_data.csv`
- Outputs: `results/pound_hill_plot_richness.csv` (12 plots), `results/pound_hill_plot_richness.pdf` (figure), `results/pound_hill_long.csv` (long-format data)
- You should see these means: March 7.81, May 9.65, October 7.61. My interpretation is at the end of the script.

Pseudocode:
```
1. Read data and metadata; inspect dimensions, types, first rows
2. Convert blanks to 0 (metadata: a blank is an observed absence)
3. Reshape wide to long (one row per species x quadrat)
4. Check: Count numeric, no NA, >= 0; count species, quadrats, plots (stop if plots != 12)
5. Quadrat table: group by Cultivation + Block + Plot + Quadrat; Richness = species with Count > 0
6. Plot table: group by Cultivation + Block + Plot; MeanRichness = mean(Richness); check 12 rows; save CSV
7. Figure: MeanRichness by Cultivation, one point per plot; save PDF
8. Interpretation: comment lines at the end of the script
```
Group work: I discussed the order of these steps with my assigned group (Booming Bonobos): inspect the data and metadata, convert blanks to zeros, reshape to long form, build the quadrat-level richness table, average quadrats within each plot, then draw the figure from the plot-level results.

---

## 7. Practice scripts

### Shell
| Script | Command | You should see |
|---|---|---|
| boilerplate.sh | `bash code/boilerplate.sh` | `This is a shell script!` |
| MyExampleScript.sh | `bash code/MyExampleScript.sh` | `Hello <your user name>` |
| variables.sh | `printf 'hello\n3 6\n' \| bash code/variables.sh` | `Their sum is: 9` (letters instead of numbers: error, exit 1) |
| CheckLabel.sh | `bash code/CheckLabel.sh oak; echo $?` | `Selected species: oak`, `0` (birch: exit 1; no label: exit 2) |
| CountLines.sh | `bash code/CountLines.sh data/tab-example.tsv` | `has 2 lines` (no argument: exit 2; missing file: exit 1) |

**ConcatenateTwoFiles.sh**: joins two files into a third.
```bash
printf 'oak\n' > sandbox/oak.txt
printf 'pine\n' > sandbox/pine.txt
bash code/ConcatenateTwoFiles.sh sandbox/oak.txt sandbox/pine.txt sandbox/combined.txt
```
- You should see: `oak` then `pine`. Wrong number of arguments: exit 2. Missing input: exit 1.

**tiff2_png.sh**: turns every `.tif` in the folder you are in into a `.png`. The data has no `.tif` files, so make one first. This is the only script run from inside another folder: it goes into `sandbox/images`, runs the script from there (`../../code`), then returns to the root.
```bash
mkdir -p sandbox/images
convert -size 10x10 xc:white sandbox/images/test.tif
cd sandbox/images && bash ../../code/tiff2_png.sh; ls; cd ../..
```
- You should see: `Converting test.tif`, then `test.png` in the list. A folder with no `.tif`: exit 1.

### Python
| Script | Command | You should see |
|---|---|---|
| boilerplate.py | `python3 code/boilerplate.py` | `This is a boilerplate` |
| using_name.py | `python3 code/using_name.py` | `This module's name is: __main__` |
| sysargv.py | `python3 code/sysargv.py oak 12` | `Number of arguments: 2`, `['oak', '12']` |
| MyExampleScript.py | `python3 code/MyExampleScript.py` | `The square of 2 is 4` |
| loops.py | `python3 code/loops.py` | 0–4, the list items, `0 1 12 123 1234`, then 1–100 |
| cfexercises1.py | `python3 code/cfexercises1.py` | `3.0`, `7`, `[1, 3, 5]`, `1 1 1`, `True`, `True` |
| cfexercises2.py | `python3 code/cfexercises2.py` | `hello` printed 4, 4, 14, 5, 8 and 6 times |
| control_flow.py | `python3 code/control_flow.py` | 5 example lines (`python3 -m doctest -v code/control_flow.py`: 3 passed) |
| test_control_flow.py | `python3 code/test_control_flow.py` | no error = all checks passed |
| debugme.py | `python3 code/debugme.py` | 19 `OK` lines, then `The result of dividing a number by zero is undefined` (the bug is on purpose; `try`/`except` catches it) |
| observations_practice.py | `python3 code/observations_practice.py` | `Site A: known total = 2, missing counts = 1`, `Site B: known total = 0, missing counts = 0` |
| test_observations_practice.py | `python3 code/test_observations_practice.py` | no error = all checks passed |

`test_observations_practice.py` also checks the boundary file (site C: total `None`, 2 missing; site D: 0) and the invalid file (refused). It shows that the MQB book's `suggested_total` gives 0 instead of `None` for site C; that failing check is kept as a comment.

### R
| Script | Command | You should see |
|---|---|---|
| boilerplate.R | `Rscript code/boilerplate.R` | `Argument 1 is a numeric`, then `Argument riki is a character` |
| basic_io.R | `Rscript code/basic_io.R` | no output; writes `results/MyData.csv` |
| control_flow.R | `Rscript code/control_flow.R` | `a is TRUE`, `Less than a half`, then the squares of 1 to 10 |
| break.R | `Rscript code/break.R` | `i equals 0` to `i equals 9` |
| next.R | `Rscript code/next.R` | 1, 3, 5, 7, 9 |
| r_conditionals.R | `Rscript code/r_conditionals.R` | `4 is even!`, `4 is a power of 2!`, `3 is a prime!`, `2 is a prime!` |
| try.R | `Rscript code/try.R` | some means and some `too few unique values!` errors; the script still finishes |
| browse.R | `Rscript code/browse.R < /dev/null` | `debug:` lines; writes `results/exponential_growth.pdf` (`< /dev/null` stops it pausing at `browser()`) |
| observations_practice.R | `Rscript code/observations_practice.R` | sites A, B, C (NA), D; the invalid file is refused; writes `results/known_totals.pdf` |
| data_wrang.R | `Rscript code/data_wrang.R` | writes `results/data_wrang_long.csv` (2419 × 6) |
| data_wrang_tidy.R | `Rscript code/data_wrang_tidy.R` | writes `results/data_wrang_tidy_long.csv` (same data as above) |

---

## 8. What I changed after feedback

**Assignment 1**
- `tabtocsv.sh`, `csvtospace.sh`: now write to `results/` and run from the project root (before: `../results`, only from `code/`).
- `unixPrac1.txt`: paths changed from `../data` to `data/`; answers rerun from the root.

**Assignment 2**
- Added tests: an invalid oak is not counted; a row with several problems lists all reasons; missing, invalid and boundary values for distance and angle; messy text is cleaned.

**Assignment 3**
- `run_get_TreeHeight.sh`: step 6 now stops with a message if it fails; old outputs are deleted before testing; added a test that invalid input fails and writes no file.
- `pound_hill_analysis.R`: interpretation rewritten from the plot-level values.

**Practice scripts**
- Added the missing scripts; renamed `loop.py` to `loops.py`.
- `cfexercises1.py`: fixed a `RecursionError` at 0 (base case `x <= 1`).
- Added input checks to four shell scripts, and headers or docstrings where missing.

## 9. Harmless messages

- R may print `incomplete final line found`: some supplied CSVs have no final newline. The data is read correctly; the files are left unchanged on purpose.
- If R asks `Save workspace image?`, type `n`.

## 10. Use of AI

**Claude (Anthropic)**, used as a tutor:
- Assignment 1 (October 2026): explanations, error meanings, hints.
- Assignment 2 (13–18 October 2026): Python concepts and errors; review of my pseudocode and drafts (Claude listed bugs, I fixed them); how `assert` and a test helper work (I wrote the expected values); Git help.
- Assignment 3 (19–23 October 2026): review of my pseudocode and drafts; concepts (nested design, `commandArgs`, `&` vs `&&`); error meanings; structure for the test script.
- Revision for Assignment 4 (21–27 November 2026): explanations, error meanings, review for the observations exercise and practice scripts, suggested input checks, organising my notes into this README, and a helped running a final test run of the README commands on a fresh clone.

**GitHub Copilot** only suggested code in `code/TreeHeight.R`, `code/get_TreeHeight.R` and `code/run_get_TreeHeight.sh`.

**How I checked:** I ran every command in this README from the project root and compared the output with what I expected.