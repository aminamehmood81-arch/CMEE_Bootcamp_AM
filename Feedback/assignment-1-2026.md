# Assignment 1 feedback - Amina Mehmood

**Formative feedback | Rubric 2026.2**

The Unix work is concise and well explained. All five answers matched the independent checks, and the awk ratio is a perfectly reasonable alternative to bc here. Your converter code also has useful validation, quoted filenames and explicit conversion-error handling.

The main issue is a shared path assumption: both converters write to ../results, so they work on the assumption that you started inside code/. The brief asks for repository-root execution. Correct that convention in both scripts and in the README, then repeat the tests from a clean checkout. Avoid changing the otherwise useful checking simply to make the code look different.

Use your own TSV to make the tests more informative. Include an empty field and check its position in the output. Run the conversion twice and check that the output is replaced rather than duplicated. A successful exit is useful evidence, but the converted contents and their location are what establish that the task was done.

The README already gives purpose, examples and help sources. Add specific expected/observed results and the missing date/checking detail in the help account. Also ignore results/, alongside the sandbox and cache rules. Your task-specific commits make the work traceable; use the same approach for these focused revisions.

---

## Project structure

Relevant tracked layout (simplified; missing required paths are marked):

```text
README.md
.gitignore
code/  unixPrac1.txt, tabtocsv.sh, csvtospace.sh
data/fasta/  3 required files present
data/temperatures/  4 required files present
data/tab-example.tsv
results/  no files tracked; generated on run
sandbox/  no files tracked; optional
```

All required code and input paths are present under the root, with no tracked results or sandbox files. The ignore file already covers sandbox, caches and local environments, but it does not explicitly exclude results/.

Keep this layout and add the output-directory rule. Do not move assessed files back into week1/ or add a second project root to solve the converter path problem. Update the root README's examples so code/, data/ and the generated results/ work together from the stated starting directory.

**Assessed snapshot:** `b6fde4f5cfd4672125da05c42d02926b6aca49b8`
