#!/bin/bash

script_path=$(readlink -e $0)

cur_dir=$(dirname ${script_path})
conf_dir=${cur_dir}/configs
work_dir=${cur_dir}/workspace

root_ca_dir=root_ca_perm_key
root_ca_key_file=root_ca_key
root_cert_perm_file=root_cert.pem

web_cert_dir=output_certs
web_cert_key_file=web_cert_key
web_cert_csr_file=web_cert.csr

# clear former web certs
bash ${cur_dir}/setup_workspace.sh reset > /dev/null 2>&1

echo "go"
mkdir -p ${work_dir}
pushd ${work_dir} > /dev/null 2>&1

echo "gonna create web cert private key..."
openssl genpkey -algorithm rsa -pkeyopt rsa_keygen_bits:1024 -out ${work_dir}/${web_cert_dir}/${web_cert_key_file}

echo "gonna create web cert csr..."
openssl req -new -key ${work_dir}/${web_cert_dir}/${web_cert_key_file} -config ${conf_dir}/csr_and_sign.cnf -out ${work_dir}/${web_cert_csr_file}

echo "gonna sign web cert csr..."
openssl ca -config ${conf_dir}/csr_and_sign.cnf -name cert_sign -in ${work_dir}/${web_cert_csr_file}

echo "gonna combine root cert..."
cat ${work_dir}/${web_cert_dir}/*.pem ${work_dir}/${root_ca_dir}/${root_cert_perm_file} > ${work_dir}/${web_cert_dir}/combined_cert.pem

echo "done"
popd > /dev/null 2>&1
