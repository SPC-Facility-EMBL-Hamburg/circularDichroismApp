import pytest

from cif_to_pdb import cif_to_pdb


def test_cif_to_pdb_conversion():

    cif_file = "./www/1a6m.cif"
    pdb_file = "test.pdb"

    # Convert CIF to PDB
    cif_to_pdb(cif_file, pdb_file)

    # Verify that the PDB file was created
    with open(pdb_file, 'r') as f:
        content = f.read()
        assert "ATOM" in content, "PDB file does not contain ATOM records"

    # Clean up
    import os
    os.remove(pdb_file)