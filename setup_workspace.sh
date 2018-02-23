#!/bin/bash

function prepare_workspace() {
    mkdir -p ./output_certs
    mkdir -p ./root_ca_perm_key
    :> ./certs_db
    echo '01' > ./cert_serial
}

script_path=$(readlink -e $0)

cur_dir=$(dirname ${script_path})
conf_dir=${cur_dir}/configs
work_dir=${cur_dir}/workspace

option=$1

if [ "${option}" != "reset" -a "${option}" != "resetall" ]; then
    echo "option must be reset or resetall, ./script.sh (reset|resetall)"
    exit 233
fi

echo "go"
mkdir -p ${work_dir}
pushd ${work_dir} > /dev/null 2>&1

if [ "${option}" == "resetall" ]; then
    rm -rf ./*
    prepare_workspace

elif [ "${option}" == "reset" ]; then
    rm -f ./*.old
    rm -f ./certs_db.attr
    rm -f ./output_certs/*
    rm -f ./web_cert.csr
    prepare_workspace

fi

echo "done"
popd > /dev/null 2>&1
