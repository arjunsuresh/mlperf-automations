#!/bin/bash

#CM Script location: ${CM_TMP_CURRENT_SCRIPT_PATH}

#To export any variable
#echo "VARIABLE_NAME=VARIABLE_VALUE" >>tmp-run-env.out

#${CM_PYTHON_BIN_WITH_PATH} contains the path to python binary if "get,python" is added as a dependency



function exit_if_error() {
  test $? -eq 0 || exit $?
}

function run() {
  echo "Running: "
  echo "$1"
  echo ""
  if [[ ${CM_FAKE_RUN} != 'yes' ]]; then
    eval "$1"
    exit_if_error
  fi
}

#Add your run commands here...
# run "$CM_RUN_CMD"
CUR=$PWD
DATA_DIR=${CM_DATA_DIR:-"$PWD/data"}

cd ${CM_RUN_DIR}
mkdir -p ${DATA_DIR}/tfrecords
cmd="python3 create_pretraining_data.py \
   --input_file=${CM_BERT_DATA_DOWNLOAD_DIR}/results4 \
   --output_file=${DATA_DIR}/tfrecords/part-00000-of-00500 \
   --vocab_file=${CM_BERT_CONFIG_FILE_PATH} \
   --do_lower_case=True \
   --max_seq_length=512 \
   --max_predictions_per_seq=76 \
   --masked_lm_prob=0.15 \
   --random_seed=12345 \
   --dupe_factor=10"
run "$cmd"
