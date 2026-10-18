"""Tests for clean_silwood_trees.py.

Run from the project root: python3 code/test_silwood_trees.py
"""
import subprocess
import sys
from pathlib import Path

from clean_silwood_trees import (
    load_records, validate_record, process_records, summarise_oaks,
)


def make_row(**changes):
    """Return a valid raw row, with any fields overridden."""
    base = {"record_id": "ST001", "location": "Manor House", "genus": "Quercus",
            "species": "robur", "distance_m": "10", "angle_degrees": "45"}
    return {**base, **changes}

## Tests for validate records

def test_valid_row_is_accepted():
    record, reasons = validate_record(make_row(), 2, set())
    assert reasons == []
    assert record["location"] == "Manor House"
    assert float(record["distance_m"]) == 10
    assert float(record["angle_degrees"]) == 45


def test_record_id_missing_vs_invalid():
    cases = [
        ("", ["missing record_id"]),
        ("   ", ["missing record_id"]),
        ("st001", ["invalid record_id"]),
        ("ST12", ["invalid record_id"]),
        ("ST0123", ["invalid record_id"]),
        ("ST١٢٣", ["invalid record_id"]),
        ("ST999", []),
    ]
    for text, expected in cases:
        _, reasons = validate_record(make_row(record_id=text), 2, set())
        assert reasons == expected, f"record_id={text!r}"


def test_location_genus_species_missing_vs_invalid():
    cases = [
        ("location", "", ["missing location"]),
        ("location", "   ", ["missing location"]),
        ("location", "Old Orchard", ["invalid location"]),
        ("genus", "", ["missing genus"]),
        ("genus", "   ", ["missing genus"]),
        ("genus", "Quercuss", ["invalid genus"]),
        ("species", "", ["missing species"]),
        ("species", "   ", ["missing species"]),
        ("species", "xyz", ["invalid species"]),
    ]
    for field, text, expected in cases:
        _, reasons = validate_record(make_row(**{field: text}), 2, set())
        assert reasons == expected, f"{field}={text!r}"


def test_genus_species_pairing():
    cases = [
        ("Quercus", "robur", []),
        ("Quercus", "petraea", []),
        ("quercus", "ROBUR", []),
        ("Quercus", "pendula", ["invalid genus/species combination"]),
        ("Acer", "robur", ["invalid genus/species combination"]),
        ("", "robur", ["missing genus"]),
        ("Quercuss", "robur", ["invalid genus"]),
    ]
    for genus, species, expected in cases:
        _, reasons = validate_record(
            make_row(genus=genus, species=species), 2, set())
        assert reasons == expected, f"{genus!r} + {species!r}"


def test_duplicate_id_is_rejected():
    record, reasons = validate_record(make_row(), 2, {"ST001"})
    assert record is None
    assert reasons == ["duplicate record_id"]


# Tests for process_records

def test_process_records_lines_and_sorting():
    rows = [make_row(record_id="ST002"),
            make_row(record_id="bad"),
            make_row(record_id="ST001")]
    accepted, issues = process_records(rows)
    assert [r["record_id"] for r in accepted] == ["ST001", "ST002"]
    assert issues == [{"source_row": 3, "record_id": "bad",
                       "reasons": "invalid record_id"}]


def test_rejected_row_does_not_reserve_id():
    rows = [make_row(location="nowhere"), make_row()]
    accepted, issues = process_records(rows)
    assert len(accepted) == 1
    assert issues[0]["source_row"] == 2


def test_running_twice_gives_same_result():
    rows = [make_row(), make_row(record_id="bad")]
    assert process_records(rows) == process_records(rows)


# Tests for summarize oaks

def test_oak_counts():
    records = [
        {"genus": "Quercus", "species": "robur"},
        {"genus": "Quercus", "species": "robur"},
        {"genus": "Quercus", "species": "petraea"},
        {"genus": "Acer", "species": "pseudoplatanus"},
    ]
    assert summarise_oaks(records) == [
        {"species": "petraea", "count": "1"},
        {"species": "robur", "count": "2"},
    ]


def test_no_oaks_gives_empty_list():
    assert summarise_oaks([]) == []
    assert summarise_oaks([{"genus": "Acer", "species": "pseudoplatanus"}]) == []


# tests for correct survey report

def test_every_row_is_accepted_or_reported():
    rows = load_records()
    accepted, issues = process_records(rows)
    assert len(rows) == 36
    assert len(accepted) == 24
    assert len(issues) == 12
    assert len(accepted) + len(issues) == len(rows)


def test_import_does_not_run_program():
    code_dir = Path(__file__).resolve().parent
    result = subprocess.run(
        [sys.executable, "-c", "import clean_silwood_trees"],
        cwd=code_dir, capture_output=True, text=True)
    assert result.returncode == 0
    assert result.stdout == ""


if __name__ == "__main__":
    test_valid_row_is_accepted()
    test_record_id_missing_vs_invalid()
    test_location_genus_species_missing_vs_invalid()
    test_genus_species_pairing()
    test_duplicate_id_is_rejected()
    test_process_records_lines_and_sorting()
    test_rejected_row_does_not_reserve_id()
    test_running_twice_gives_same_result()
    test_oak_counts()
    test_no_oaks_gives_empty_list()
    test_every_row_is_accepted_or_reported()
    test_import_does_not_run_program()
    print("All tests passed")