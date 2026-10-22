# Assignment 2 formative feedback

This feedback is organised by the relevant computing bootcamp criteria. Use it to decide what is already working, what you need to investigate, and what to revise before the cumulative submission.

The full criteria are in the [Computing Bootcamp assessment rubric](https://github.com/MulQuaBio/MQB/blob/main/content/rubrics/Computing_Bootcamp_Rubric.md).

## 1. Repository organisation and workflow discipline

- Your root README, `.gitignore`, cleaning script, test script and supplied data files are in the expected locations. The supplied CSV and metadata are unchanged, giving you a reproducible starting point.

## 2. Code completeness and functional correctness

- Your cleaning script ran and generated all three outputs. Separately, output checks found that the clean records, issues and oak-count tables satisfied the required output format and contents on both test runs. The outputs are correct for the checked input; now make sure you can explain the method and test important edge cases.

## 3. Code quality and style

- Your `main()` function gives the program a clear overall structure by connecting loading, processing, summarising and writing. Keep these stages distinct as you revise; use descriptive names and add short comments where the reason for a validation check or data-cleaning step is not obvious.

## 4. Documentation

- Your root README is in place. Make it useful to someone opening the repository for the first time: explain what the cleaner does, how to run the script and tests from the repository root, and which three files it creates. Test the instructions in a newly cloned copy of your repository (a separate folder created with `git clone`): enter that folder and run each README command exactly as written. If something fails, correct the command or add the missing step.

## 5. Version-control practice

- Since the previous formative feedback was added, the saved history contains 7 non-merge commits. Messages such as `Add validate_record checks`, `Complete Implementation script`, `Add README for Assignment 2` and `Add test script for implementation script` show the work developing in understandable stages.
- Keep this pattern for the final revisions. Before each commit, use `git diff --staged` to check that it contains one coherent, working change, then write a concise message that names that change and, where it is not obvious, why it was needed.

## 8. Basic error handling and input validation

- Your separate test file ran successfully. Inspection identified tests for validation, accepted/rejected partitioning, sorting, duplicate handling, oak summaries and end-to-end execution. These give you useful checks to retain during revision.
- Run the existing tests after any revision, then regenerate and inspect the three outputs. If a new edge case reveals a problem, add a focused regression test; successful execution alone does not show that every important case is covered.

## 9. Problem-solving approach and method implementation

- Your program follows this route: `main()` calls `load_records()` to read the unchanged supplied CSV, then passes the rows to `process_records()`, which uses `validate_record()`. Accepted records are sorted by `record_id` and returned alongside issues; the cleaned collection feeds `summarise_oaks()`, and three `write_csv()` calls produce the outputs. The route from input to outputs is clear.
- No specific functional defect was identified in the supplied review. Focus revision on making the workflow explainable and checking reproducibility:
- Before final submission, make this check visible in your repository. In `code/test_silwood_trees.py`, add or refine a small assertion-based test with one valid and one invalid record. Check that `process_records()` places them in the cleaned and issues collections respectively. Then pass the returned cleaned collection to `summarise_oaks()` and check that the invalid record does not contribute. Briefly explain this flow in your root README.
