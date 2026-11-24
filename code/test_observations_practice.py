"""Checks for observations_practice.py."""

from observations_practice import load_observations, parse_count, summarise_site, suggested_total

# Normal case: ordinary count text becomes an integer.
assert parse_count("2") == 2

# Boundary case: zero is a valid known count.
assert parse_count("0") == 0

# Special valid case: blank text represents a missing count.
assert parse_count("") is None

# Failure cases: each invalid value must raise ValueError.
for invalid_count in ["-1", "many", 2]:
    try:
        parse_count(invalid_count)
    except ValueError:
        pass
    else:
        raise AssertionError(f"Invalid count accepted: {invalid_count!r}")

unique_rows = [
    {"site": "A", "date": "2026-10-01", "count": "2"},
    {"site": "A", "date": "2026-10-02", "count": "3"},
    {"site": "B", "date": "2026-10-01", "count": "9"},
]
assert summarise_site(unique_rows, "A") == (5, 0)

missing_rows = [
    {"site": "C", "date": "2026-10-01", "count": ""},
    {"site": "C", "date": "2026-10-02", "count": ""},
]
zero_rows = [{"site": "D", "date": "2026-10-01", "count": "0"}]
assert summarise_site(missing_rows, "C") == (None, 2)
assert summarise_site(zero_rows, "D") == (0, 0)
assert summarise_site([], "A") == (None, 0)
assert summarise_site(unique_rows, "Z") == (None, 0)
assert summarise_site(unique_rows + [unique_rows[0]], "A") == (5, 0)
assert summarise_site(missing_rows + [missing_rows[0]], "C") == (None, 2)

# File-based checks: real data
rows = load_observations("data/bootcamp_observations.csv")
assert summarise_site(rows, "A") == (2, 1)
assert summarise_site(rows, "B") == (0, 0)

boundary_rows = load_observations("data/bootcamp_observations_boundary.csv")
assert summarise_site(boundary_rows, "C") == (None, 2)
assert summarise_site(boundary_rows, "D") == (0, 0)
assert summarise_site(rows, "Z") == (None, 0)


# Failure checks: each bad input must raise ValueError
def expect_summary_error(rows, site="A"):
    try:
        summarise_site(rows, site)
    except ValueError:
        pass
    else:
        raise AssertionError("Expected ValueError, but the call succeeded")

invalid_rows = load_observations("data/bootcamp_observations_invalid.csv")
for invalid_row in invalid_rows:
    expect_summary_error([invalid_row])

expect_summary_error([{"site": "A", "count": "2"}])
expect_summary_error([{"site": "A", "date": "2026-10-01", "count": "2", "extra": "x"}])
expect_summary_error([{"site": "", "date": "2026-10-01", "count": "2"}])
expect_summary_error([{"site": "A", "date": "", "count": "2"}])
expect_summary_error([{"site": "A", "date": "2026-10-01", "count": 2}])
expect_summary_error(["not a row dictionary"])
expect_summary_error(None)
expect_summary_error(rows, "")
expect_summary_error(rows, 2)


# The input rows must not be changed by the function
original_rows = [row.copy() for row in rows]
summarise_site(rows, "A")
assert rows == original_rows 


# deliberately faulty suggested_total
assert suggested_total(rows, "A") == 2          # passes: ordinary data can't see the fault
assert suggested_total(rows, "B") == 0          # passes
assert summarise_site(boundary_rows, "C")[0] is None   # my function: correct
assert suggested_total(boundary_rows, "D") == 0        # observed zero stays zero: passes

# Deliberate failure: suggested_total returns 0 for C, but the rule says None (unavailable)
# assert suggested_total(boundary_rows, "C") is None

