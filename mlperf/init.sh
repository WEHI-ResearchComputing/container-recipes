#!/bin/bash

CONTAINER_NAME=bert_tensorflow_21.09-tf1-py3.sif

set -ue

git submodule update
git submodule init

cp customized-scripts/create_datasets_from_start.sh DeepLearningExamples/TensorFlow/LanguageModeling/BERT/data/
cp customized-scripts/finetune_train_benchmark.sh DeepLearningExamples/TensorFlow/LanguageModeling/BERT/scripts/
cp customized-scripts/data_download.sh DeepLearningExamples/TensorFlow/LanguageModeling/BERT/scripts/

if [ ! -f ./${CONTAINER_NAME} ]
then
	apptainer build ${CONTAINER_NAME} bert_tensorflow_21.09-tf1-py3.def
fi

mkdir -p download
bash -x DeepLearningExamples/TensorFlow/LanguageModeling/BERT/scripts/data_download.sh
