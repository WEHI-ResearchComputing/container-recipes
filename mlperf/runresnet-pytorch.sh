#!/bin/bash

#SBATCH -c 20 -p gpuq --mem-per-cpu=2G -N 2 -n 2
#SBATCH --gres=gpu:A30:4
#SBATCH --qos=bonus
#SBATCH --time=120

export MASTER_ADDR=$(hostname -I | grep -o '10.11.\w*.\w*')
export MASTER_PORT=$(get-unused-port)

echo "MASTER_ADDR=${MASTER_ADDR}, MASTER_PORT=${MASTER_PORT}"

export NCCL_DEBUG=WARN NCCL_SOCKET_IFNAME=bond1.1330 NCCL_IB_DISABLE=1

module purge
module load apptainer/1.1.0

srun bash -c 'apptainer run \
	--nv \
	--env NCCL_DEBUG=WARN \
	--env NCCL_SOCKET_IFNAME=bond1.1330 \
	--env NCCL_IB_DISABLE=1 \
	-B /vast \
	-B /stornext \
	../container-recipes/mlperf/imagenet_pytorch_21.09-py3.sif \
		python ../container-recipes/mlperf/DeepLearningExamples/PyTorch/Classification/ConvNets/multiproc.py --nproc_per_node=4 --nnodes 2 --node_rank ${SLURM_PROCID} --master_port ${MASTER_PORT} --master_addr ${MASTER_ADDR} \
			../container-recipes/mlperf/DeepLearningExamples/PyTorch/Classification/ConvNets/main.py \
				--arch resnet50 \
				--epochs 1 \
				--batch-size 224 \
				-j 10 \
				--print-freq 10 .'
