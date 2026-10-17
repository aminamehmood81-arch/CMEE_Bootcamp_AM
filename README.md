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

## Second Bootcamp Assignment

## Psuedo-code: 
load rows from data, it will load a list of dictionaries
for each row, in file order, with source_row counting from 2 as first one is header:
validate_record(row, source_row, accepted_ids)
if the row was rejected:
add to issues: source_row, record_id (cleaned, if present), reasons joined with "; " (added according to source row ID)
else:
add the cleaned six-column record to accepted
add its record_id to accepted_ids (only after it passed every check)
oak count:
keep only accepted records 
count them by species
sort by species
if there are no oaks: no result.
write these three files in results directory, replacing any old ones
check: len of accepted rows + len of issues should be equal to the number of data rows.

For cleaning: strip whitespace from every field 
record_id:  empty -> "missing record_id" not "ST" + exactly 3 digits (uppercase ST) -> "invalid record_id"
duplicate:  record_id already in accepted_ids -> "duplicate record_id"
location:   empty -> missing; not one of 4 -> invalid
genus:      empty -> missing; not a permitted genus -> invalid
species:    empty -> missing; not a permitted species -> invalid
pairing:    only if genus AND species were both recognised pairs, and the pair is not permitted -> "invalid genus/species combination"
distance_m: empty -> missing; not a finite number -> invalid; if not 0 < value <= 100 -> out of range
angle:      empty -> missing; not a finite number -> invalid; if not 0 < value < 90 -> out of range

if reasons is empty: return cleaned record, []
else: return None, with reasons
Give the records produce by validate records record to process data to separate accepted and rejected IDs.

## AI record
### Tool: Claude (Anthropic), used as a tutor.
**Date:** 17 October 2026 (and earlier sessions in the same week).

**What I asked for help with:**
- Understanding errors: what `NotImplementedError`, `ValueError` and
  `SyntaxError` mean.
- Concepts: the `if __name__ == "__main__"` guard, truthy/falsy values,
  `None` versus an empty string, `.get()` with `or ""`, `try`/`except`,
  `math.isfinite`, `enumerate`, and how `DictReader` fills short rows with `None`.
- Planning: reviewing my pseudocode against the metadata, and an explanation
  of the accepted/rejected flow.
- Debugging: Claude pointed out bugs in my draft of `validate_record`
  (missing colons, wrong reason text, a wrong range condition, missing
  return values). I made the fixes myself.
