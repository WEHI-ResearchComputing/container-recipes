#!/bin/bash

# Copyright (c) 2019 NVIDIA CORPORATION. All rights reserved.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#SBATCH -c 24 --mem-per-cpu=5G --gres=gpu:A100:1 --ntasks-per-node=1 -N 1 -p gpuq_large --qos=bonus
module load apptainer/1.1.0
bert_model=${1:-"large"}
num_gpu=${SLURM_GPUS_ON_NODE:-"8"}

if [ "$bert_model" = "large" ] ; then
    export BERT_DIR=data/download/nvidia_pretrained/bert_tf_pretraining_large_lamb
else
    export BERT_DIR=data/download/nvidia_pretrained/bert_tf_squad11_base_128
fi

echo  "BERT directory set as " $BERT_DIR

init_checkpoint="$BERT_DIR/model.ckpt"
learning_rate=5e-6

#Edit to save logs & checkpoints in a different directory
RESULTS_DIR=`pwd -P`/results-2A100
mkdir results-2A100
if [ ! -d "$RESULTS_DIR" ] ; then
   echo "Error! $RESULTS_DIR directory missing."
   exit -1
fi
echo "Results directory set as " $RESULTS_DIR

LOGFILE="${RESULTS_DIR}/squad_training_benchmark_bert_${bert_model}_gpu_${num_gpu}.log"

export SQUAD_DIR=data/download/squad/v1.1
epochs="2.0"
echo "Squad directory set as " $SQUAD_DIR

echo "Training performance benchmarking for BERT $bert_model from $BERT_DIR" >> $LOGFILE
echo "Precision Sequence Length   Batch size  Performance(sent/sec)" >> $LOGFILE

for seq_len in 128 384; do

    if [ "$seq_len" = "128" ] ; then
        doc_stride=64
    else
        doc_stride=128
    fi

    for batch_size in 1 2 4; do
        for use_fp16 in "--amp" "--noamp"; do
            res_dir=${RESULTS_DIR}/bert_${bert_model}_gpu_${num_gpu}_sl_${seq_len}_prec_${use_fp16}_bs_${batch_size}
            mkdir -p $res_dir
            tmp_file="${res_dir}/${task}_training_benchmark.log"

            srun apptainer exec \
                -B /vast \
                -B /stornext \
                --nv \
                -B ${RESULTS_DIR}:/results \
                -B `pwd -P`/download:/workspace/bert/data/download \
                --pwd /workspace/bert \
                bert_tensorflow_21.09-tf1-py3.sif \
                    python run_squad.py \
                        --vocab_file=$BERT_DIR/vocab.txt \
                        --bert_config_file=$BERT_DIR/bert_config.json \
                        --init_checkpoint=$init_checkpoint \
                        --do_train=True \
                        --train_file=$SQUAD_DIR/train-v1.1.json \
                        --train_batch_size=$batch_size \
                        --learning_rate=$learning_rate \
                        --num_train_epochs=$epochs \
                        --max_seq_length=$seq_len \
                        --doc_stride=$doc_stride \
                        --output_dir=$res_dir \
                        --horovod \
                        "$use_fp16" \
                        --use_xla | tee $tmp_file

            perf=`cat $tmp_file | grep -F 'Throughput Average (sentences/sec) =' | head -1 | awk -F'= ' '{print $2}' | awk -F' sen' '{print $1}'`
            echo "$use_fp16 $seq_len  $batch_size $perf" >> $LOGFILE

        done
    done
done
