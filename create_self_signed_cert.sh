#!/bin/bash

script_path=$(readlink -e $0)

cur_dir=$(dirname ${script_path})
conf_dir=${cur_dir}/configs
work_dir=${cur_dir}/workspace

root_ca_dir=root_ca_perm_key
root_ca_key_file=root_ca_key
root_cert_perm_file=root_cert.pem

if [ -e "${work_dir}/${root_ca_dir}/${root_ca_key_file}" -o -e "${work_dir}/${root_ca_dir}/${root_ca_key_file}" ]; then
    echo "it seems that self signed cert files exists"
    exit 233
fi

echo "go"
mkdir -p ${work_dir}/${root_ca_dir}
pushd ${work_dir}/${root_ca_dir} > /dev/null 2>&1

echo "gonna create root private key ..."
openssl genpkey -algorithm rsa -pkeyopt rsa_keygen_bits:1024 -out ${root_ca_key_file}

echo "gonna create root ca ..."
openssl req -new -x509 -key ${root_ca_key_file} -config ${conf_dir}/generate_self_signed_cert.cnf -out ${root_cert_perm_file}

echo "done"
popd > /dev/null 2>&1
