"""Summarise observations by site, handling missing and duplicate counts."""

import csv

def load_observations(path):
    """Load a CSV file of observations into a list of dictionaries."""
    with open(path, newline="", encoding="utf-8") as stream:
        return list(csv.DictReader(stream))

def parse_count(count_text):
    """Convert count text to a non-negative integer, or None if blank."""

    # Rule: input must be text
    if not isinstance(count_text, str):
        raise ValueError("count must be text")

    # Rule: blank text means a missing count
    if count_text == "":
        return None

    # Convert text to a whole number ("many" fails here by itself)
    count = int(count_text)

    # Rule: counts cannot be negative
    if count < 0:
        raise ValueError("count cannot be negative")

    return count

def summarise_site(rows, site):
    """Return (known_total, missing_count) for one site."""
    if not isinstance(rows, list):
        raise ValueError("rows must be a list of row dictionaries")
    if not isinstance(site, str) or site == "":
        raise ValueError("site must be non-empty text")

    # Check EVERY row (all sites) before counting anything
    for row in rows:
        if not isinstance(row, dict):
            raise ValueError("each row must be a dictionary")
        if set(row) != {"site", "date", "count"}:
            raise ValueError("row must have exactly site, date and count")
        if not all(isinstance(value, str) for value in row.values()):
            raise ValueError("site, date and count must be text")
        if row["site"] == "" or row["date"] == "":
            raise ValueError("site and date must not be empty")
        parse_count(row["count"])   # raises ValueError itself if the count is bad

    total = 0
    missing = 0
    has_known_count = False   # becomes True once we see a real count
    seen = set()              # to skip duplicates

    for row in rows:
        record = (row["site"], row["date"], row["count"])
        if record in seen:
            continue
        seen.add(record)
        if row["site"] == site:
            count = parse_count(row["count"])
            if count is None:
                missing = missing + 1    # a blank: count it as missing
            else:
                total = total + count  # a real count: add it
                has_known_count = True

    if not has_known_count:
        return (None, missing)        # nothing known → total unavailable
    return (total, missing)

def suggested_total(rows, site):
    """Book's deliberately faulty example, kept for the testing critique; not my solution."""
    total = 0
    seen = set()
    for row in rows:
        record = (row["site"], row["date"], row["count"])
        if record in seen:
            continue
        seen.add(record)
        if row["site"] == site and row["count"] != "":
            total += int(row["count"])
    return total

if __name__ == "__main__":
    rows = load_observations("data/bootcamp_observations.csv")
    for site in sorted({row["site"] for row in rows}):    # each site once, A then B
        known_total, missing_count = summarise_site(rows, site)
        print(f"Site {site}: known total = {known_total}, missing counts = {missing_count}")

