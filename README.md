# SolvIT - Protein Solubility Prediction Deep Neural Network

SolvIT is a machine learning model designed to predict protein solubility in _Escherichia coli_ and aid in enzyme design by prioritizing high-solubility candidates from large design sets. This approach leverages a small graph neural networks (GNNs) to achieve state-of-the-art performance that rivals much larger models.

## Key Features

- **Deep Learning Integration**: Uses SolvIT, a GNN-based solubility classifier trained on _E. coli_ expression data.
- **Comprehensive Pipeline**: Automates feature extraction, solubility prediction, and result formatting.
- **Ease of Use**: Minimal setup requirements for running pre-defined protein designs.

---

## Prerequisites

Before running the SolvIT pipeline, ensure the following tools are installed:

- **Apptainer/Singularity**: Used for managing the containerized environments. [Installation Instructions](https://apptainer.org/docs/admin/main/installation.html)

### Additional Requirements
- Python environment specified in the `environment.yaml` file provided in this repository.

---

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/Enzymit/SolvIT.git
   cd SolvIT
   ```

2. Create and activate the Python environment:
   ```bash
   conda env create -f environment.yaml
   conda activate solvit_snakemake
   ```

3. Download the necessary Singularity container:
   ```bash
   ./singularity/download_sif.sh
   ```

---

## Usage


### Preliminary Configuration

Modify the `config.yaml` file as needed. Key parameters include:
- `OUTDIR`: Output directory for results.
- `INPUTDIR`: Directory containing input `.pdb` files.
- `SINGULARITY_PATH`: Path to the directory containing the downloaded `.sif` file. (usually `singularity`)
- `OUTFILENAME`: Name of the final output file.

### Running the Pipeline

1. Execute the Snakemake workflow:
   ```bash
   snakemake --cores <number_of_cores> --use-singularity
   ```
   Replace `<number_of_cores>` with the number of CPU cores to use.

### Output

The final results will be saved in the output directory specified in `config.yaml` under the name provided in `OUTFILENAME`.

---

## Pipeline Overview

The pipeline consists of the following steps:

1. **Feature Extraction**: Extracts features from input `.pdb` files using Rosetta and saves them in a compressed format.
2. **SolvIT Prediction**: Runs the solubility prediction model on the extracted features.
3. **Result Formatting**: Processes raw predictions into a user-friendly `.csv` file.

### Example Configuration (`config.yaml`)

```yaml
OUTDIR: "output"
INPUTDIR: "example"
SINGULARITY_PATH: "singularity"
OUTFILENAME: "solvit_out.csv"
```

---

## Citation

If you use SolvIT in your research, please cite:

Zimmerman et al., _Context-dependent design of induced-fit enzymes using deep learning generates well-expressed, thermally stable, and active enzymes_. PNAS, 2024. [DOI:10.1073/pnas.2313809121](https://doi.org/10.1073/pnas.2313809121)

---

## License

This project is licensed under the [GNU General Public License v3.0 (GPL-3.0)](https://www.gnu.org/licenses/gpl-3.0.en.html).

---

For any questions or issues, create a new issue in the repository.

