# First Bootcamp Assignment
## Purpose: It contains five FASTA questions, an improved tabtocsv.sh and a new csvtospace.sh. 

## Project Structure: The project root contains README.md, .gitignore and four directories: 
## code/: the assessed files 'unixPrac1.txt', 'tabtocsv.sh' and 'csvtospace.sh'. 
## data/: the supplied input files, holds .fasta files, .csv files and tab example.tsv.
## results and sandbox: These are only the part of local working directories, and are not part of the assessed submission.

## Language Used: BASH language on Unix system. For commands use ../data/fasta/..., so they must be run from code/.
## How to run: To run fasta files simply follow the right directory. To run tabtocsv.sh, run this command in bash terminal 'bash tabtocsv.sh ../data/tab-example.tsv'. To run csvtospace.sh for any desired temperature file, run this command in bash terminal 'bash csvtospace.sh ../data/temperatures/filename.csv'

## Extra utilities: tr ( from Shell scripting chapter), grep -o, awk (from unix linux stackexchange page and Bioinformatics stackexchange page). AI record: Claude,free model; used for explanations, error interpretation and hints.

## Data: The data files were copied unchanged from the MQB book repository (MulQuaBio/MQB, folder content/data/fasta).

# Second Bootcamp Assignment

## Second Bootcamp Assignment: Silwood tree-survey validation

### Purpose
`code/clean_silwood_trees.py` reads the synthetic tree survey, rejects invalid rows with reasons, writes the accepted records, and counts accepted oaks by species. The rules come from `data/silwood_trees_metadata.md`.

### Input and outputs
- Input: `data/silwood_trees_raw.csv` (united). Rules: `data/silwood_trees_metadata.md`(unedited)
- Outputs, created in `results/` (not committed):
  - `results/silwood_trees_clean.csv`: accepted records, six input columns, sorted by `record_id`, with canonical spelling.
  - `results/silwood_tree_issues.csv`: rejected rows as `source_row,record_id,reasons`, in file order. `source_row` is the file line number (header is line 1).
  - `results/oak_species_counts.csv`: `species,count` for accepted `Quercus` records only, sorted by species.

### How to run
From the project root:
```bash
python3 code/clean_silwood_trees.py
```
Running it twice replaces the three files and gives identical results. `results/` creates if missing.

### How to test
From the project root:
```bash
python3 code/test_silwood_trees.py
```
Prints `All tests passed`.

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
    if there are no oaks: the result is empty, so the file holds only the header only

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

genus:      empty -> missing; not from given metadata -> invalid

species:    empty -> missing; not from the given metadata -> invalid

pairing:    only if genus AND species were each recognised, and if pair is not peritted -> "invalid genus/species combination"

distance_m: empty -> missing; not a finite number -> invalid;
            otherwise not 0 < value <= 100 -> out of range

angle:      empty -> missing; not a finite number -> invalid;
            otherwise not 0 < value < 90 -> out of range

if errors is empty: return the cleaned record and []
otherwise: return None and the list of errors
```

### Results on the supplied survey
36 data rows: 24 accepted, 12 rejected (24 + 12 = 36). Oaks: `petraea` 4, `robur` 4. 


### AI record
**Tool:** Claude (Anthropic), used as a tutor.
**Dates:** 13 to 18 October 2026.

**What I asked for help with:**
- Understanding errors and concepts: bash vs Python vs IPython, `__file__`, the `__main__` guard, `NotImplementedError`, `SyntaxError`, `ValueError`, truthy/falsy, `None` vs `""`, `.get()` with `or ""`, `try`/`except`, `math.isfinite`, `enumerate`, and how `DictReader` fills short rows with `None`.
- Planning: reviewing my pseudocode against the metadata. 
- Debugging: Claude listed bugs in my drafts (missing colons, wrong reason text, a wrong range condition, missing return values, variable-name mistakes, a quoted string where a variable was needed). I made the fixes in my file.
- Documentation: phrasing for README sections.
- Tests: explanations of `assert`, a helper pattern. I wrote the expected values. 
- Git: the SSH push problem and a rebase after the remote had a new commit.

# Third Bootcamp Assignment

## Part one: Calculate tree heights

### Purpose
`code/TreeHeight.R` reads `data/trees.csv`, checks the input, and calculates each tree's height from its distance and angle.

### Input and output
- Input (unchanged): `data/trees.csv` (120 rows; `Species`, `Distance.m`, `Angle.degrees`)
- Output (recreated, not committed): `results/TreeHts.csv`, the three input columns in their original order plus `height_m`

### How to run
From the project root:
```bash
Rscript code/TreeHeight.R
```

### Pseudocode
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

### Check
Toy case: 8 × tan(45 × π/180) = 8. This check is done inside sandbox; which is not the part of assessed directory.

## Part two: Generalised tree-height script

### Purpose
`code/get_TreeHeight.R` does the same calculation on any CSV with the same three columns, given input path as command line argument.

### How to run
Run from project root
```bash
Rscript code/get_TreeHeight.R data/trees.csv
bash code/run_get_TreeHeight.sh
```

### Output
`results/<input-basename-without-.csv>_treeheights.csv`, for example `results/trees_treeheights.csv`. The input file is never overwritten.

### Errors reported
No argument, more than one argument, a missing file, missing columns, non-numeric or non-finite values, and out-of-range values.

### Tests
`code/run_get_TreeHeight.sh` creates a tiny test CSV in `sandbox/` (including a tree at 8 m and 45°), then checks:
- `data/trees.csv` gives 120 rows and the four-column header
- the sandbox file's output row count matches its input
- the 8 m / 45° tree has height 8 
- running the same input twice replaces the file
- running with no argument fails

## Part three: Pound Hill species richness

### How to run
From the project root:
```bash
Rscript code/pound_hill_analysis.R
```

### Inputs (unchanged)
- `data/pound_hill_data.csv`
- `data/pound_hill_meta_data.csv`

### Outputs (recreated by the script)
- `results/pound_hill_plot_richness.csv`: mean quadrat richness per plot (12 rows)
- `results/pound_hill_plot_richness.pdf`: plot-level mean richness by cultivation month
- `results/pound_hill_long.csv`: intermediate long-format data, for inspection

### Pseudocode
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


## AI use
**Tool:** Claude (Anthropic), used as a tutor, 19–23 October 2026.

**What I asked for help with:**
- Planning: reviewing my pseudocode for both tree-height scripts and Pound Hill.
- Concepts: the nested design and why plots, not quadrats, give treatment-level replication; `commandArgs`, `basename`, `identical()` versus `==`, `&` versus `&&`.
- Errors: explaining R and bash error messages.
- Code review: Claude pointed out bugs in my `TreeHeight.R` and `get_TreeHeight.R` drafts (wrong use of `&&`, an inverted range check). I made the fixes.
- Test script: Claude gave me the structure and reviewed my drafts.
- Documentation: help structuring and wording this README.

**What I wrote myself:** the R scripts, the Pound Hill figure and the interpretation. 