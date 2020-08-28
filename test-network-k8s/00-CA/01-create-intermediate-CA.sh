#!/bin/bash

if [[ -z $1 ]] ; then
  cat <<EOF
$0 <org>
example:
$0 org1 
EOF

  exit 1
fi

org=$1
subj="/C=CN/ST=Beijin/L=TW/O=$org.example.com/CN=ica.$org.example.com"
rca_home="$PWD/ca/$org/root"
rca_cnf="$rca_home/openssl.cnf"
ica_home="$PWD/ca/$org/intermediate"
cnf_template="$PWD/cnf/intermediate-ca.cnf"

[ -d $ica_home ] || mkdir -p $ica_home;

pushd $ica_home
  cat "$cnf_template" | sed "s:^dir.*:dir = $ica_home:" > openssl.cnf
  mkdir certs crl csr newcerts private;
  chmod 700 private;
  touch index.txt;
  echo 1000 > serial;
  echo 1000 > crlnumber;

  echo ">> Create private/intermediate.key.pem ##"
  openssl ecparam -name prime256v1 -genkey -noout \
    -out private/intermediate.key.pem
  chmod 400 private/intermediate.key.pem

  echo ">> Create csr/intermediate.csr.pem"
  openssl req -new -sha256 \
    -key private/intermediate.key.pem \
    -out csr/intermediate.csr.pem \
    -subj "$subj"

  echo ">> Create certs/intermediate.cert.pem"
  openssl ca -batch \
    -config "$rca_cnf" \
    -extensions v3_intermediate_ca \
    -days 365 -notext -md sha256 \
    -in csr/intermediate.csr.pem \
    -out certs/intermediate.cert.pem;
  chmod 444 certs/intermediate.cert.pem;

  echo ">> Output certs/intermediate.cert.pem"
  openssl x509 -noout -text \
        -in certs/intermediate.cert.pem;

  echo ">> Verify certs/intermediate.cert.pem"
  openssl verify -CAfile "$rca_home/certs/ca.cert.pem" \
        certs/intermediate.cert.pem

  echo ">> Create ca chain: certs/ca-chain.cert.pem"
  cat certs/intermediate.cert.pem \
      "$rca_home/certs/ca.cert.pem" > certs/ca-chain.cert.pem;

  chmod 444 certs/ca-chain.cert.pem;

popd
