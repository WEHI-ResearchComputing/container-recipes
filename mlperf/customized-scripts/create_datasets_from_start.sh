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

export BERT_PREP_WORKING_DIR="${BERT_PREP_WORKING_DIR}"

to_download=${1:-"wiki_only"} # By default, we don't download BooksCorpus dataset due to recent issues with the host server

mkdir -p /workspace/bert/data/download/nvidia_pretrained
#SQuAD Large Checkpoint
	echo "Downloading SQuAD Large Checkpoint"
	cd /workspace/bert/data/download/nvidia_pretrained && \
		wget --content-disposition https://api.ngc.nvidia.com/v2/models/nvidia/bert_tf_ckpt_large_qa_squad11_amp_384/versions/19.03.1/zip -O bert_tf_ckpt_large_qa_squad11_amp_384_19.03.1.zip \
		 && unzip bert_tf_ckpt_large_qa_squad11_amp_384_19.03.1.zip -d bert_tf_squad11_large_384 && rm bert_tf_ckpt_large_qa_squad11_amp_384_19.03.1.zip

#SQuAD Base Checkpoint
cd /workspace/bert/data/download/nvidia_pretrained && \
	wget --content-disposition https://api.ngc.nvidia.com/v2/models/nvidia/bert_tf_ckpt_base_qa_squad11_amp_128/versions/19.03.1/zip -O bert_tf_ckpt_base_qa_squad11_amp_128_19.03.1.zip \
	 && unzip bert_tf_ckpt_base_qa_squad11_amp_128_19.03.1.zip -d bert_tf_squad11_base_128 && rm bert_tf_ckpt_base_qa_squad11_amp_128_19.03.1.zip

#Pretraining Large checkpoint
cd /workspace/bert/data/download/nvidia_pretrained && \
	wget --content-disposition https://api.ngc.nvidia.com/v2/models/nvidia/bert_tf_ckpt_large_pretraining_amp_lamb/versions/19.03.1/zip -O bert_tf_ckpt_large_pretraining_amp_lamb_19.03.1.zip \
	&& unzip bert_tf_ckpt_large_pretraining_amp_lamb_19.03.1.zip -d bert_tf_pretraining_large_lamb && rm bert_tf_ckpt_large_pretraining_amp_lamb_19.03.1.zip

python3 ${BERT_PREP_WORKING_DIR}/bertPrep.py --action download --dataset squad
python3 ${BERT_PREP_WORKING_DIR}/bertPrep.py --action download --dataset google_pretrained_weights
python3 ${BERT_PREP_WORKING_DIR}/bertPrep.py --action download --dataset google_pretrained_weights  # Redundant, to verify and remove
