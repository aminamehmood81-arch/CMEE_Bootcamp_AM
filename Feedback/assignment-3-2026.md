# Assignment 3 formative feedback

This feedback is organised using the [Computing Bootcamp rubric](https://mulquabio.github.io/MQB/rubrics/Computing_Bootcamp_Rubric.html). It does not award a mark; use it to decide what to revise and check before final submission.

## Criterion 1: Repository organisation & workflow discipline

- All required paths are present, and the supplied inputs are unchanged. Your `.gitignore` covers `results/` and `sandbox/`, with no generated results tracked. The Git messages describe specific changes.
- Before final submission, **Make the repeat-run test reliable.** In `run_get_TreeHeight.sh`, the second sandbox run is not checked for execution failure. An existing output could therefore retain the expected row count even if that run fails. Add the same explicit failure handling used for the earlier runs, then check that a failed command cannot lead to “All checks passed!”.

## Criterion 2: Code completeness & functional correctness

- The fixed and generalised tree-height programs each ran successfully. Separately, their generated CSVs matched the stated required output format and values. Your code shows the angle-to-radians conversion, input checks and output read-back checks. Your README describes an independent toy calculation, and the shell test implements a numerical check for that case; the separate sandbox calculation itself was not inspected.

## Criterion 3: Code quality & style

As you revise, keep names descriptive, use comments to explain decisions rather than restating code, and avoid repeating the same calculation in several places.

## Criterion 4: Documentation

- Your Assignment 3 README provides purposes, commands, output paths and pseudocode for the three routes.
- Before final submission, **Make the documented environment unambiguous.** The README’s opening section says commands must run from `code/`, whereas Assignment 3 uses the project root. Clarify that these instructions are assignment-specific and list the R packages used by Pound Hill: `reshape2`, `dplyr` and `ggplot2`. This helps someone reproduce the complete analysis without guessing the working directory or dependencies.

## Criterion 5: Version-control practice

Commit each functional revision with a short message that says what changed; this makes your development easier to follow than one large final commit.

## Criterion 8: Basic error-handling & input validation

Test an ordinary case and an invalid case for each tree-height route, and confirm both the message shown and whether an output file was created or changed.

## Criterion 9: Problem-solving approach & method implementation

- The Pound Hill table had the expected rows, plot identifiers and richness values. Your code explains why blanks represent absence and calculates quadrat richness before averaging within plots. When I opened the figure, I found readable labels and four plot-level points per treatment alongside the boxplots. This supports the route from observations to plot-level summaries, rather than treating quadrats as independent treatment replicates.
- Before final submission, **Check the interpretation against the plotted quantities.** Your comments identify a treatment pattern and within-treatment variation, but successful execution does not verify those statements. Compare each comment with the plot-level CSV and PDF, especially the claim about which month has the highest mean. Explain that the plotted quantity is mean quadrat richness within each plot, and distinguish descriptive differences from evidence of a treatment effect.

## Criterion 10: Learning progression demonstration

Use this feedback as a revision checklist. Make the changes in small, descriptive commits, then add a short README note explaining what you changed and how you checked it. This will make your development from this formative checkpoint visible in the final portfolio.

## Priorities before final submission

- From the directory containing `code/`, `data/` and the root `README.md`, rerun one ordinary and one invalid case for **each** tree-height program. The invalid runs stopped with distance-range and non-finite-value errors respectively; check the messages and confirm that no new result is written. Keep the two programs’ checks separate.
- Then rerun Pound Hill and compare the CSV with the PDF’s points, labels and biological interpretation. The automated check only confirmed that the PDF existed; I found the figure readable; now check each scientific claim against the plotted values.
