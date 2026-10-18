#!/usr/bin/env python3
"""Validate and clean the synthetic Silwood tree survey."""

from __future__ import annotations

import csv
import math
from pathlib import Path
from typing import Iterable



PROJECT_ROOT = Path(__file__).resolve().parents[1]
INPUT_PATH = PROJECT_ROOT / "data" / "silwood_trees_raw.csv"
RESULTS_DIR = PROJECT_ROOT / "results"

INPUT_FIELDS = [
    "record_id",
    "location",
    "genus",
    "species",
    "distance_m",
    "angle_degrees",
]
ISSUE_FIELDS = ["source_row", "record_id", "reasons"]
OAK_COUNT_FIELDS = ["species", "count"]


def load_records(path: Path = INPUT_PATH) -> list[dict[str, str]]:
    """Read the survey and check its column names."""
    with path.open(newline="", encoding="utf-8") as source:
        reader = csv.DictReader(source)
        if reader.fieldnames != INPUT_FIELDS:
            raise ValueError(
                f"Expected columns {INPUT_FIELDS}, found {reader.fieldnames}"
            )
        return list(reader)


def validate_record(
    row: dict[str, str],
    source_row: int,
    accepted_ids: set[str],
) -> tuple[dict[str, str] | None, list[str]]:
    """Clean one record, or return the reasons it cannot be used."""

    # checks for one survey
    errors = []

    # 1. removing whitespaces
    record_id = (row.get("record_id") or  "").strip()
    location = (row.get("location") or "").strip()
    genus = (row.get("genus") or "").strip()
    species = (row.get("species") or "").strip()

    # 2. Checks for the record_id 
    if not record_id:
        errors.append("missing record_id")
    elif len(record_id) == 5 and record_id.startswith("ST") and record_id[2:].isdigit() and record_id.isascii(): #because isdigit() also accepts non-ASCII digits
        if record_id in accepted_ids:
            errors.append("duplicate record_id")
    else:
        errors.append("invalid record_id")

    # 3. Validation for location
    location_dict = {
        "silwood bottom": "Silwood Bottom",
        "nash's field": "Nash's Field",
        "manor house": "Manor House",
        "reactor wood": "Reactor Wood",
    }
    location_key = location.lower() # for case insensitivity
    
    if not location:
        errors.append("missing location")
    elif location_key in location_dict:
        location = location_dict[location_key] 
    else:
        errors.append("invalid location")

    # 4. Validation for genus
    genus_pass = None # required to pass only the recognised values for permitted pairing 
    genus_dict = {
        "quercus": "Quercus",
        "acer": "Acer",
        "betula": "Betula",
        "fagus": "Fagus",
        "fraxinus": "Fraxinus",
    }
    genus_key = genus.lower() # for case insensitivity
    
    if not genus:  
        errors.append("missing genus")
    elif genus_key in genus_dict:
        genus = genus_dict[genus_key]
        genus_pass = genus
    else:
        errors.append("invalid genus") 

    # 5. Validation for species
    species_pass = None # required to pass only the recognised values for permitted pairing
    species_dict = {
        "robur": "robur",
        "petraea": "petraea",
        "pseudoplatanus": "pseudoplatanus",
        "pendula": "pendula",
        "sylvatica": "sylvatica",
        "excelsior": "excelsior",
    }
    species_key = species.lower()
    
    if not species:
        errors.append("missing species")
    elif species_key in species_dict:
        species = species_dict[species_key]
        species_pass = species
    else:
        errors.append("invalid species")

    # 6. Check for permitted taxon pairs
    permitted_pairs = {
        ("Quercus", "robur"),
        ("Quercus", "petraea"),
        ("Acer", "pseudoplatanus"),
        ("Betula", "pendula"),
        ("Fagus", "sylvatica"),
        ("Fraxinus", "excelsior"),
    }
    if genus_pass is not None and species_pass is not None:
        if (genus_pass, species_pass) not in permitted_pairs:
            errors.append("invalid genus/species combination")

    # 7. numerical checks with order of -> missing values, then unconvertible, then non-finite, then range 
    distance_m = (row.get("distance_m") or "").strip() # to prevent false invalid report
    
    if not distance_m:
        errors.append("missing distance_m")
    else:
        try:
            distance_m = float(distance_m)
        except ValueError:
            errors.append("invalid distance_m")
        else:
            if not math.isfinite(distance_m):
                errors.append("invalid distance_m")
            elif not 0 < distance_m <= 100:
                errors.append("distance_m out of range")

    angle_degrees = (row.get("angle_degrees") or "").strip() #to prevent false invalid report
    if not angle_degrees:
        errors.append("missing angle_degrees")
    else:
        try:
            angle_degrees = float(angle_degrees)
        except ValueError:
            errors.append("invalid angle_degrees")
        else:
            if not math.isfinite(angle_degrees):
                errors.append("invalid angle_degrees")
            elif not 0 < angle_degrees < 90:
                errors.append("angle_degrees out of range")
    if errors:
        return None, errors
    return {
        "record_id": record_id,
        "location": location,
        "genus": genus,
        "species": species,
        "distance_m": str(distance_m), # to covert them back to str
        "angle_degrees": str(angle_degrees)}, []


def process_records(
    rows: Iterable[dict[str, str]],
) -> tuple[list[dict[str, str]], list[dict[str, str]]]:
    """Clean records into accepted rows and issue reports."""
    accepted = []
    issues = []
    accepted_ids = set()

    for source_row, row in enumerate(rows, start=2): # because line 1 is header
        record, reasons = validate_record(row, source_row, accepted_ids)
        if record is None:
            issues.append({
                "source_row": source_row,
                "record_id": (row.get("record_id") or "").strip(),
                "reasons": "; ".join(reasons),

            })
        else:
            accepted.append(record)
            accepted_ids.add(record["record_id"])

    return sorted(accepted, key=lambda r: r["record_id"]), issues
            

def summarise_oaks(clean_records: Iterable[dict[str, str]]) -> list[dict[str, str]]:
    """Count accepted oak records by species."""
    # counting all the accepted records
    counts = {}

    for record in clean_records:
        if record["genus"] != "Quercus":
            continue
        species = record["species"]
        counts[species] = counts.get(species, 0) +1

    return [
        {"species": species,"count": str(counts[species])}
        for species in sorted(counts) 
    ]

def write_csv(
    path: Path,
    fieldnames: list[str],
    rows: Iterable[dict[str, str]],
) -> None:
    """Write rows to a CSV file, replacing an older copy."""
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="", encoding="utf-8") as destination:
        writer = csv.DictWriter(destination, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def main() -> None:
    """Clean the survey and write the three result files."""
    clean_records, issues = process_records(load_records())
    oak_counts = summarise_oaks(clean_records)

    write_csv(
        RESULTS_DIR / "silwood_trees_clean.csv",
        INPUT_FIELDS,
        clean_records,
    )
    write_csv(
        RESULTS_DIR / "silwood_tree_issues.csv",
        ISSUE_FIELDS,
        issues,
    )
    write_csv(
        RESULTS_DIR / "oak_species_counts.csv",
        OAK_COUNT_FIELDS,
        oak_counts,
    )


if __name__ == "__main__":
    main()
