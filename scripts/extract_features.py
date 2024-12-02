import argparse
import gzip
import pickle
from Bio.PDB import PDBParser, is_aa
from pathlib import Path
import numpy as np
import os
from Bio.SeqUtils import seq1
def parse_pdb(file_path):
    """Parse the PDB file to extract amino acid sequence and calculate pairwise distances."""
    parser = PDBParser(QUIET=True)
    structure = parser.get_structure('protein', file_path)
    
    # Extract sequence and coordinates
    sequence = ""
    coords = []
    for residue in structure.get_residues():
        if is_aa(residue, standard=True):  # Ensure residue is a standard amino acid
            sequence += seq1(residue.resname)
            if "CA" in residue:  # Use the alpha carbon for distance calculations
                coords.append(residue["CA"].coord)
    
    # Compute the pairwise distance matrix
    coords = np.array(coords)
    N = len(coords)
    pairwise_distances = np.zeros((N, N, 1))  # NxNx1 matrix
    for i in range(N):
        for j in range(N):
            pairwise_distances[i, j, 0] = np.linalg.norm(coords[i] - coords[j])
    
    return sequence, pairwise_distances

def main():
    parser = argparse.ArgumentParser(description="Process a PDB file to extract protein data.")
    parser.add_argument("pdb_file", help="Path to the input PDB file")
    parser.add_argument("--output_path", help="Path to the output file", type=Path, default=None)
    args = parser.parse_args()
    
    pdb_file = args.pdb_file
    base_name = os.path.basename(pdb_file).split(".")[0]
    print(base_name)
    if args.output_path:
        output_path = args.output_path
    else:
        output_path = Path(args.pdb_file).parent.parent
    output_file = output_path / f"{base_name}.pkl.gz"
    
    # Parse the PDB file
    aa_sequence, pairwise_distances = parse_pdb(pdb_file)
    
    # Create the dictionary
    data = {
        'pairwise_column_names': ['distance'],
        '1body_column_names': [],
        '2body_score_matrix': pairwise_distances,
        '1body_score_vector': [],
        'aa_sequence': aa_sequence,
    }
    
    # Write to a gzipped pickle file
    with gzip.open(output_file, 'wb') as f:
        pickle.dump(data, f)
    
    print(f"Data successfully written to {output_file}")

if __name__ == "__main__":
    main()

