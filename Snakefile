configfile: 'config.yaml'
DESIGNS, = glob_wildcards(config['INPUTDIR']+"/{design}.pdb")
rule all:
	input: f"{config['OUTDIR']}/{config['OUTFILENAME']}"

rule extract_features:
	input: config['INPUTDIR']+"/{design}.pdb"
	output: config['OUTDIR']+"/rosetta_features/{design}.pkl.gz"
	singularity: f"{config['SINGULARITY_PATH']}/solvit.sif"
	shell:
		"""
		dirpath=`dirname {output}`
		echo $dirpath
		python scripts/extract_features.py {input} --output_path $dirpath
		"""
		
rule run_solvit:
	input: expand(config['OUTDIR']+"/rosetta_features/{design}.pkl.gz",design=DESIGNS)
	output: temp(f"{config['OUTDIR']}/raw.csv")
	singularity: f"{config['SINGULARITY_PATH']}/solvit.sif"
	shell:
		"""
		input_dir_name=`dirname {input[0]}`
		outputdir=`dirname {output}`

		/app/solubility_pred/solubility_pred/./solubility_pred_app.py --ensemble_name ens_010_sol_102_esl_rosetta_off_m036_ff --rosetta_data_path $input_dir_name --models_path models --output $outputdir
		fname=`find $outputdir -type f -name "*_enesemble.csv" -printf '%T@ %p\n' | sort -n | tail -1 | cut -d' ' -f2- `
		cp $fname {output}
		rm -rf $outputdir/solubility_pred_app__v133*
		"""
rule format_result_csv:
	input:f"{config['OUTDIR']}/raw.csv"
	output: f"{config['OUTDIR']}/{config['OUTFILENAME']}"
	run:
		import pandas as pd
		import os
		df = pd.read_csv(input[0])
		resdict = dict()
		num = 0
		for c in df.columns:
			if c.count('prob_test_preds') > 0:
				resdict[c] = f"prob_model_{num}"
				num+=1
		df.rename(columns=resdict,inplace=True)
		cols = ['protein_id'] + list(resdict.values())
		df[cols].to_csv(output[0],index=False)

