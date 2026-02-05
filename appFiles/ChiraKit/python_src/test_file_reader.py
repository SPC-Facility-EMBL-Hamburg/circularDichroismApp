import pytest
import sys
from pathlib import Path

# Ensure ChiraKit root and its helper dirs are on sys.path so imports like
# `SelconsFunction` (in secondary_structure_estimation_files) and
# Dichroic-CD-model-main modules resolve when pytest runs from python_src.
base_dir = Path(__file__).resolve().parents[1]  # points to .../ChiraKit
sys.path.insert(0, str(base_dir))
sys.path.insert(0, str(base_dir / 'secondary_structure_estimation_files'))
sys.path.insert(0, str(base_dir / 'Dichroic-CD-model-main'))

from cdAnalyzer import (
    CdExperimentGeneral
)

# Mark the imported symbol as used (tests will use it when pytest is available)
# This avoids unused-import warnings from static checks in environments where tests aren't run
_dummy_use_of_CdExperimentGeneral = CdExperimentGeneral

# File paths assigned to variables for easier reuse in tests
file1 = "./www/jasco_thermal_ramp_example.csv"
file2 = "./www/jasco_thermal_ramp_one_wavelength.txt"
file3 = "./www/jasco_thermal_ramp_spectrum.txt"
file4 = "./www/Lys-Tscan-Oct2024_20241101.csv"
file5 = "./www/PaaA2_spectrum_25C.csv"
file6 = "./www/Pkng_WT_0.7mgperml_12.11.2019.csv"
file7 = "./www/R78907.d01"
file8 = "./www/R78907.d02"
file9 = "./www/test_spectrum.txt"
file10 = "./www/thermalRampChirascan.csv"
file11 = "./www/three-aviv-baseline.dat"
file12 = "./www/Trp_0.6mgperml_12.11.2019.csv"
file14 = "./www/test.csv"
file15 = "./www/test2.csv"
file16 = "./www/urea_chc.csv"
file17 = "./www/Myoglobin.csv"

# Convenience list containing all file variables
all_files = [
    file1, file2, file3, file4, file5, file6, file7, file8, file9, file10, file11, file12,
    file14, file15, file16, file17
]

def test_file_reading():

    for file in all_files:

        experiment = CdExperimentGeneral()
        assert(experiment.load_data(file))

        assert len(experiment.wavelength) > 0, f"Wavelengths not loaded for {file}"

