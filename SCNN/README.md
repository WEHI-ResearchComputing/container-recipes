# Survival Convolutional Neural Networks

Original repo: https://github.com/PathologyDataScience/SCNN

built to help Jurgen Kriel: https://support.wehi.edu.au/a/tickets/216692

## Build the container

Make sure your working directory is somewhere with space - the container is around 9GB.

```
# setup your environment
export APPTAINER_CACHEDIR=<somewhere with space> # e.g. /vast/scratch/users/$USER/scache
export APPTAINER_TMPDIR=<somewhere with space> # e.g. /vast/scratch/users/$USER/stmp
mkdir $APPTAINER_CACHEDIR $APPTAINER_TMPDIR
module load apptainer/1.1.0

# build the container
apptainer build scnn.sif scnn.def
```
This creates the `scnn.sif` file in the current directory.

## Run the container

### Running the example
Do this in somewhere you have space! e.g., VAST Scratch
```
# making directories
mkdir results checkpoints tmp

# run the container
apptainer run --nv -B /vast \
	scnn-rs.sif model_train.py \
		-i /opt/images/train \                  # this is a directory inside the container
		-f /opt/scnn/inputs/all_dataset.csv \   # this is a file inside the container
		-r results \ 
		-d tmp \
		-t checkpoints
```
